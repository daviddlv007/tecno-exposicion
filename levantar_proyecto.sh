#!/bin/bash
# Script rápido para levantar el proyecto Tecno Exposición en VM con PHP 8.3 ya instalado
set -e

echo "🚀 Levantando proyecto Tecno Exposición..."

# Variables
PROJECT_DIR="/home/proyectos/tecno-exposicion"

# Verificar que el proyecto existe
if [ ! -d "$PROJECT_DIR/public" ]; then
    echo "❌ Error: No existe $PROJECT_DIR/public. Cancela."
    exit 1
fi

# 1️⃣ Instalar dependencias del proyecto
echo "📚 Instalando dependencias de Composer..."
cd "$PROJECT_DIR"
composer install --no-interaction

# 2️⃣ Ajustar permisos
echo "🔐 Configurando permisos..."
sudo chown -R apache:apache "$PROJECT_DIR"
sudo chmod -R 755 "$PROJECT_DIR"

# Crear directorio data para SQLite
mkdir -p "$PROJECT_DIR/module/Application/data"
sudo chown apache:apache "$PROJECT_DIR/module/Application/data"
sudo chmod 777 "$PROJECT_DIR/module/Application/data"

# 3️⃣ Configurar VirtualHost para localhost (sin conflictuar con laminas-demo)
echo "⚙️  Configurando VirtualHost..."
VHOST_CONF="/etc/httpd/conf.d/tecno-exposicion.conf"
sudo bash -c "cat > $VHOST_CONF" <<'EOF'
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /home/proyectos/tecno-exposicion/public

    <Directory /home/proyectos/tecno-exposicion/public>
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

    ErrorLog /var/log/httpd/tecno-exposicion-error.log
    CustomLog /var/log/httpd/tecno-exposicion-access.log combined
</VirtualHost>
EOF

# 4️⃣ No se modifica /etc/hosts

# 5️⃣ Verificar sintaxis de Apache
echo "✓ Verificando configuración de Apache..."
sudo apachectl configtest

# 6️⃣ Reiniciar Apache
echo "🔄 Reiniciando Apache..."
sudo systemctl restart httpd

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ ¡Proyecto levantado exitosamente!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "🌐 Acceso a los proyectos:"
echo "   Tecno Exposición: http://localhost/"
echo ""
echo "�️  Base de Datos SQLite:"
echo "   Ubicación: $PROJECT_DIR/module/Application/data/tecno-exposicion.db"
echo "   Se crea automáticamente en el primer acceso"
echo ""
echo "�📝 Logs:"
echo "   /var/log/httpd/tecno-exposicion-error.log"
echo "   /var/log/httpd/tecno-exposicion-access.log"
echo ""
