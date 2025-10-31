#!/bin/bash
# Script de restauración: revierte cambios en Apache y archivos del sistema

set -e

echo "🔄 Restaurando configuración de Apache y archivos del sistema..."

# 1️⃣ Restaurar httpd.conf a su estado original (Fedora)
APACHE_CONF="/etc/httpd/conf/httpd.conf"

# Backup de seguridad
if [ -f "$APACHE_CONF" ]; then
    sudo cp "$APACHE_CONF" "$APACHE_CONF.backup.$(date +%s)"
fi

# Restaurar DocumentRoot por defecto
sudo sed -i 's|^DocumentRoot .*|DocumentRoot "/var/www/html"|' "$APACHE_CONF" 2>/dev/null || true

# Restaurar Directory por defecto
sudo bash -c 'cat > /tmp/restore_dir.txt' <<'EOF'
<Directory "/var/www">
    AllowOverride None
    Require all denied
</Directory>
<Directory "/var/www/html">
    AllowOverride None
    Require all granted
</Directory>
EOF

# 2️⃣ Limpiar VirtualHosts del proyecto si existen
sudo rm -f /etc/httpd/conf.d/tecno-exposicion*.conf

# 3️⃣ Reparar directorios de Apache si están rotos
if [ -L /etc/httpd/run ] && [ ! -e /etc/httpd/run ]; then
    sudo rm -f /etc/httpd/run
fi
sudo mkdir -p /etc/httpd/run
sudo chown apache:apache /etc/httpd/run
sudo chmod 755 /etc/httpd/run

# 4️⃣ Eliminar entrada en /etc/hosts si existe
if grep -q "tecno-exposicion.local" /etc/hosts; then
    sudo sed -i '/tecno-exposicion.local/d' /etc/hosts
fi

# 5️⃣ Reiniciar Apache
sudo systemctl restart httpd

echo "✅ Restauración completada."
echo "Apache vuelve a su configuración por defecto."
