#!/bin/bash
# Script completo para instalar dependencias y configurar Apache automáticamente en Fedora

sudo dnf install -y php php-cli php-json php-mbstring php-session httpd curl unzip

# Instalar Composer si no está presente
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# Instalar dependencias del proyecto
composer install

# Configurar Apache DocumentRoot automáticamente
APACHE_CONF="/etc/httpd/conf/httpd.conf"
PROJECT_PUBLIC="/home/proyectos/tecno-exposicion/public"

if grep -q "DocumentRoot" "$APACHE_CONF"; then
    sudo sed -i "s|^DocumentRoot .*|DocumentRoot \"$PROJECT_PUBLIC\"|" "$APACHE_CONF"
    sudo sed -i "/<Directory \/>/,/<\/Directory>/c\<Directory \"$PROJECT_PUBLIC\">\n    AllowOverride All\n    Require all granted\n<\/Directory>" "$APACHE_CONF"
    echo "Configuración de Apache actualizada."
else
    echo "No se encontró DocumentRoot en $APACHE_CONF. Por favor, configura manualmente."
fi

# Reiniciar Apache
sudo systemctl restart httpd
sudo systemctl enable httpd

echo "Dependencias instaladas y Apache configurado. Accede a http://localhost/ para ver tu proyecto."
