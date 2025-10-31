#!/bin/bash
# Script para clonar y levantar el proyecto automáticamente en Fedora

# Instalar git si no está presente
if ! command -v git &> /dev/null; then
    echo "Instalando git..."
    sudo dnf install -y git
fi

# Clonar el repositorio si no existe la carpeta
REPO_URL="https://github.com/daviddlv007/tecno-exposicion.git"
REPO_DIR="tecno-exposicion"
if [ ! -d "$REPO_DIR" ]; then
    echo "Clonando el repositorio..."
    git clone "$REPO_URL"
fi

# Entrar al directorio del proyecto
cd "$REPO_DIR"

# Instalar dependencias y configurar Apache (igual que tu script actual)
sudo dnf install -y php php-cli php-json php-mbstring php-session httpd curl unzip

if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

composer install

APACHE_CONF="/etc/httpd/conf/httpd.conf"
PROJECT_PUBLIC="$(pwd)/public"

if grep -q "DocumentRoot" "$APACHE_CONF"; then
    sudo sed -i "s|^DocumentRoot .*|DocumentRoot \"$PROJECT_PUBLIC\"|" "$APACHE_CONF"
    sudo sed -i "/<Directory \/>/,/<\/Directory>/c\\<Directory \"$PROJECT_PUBLIC\">\n    AllowOverride All\n    Require all granted\n<\/Directory>" "$APACHE_CONF"
    echo "Configuración de Apache actualizada."
else
    echo "No se encontró DocumentRoot en $APACHE_CONF. Por favor, configura manualmente."
fi

# Reparar /etc/httpd/run si es un symlink roto
if [ -L /etc/httpd/run ] && [ ! -e /etc/httpd/run ]; then
    sudo rm -f /etc/httpd/run
fi
sudo mkdir -p /etc/httpd/run
sudo chown apache:apache /etc/httpd/run
sudo chmod 755 /etc/httpd/run
sudo systemctl restart httpd
sudo systemctl enable httpd

echo "Dependencias instaladas y Apache configurado. Accede a http://localhost/ para ver tu proyecto."

# Levantar siempre el servidor PHP integrado en el puerto 8080
cd "$PROJECT_PUBLIC"
echo "Levantando servidor PHP en http://localhost:8080 ..."
php -S localhost:8080
