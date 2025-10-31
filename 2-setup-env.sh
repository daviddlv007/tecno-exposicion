#!/bin/bash
# Script "1-click" para configurar proyecto Laminas/Zend existente en /home/proyectos/tecno-exposicion
# Usa VirtualHost profesional y servicio de archivos via Apache

set -e

echo "🚀 Configurando entorno de Tecno Exposición..."

# 0️⃣ Variables
PROJECT_DIR="/home/proyectos/tecno-exposicion"
DOMAIN="tecno-exposicion.local"
VHOST_CONF="/etc/httpd/conf.d/tecno-exposicion.conf"

# 1️⃣ Verificar que el proyecto existe
if [ ! -d "$PROJECT_DIR/public" ]; then
    echo "❌ Error: Directorio $PROJECT_DIR/public no encontrado."
    exit 1
fi

# 2️⃣ Instalar repositorio Remi si no existe (para PHP 8.3 en Fedora 43)
if ! dnf repolist | grep -q remi; then
    echo "📦 Instalando repositorio Remi..."
    sudo dnf install -y https://rpms.remirepo.net/fedora/remi-release-43.rpm
fi

# 3️⃣ Habilitar PHP 8.3 desde Remi
echo "🐘 Habilitando PHP 8.3..."
sudo dnf module enable php:remi-8.3 -y

# 4️⃣ Instalar/Actualizar PHP y extensiones necesarias
echo "📥 Instalando PHP 8.3 y extensiones..."
sudo dnf install -y php php-cli php-mbstring php-json php-session php-xml php-pdo php-gd httpd curl unzip git

# Verificar versión de PHP
echo "✓ Versión de PHP:"
php -v

# 5️⃣ Instalar Composer si no está presente
if ! command -v composer &> /dev/null; then
    echo "📦 Instalando Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# 6️⃣ Instalar dependencias del proyecto
echo "📚 Instalando dependencias de Composer..."
cd "$PROJECT_DIR"
composer install --no-interaction

# 7️⃣ Ajustar permisos del proyecto
echo "🔐 Configurando permisos..."
sudo chown -R apache:apache "$PROJECT_DIR"
sudo chmod -R 755 "$PROJECT_DIR"
sudo chmod -R 775 "$PROJECT_DIR/data" 2>/dev/null || true  # Si existe carpeta data

# 8️⃣ Restaurar SELinux (si aplica)
if command -v restorecon &> /dev/null; then
    sudo restorecon -Rv "$PROJECT_DIR" 2>/dev/null || true
fi

# 9️⃣ Crear VirtualHost profesional
echo "⚙️  Configurando VirtualHost..."
sudo bash -c "cat > $VHOST_CONF" <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot "$PROJECT_DIR/public"

    <Directory "$PROJECT_DIR/public">
        Options FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Rewrite rules para router Laminas/Zend
        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} -s [OR]
            RewriteCond %{REQUEST_FILENAME} -l [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^.*$ - [NC,L]
            RewriteRule ^.*$ /index.php [NC,L]
        </IfModule>
    </Directory>

    <Directory "$PROJECT_DIR">
        Require all denied
    </Directory>

    ErrorLog /var/log/httpd/$DOMAIN-error.log
    CustomLog /var/log/httpd/$DOMAIN-access.log combined
    LogLevel warn
</VirtualHost>
EOF

# 🔟 Modificar /etc/hosts para resolver el dominio localmente
echo "📍 Configurando resolución DNS local..."
if ! grep -q "$DOMAIN" /etc/hosts; then
    sudo bash -c "echo '127.0.0.1   $DOMAIN www.$DOMAIN' >> /etc/hosts"
fi

# 1️⃣1️⃣ Habilitar mod_rewrite en Apache (necesario para Laminas router)
echo "🔌 Habilitando módulos de Apache..."
sudo a2enmod rewrite 2>/dev/null || sudo sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf || true

# 1️⃣2️⃣ Reparar /etc/httpd/run si es necesario
if [ -L /etc/httpd/run ] && [ ! -e /etc/httpd/run ]; then
    sudo rm -f /etc/httpd/run
fi
sudo mkdir -p /etc/httpd/run
sudo chown apache:apache /etc/httpd/run
sudo chmod 755 /etc/httpd/run

# 1️⃣3️⃣ Verificar sintaxis de Apache
echo "✓ Verificando configuración de Apache..."
sudo apachectl configtest

# 1️⃣4️⃣ Reiniciar Apache
echo "🔄 Reiniciando Apache..."
sudo systemctl restart httpd
sudo systemctl enable httpd

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ ¡Configuración completada exitosamente!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "🌐 Acceso al proyecto:"
echo "   URL: http://$DOMAIN/"
echo "   Logs de errores: /var/log/httpd/$DOMAIN-error.log"
echo "   Logs de acceso: /var/log/httpd/$DOMAIN-access.log"
echo ""
echo "📝 Próximos pasos:"
echo "   1. Asegúrate que /etc/hosts tiene la entrada para $DOMAIN"
echo "   2. Abre http://$DOMAIN/ en tu navegador"
echo "   3. Si hay errores, revisa los logs en /var/log/httpd/"
echo ""
