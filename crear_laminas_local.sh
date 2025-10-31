#!/bin/bash
# Script “1-click” para crear y servir un proyecto Laminas en Fedora 42/43 usando PHP <=8.3 en /home/proyectos/tecno-exposicion con VirtualHost profesional
set -e  # Terminar el script si ocurre un error

# 0️⃣ Detectar versión de Fedora
FEDORA_VERSION=$(cat /etc/fedora-release | grep -oE '[0-9]+$' || echo "42")

# 1️⃣ Instalar repositorio Remi para PHP <=8.3
if ! dnf repolist | grep -q remi; then
    echo "Instalando repositorio Remi..."
    sudo dnf install -y https://rpms.remirepo.net/fedora/remi-release-$FEDORA_VERSION.rpm || true
fi

# 2️⃣ Instalar la mejor versión de PHP <=8.3 y extensiones necesarias
PHP_VERSION=$(dnf list --showduplicates php | grep -Eo '[0-9]+\.[0-9]+' | grep -E '^8\.[0-3]$' | sort -V | tail -1)
if [ -n "$PHP_VERSION" ]; then
    echo "Instalando PHP $PHP_VERSION y extensiones..."
    sudo dnf install -y php php-cli php-mbstring php-json php-session httpd curl unzip git --allowerasing --nobest
else
    echo "Instalando la versión de PHP por defecto (no se detectó <=8.3)..."
    sudo dnf install -y php php-cli php-mbstring php-json php-session httpd curl unzip git
fi

# Verificar versión de PHP
echo "Versión de PHP instalada:"
php -v

# 3️⃣ Instalar Composer si no está presente
if ! command -v composer &> /dev/null; then
    echo "Instalando Composer..."
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# 4️⃣ Usar proyecto existente en /home/proyectos/tecno-exposicion
PROJECT_DIR="/home/proyectos/tecno-exposicion"
if [ ! -d "$PROJECT_DIR/public" ]; then
    echo "❌ Error: No existe $PROJECT_DIR/public. Cancela."
    exit 1
fi

# 5️⃣ Instalar dependencias del proyecto
cd "$PROJECT_DIR"
composer install --no-interaction

# 6️⃣ Ajustar permisos y SELinux
sudo chown -R apache:apache "$PROJECT_DIR"
sudo chmod -R 755 "$PROJECT_DIR"
if command -v restorecon &> /dev/null; then
    sudo restorecon -Rv "$PROJECT_DIR" 2>/dev/null || true
fi

# Crear directorio data para SQLite
mkdir -p "$PROJECT_DIR/module/Application/data"
sudo chown apache:apache "$PROJECT_DIR/module/Application/data"
sudo chmod 755 "$PROJECT_DIR/module/Application/data"

# 7️⃣ Habilitar mod_rewrite en Apache
echo "Habilitando mod_rewrite..."
sudo a2enmod rewrite 2>/dev/null || sudo sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf 2>/dev/null || true

# 7️⃣ Configurar VirtualHost para localhost con rewrite rules
VHOST_CONF="/etc/httpd/conf.d/tecno-exposicion-local.conf"
sudo bash -c "cat > $VHOST_CONF" <<EOF
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot \"$PROJECT_DIR/public\"

    <Directory \"$PROJECT_DIR/public\">
        Options FollowSymLinks
        AllowOverride All
        Require all granted
        
        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} -s [OR]
            RewriteCond %{REQUEST_FILENAME} -l [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^.*$ - [NC,L]
            RewriteRule ^.*$ /index.php [NC,L]
        </IfModule>
    </Directory>

    ErrorLog /var/log/httpd/tecno-exposicion-local-error.log
    CustomLog /var/log/httpd/tecno-exposicion-local-access.log combined
</VirtualHost>
EOF

# 8️⃣ No se modifica /etc/hosts

# 9️⃣ Reiniciar Apache
sudo systemctl restart httpd
sudo systemctl enable httpd

echo "✅ Proyecto Laminas listo en $PROJECT_DIR"
echo "Abre http://localhost/ en tu navegador para ver tu proyecto."
echo ""
echo "🗄️  Base de Datos SQLite:"
echo "   Ubicación: $PROJECT_DIR/module/Application/data/tecno-exposicion.db"
echo "   Se crea automáticamente en el primer acceso"
echo ""
echo "📝 Para reiniciar la BD con datos de demostración, ejecuta:"
echo "   ./reset_db.sh"
