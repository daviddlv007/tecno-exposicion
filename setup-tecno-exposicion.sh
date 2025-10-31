#!/bin/bash
# Script "1-click" - Clona y levanta Tecno Exposición en Fedora 43 con PHP 8.3
# Uso: ./setup-tecno-exposicion.sh
# Requisito previo: Haber ejecutado el script de Laminas Demo original

set -e

echo "🚀 Clonando y levantando Tecno Exposición..."
echo ""

# ═══════════════════════════════════════════════════════════
# VARIABLES
# ═══════════════════════════════════════════════════════════
REPO_URL="https://github.com/daviddlv007/tecno-exposicion.git"
PROJECT_DIR="/home/proyectos/tecno-exposicion"
VHOST_CONF="/etc/httpd/conf.d/tecno-exposicion.conf"
DOMAIN="tecno-exposicion.local"

# ═══════════════════════════════════════════════════════════
# 0️⃣ VERIFICAR DEPENDENCIAS
# ═══════════════════════════════════════════════════════════
echo "0️⃣ Verificando dependencias..."

# Verificar PHP
if ! command -v php &> /dev/null; then
    echo "❌ Error: PHP no instalado"
    exit 1
fi
php_version=$(php -v | grep -oE '[0-9]+\.[0-9]+' | head -1)
echo "   ✅ PHP $php_version"

# Verificar Composer
if ! command -v composer &> /dev/null; then
    echo "❌ Error: Composer no instalado"
    exit 1
fi
echo "   ✅ Composer"

# Verificar Apache
if ! sudo systemctl is-active --quiet httpd; then
    echo "⚠️ Apache no está corriendo, iniciando..."
    sudo systemctl start httpd
fi
echo "   ✅ Apache"

# Verificar Git
if ! command -v git &> /dev/null; then
    echo "⚠️ Git no instalado, instalando..."
    sudo dnf install -y git
fi
echo "   ✅ Git"

# Verificar SQLite
if ! command -v sqlite3 &> /dev/null; then
    echo "⚠️ SQLite3 no instalado, instalando..."
    sudo dnf install -y sqlite
fi
echo "   ✅ SQLite"

echo ""

# ═══════════════════════════════════════════════════════════
# 1️⃣ CLONAR REPOSITORIO
# ═══════════════════════════════════════════════════════════
echo "1️⃣ Clonando repositorio..."

# Eliminar proyecto anterior si existe
if [ -d "$PROJECT_DIR" ]; then
    echo "   ⚠️ Directorio anterior encontrado, eliminando..."
    sudo rm -rf "$PROJECT_DIR"
fi

# Crear directorio padre si no existe
mkdir -p /home/proyectos

# Clonar repositorio
cd /home/proyectos
git clone "$REPO_URL" tecno-exposicion
echo "   ✅ Repositorio clonado"

cd "$PROJECT_DIR"
echo ""

# ═══════════════════════════════════════════════════════════
# 2️⃣ INSTALAR DEPENDENCIAS DE COMPOSER
# ═══════════════════════════════════════════════════════════
echo "2️⃣ Instalando dependencias de Composer..."
composer install --no-interaction
echo "   ✅ Dependencias instaladas"
echo ""

# ═══════════════════════════════════════════════════════════
# 3️⃣ CREAR DIRECTORIO DE DATOS
# ═══════════════════════════════════════════════════════════
echo "3️⃣ Creando directorio de datos para SQLite..."
mkdir -p "$PROJECT_DIR/module/Application/data"
echo "   ✅ Directorio creado"
echo ""

# ═══════════════════════════════════════════════════════════
# 4️⃣ AJUSTAR PERMISOS
# ═══════════════════════════════════════════════════════════
echo "4️⃣ Ajustando permisos..."
sudo chown -R apache:apache "$PROJECT_DIR"
sudo chmod -R 755 "$PROJECT_DIR"
sudo chmod 777 "$PROJECT_DIR/module/Application/data"

# SELinux si está disponible
if command -v restorecon &> /dev/null; then
    sudo restorecon -Rv "$PROJECT_DIR" 2>/dev/null || true
fi
echo "   ✅ Permisos ajustados"
echo ""

# ═══════════════════════════════════════════════════════════
# 5️⃣ CONFIGURAR VIRTUALHOST
# ═══════════════════════════════════════════════════════════
echo "5️⃣ Configurando VirtualHost..."

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

echo "   ✅ VirtualHost configurado"
echo ""

# ═══════════════════════════════════════════════════════════
# 6️⃣ HABILITAR MOD_REWRITE
# ═══════════════════════════════════════════════════════════
echo "6️⃣ Habilitando mod_rewrite..."
sudo sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf 2>/dev/null || true
echo "   ✅ mod_rewrite habilitado"
echo ""

# ═══════════════════════════════════════════════════════════
# 7️⃣ VERIFICAR CONFIGURACIÓN
# ═══════════════════════════════════════════════════════════
echo "7️⃣ Verificando configuración de Apache..."
if ! sudo apachectl configtest 2>&1 | grep -q "Syntax OK"; then
    echo "❌ Error en configuración de Apache"
    sudo apachectl configtest
    exit 1
fi
echo "   ✅ Configuración correcta"
echo ""

# ═══════════════════════════════════════════════════════════
# 8️⃣ REINICIAR APACHE
# ═══════════════════════════════════════════════════════════
echo "8️⃣ Reiniciando Apache..."
sudo systemctl restart httpd
sudo systemctl enable httpd
echo "   ✅ Apache reiniciado"
echo ""

# ═══════════════════════════════════════════════════════════
# 9️⃣ CREAR BASE DE DATOS CON DATOS DE DEMOSTRACIÓN
# ═══════════════════════════════════════════════════════════
echo "9️⃣ Creando base de datos SQLite con datos de demostración..."

DB_PATH="$PROJECT_DIR/module/Application/data/tecno-exposicion.db"

sqlite3 "$DB_PATH" <<SQL
CREATE TABLE IF NOT EXISTS categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categorias (nombre, descripcion) VALUES 
    ('Electrónica', 'Dispositivos y componentes electrónicos'),
    ('Informática', 'Computadoras, periféricos y software'),
    ('Telecomunicaciones', 'Equipos de comunicación y redes'),
    ('Energías Renovables', 'Tecnología solar, eólica e hidrógeno'),
    ('Inteligencia Artificial', 'Sistemas de IA y machine learning');
SQL

sudo chown apache:apache "$DB_PATH"
sudo chmod 644 "$DB_PATH"
echo "   ✅ Base de datos creada con 5 categorías"
echo ""

# ═══════════════════════════════════════════════════════════
# RESUMEN FINAL
# ═══════════════════════════════════════════════════════════
echo "════════════════════════════════════════════════════════════"
echo "✅ ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "🌐 ACCESO A LA APLICACIÓN:"
echo "   URL: http://localhost/"
echo ""
echo "📍 UBICACIÓN DEL PROYECTO:"
echo "   $PROJECT_DIR"
echo ""
echo "🗄️  BASE DE DATOS SQLITE:"
echo "   $DB_PATH"
echo "   Datos iniciales: 5 categorías"
echo ""
echo "📝 LOGS:"
echo "   Errores: /var/log/httpd/tecno-exposicion-error.log"
echo "   Accesos: /var/log/httpd/tecno-exposicion-access.log"
echo ""
echo "🎓 ARQUITECTURA IMPLEMENTADA:"
echo "   ✅ Laminas MVC Framework"
echo "   ✅ SQLite Database con PDO"
echo "   ✅ Repository Pattern"
echo "   ✅ Dependency Injection"
echo "   ✅ Service Manager (IoC)"
echo ""
echo "🔧 COMANDOS ÚTILES:"
echo "   Ver BD:          sqlite3 $DB_PATH"
echo "   Reiniciar BD:    $PROJECT_DIR/reset_db.sh"
echo "   Verificar:       $PROJECT_DIR/verificar_proyecto.sh"
echo "   Ver logs:        tail -f /var/log/httpd/tecno-exposicion-error.log"
echo ""
echo "📚 DOCUMENTACIÓN:"
echo "   Inicio rápido:   $PROJECT_DIR/GUIA_USO.md"
echo "   Arquitectura:    $PROJECT_DIR/MIGRACION_SQLITE.md"
echo "   Cambios:         $PROJECT_DIR/CAMBIOS_RESUMEN.md"
echo "   Completa:        $PROJECT_DIR/DOCUMENTACION_COMPLETA.md"
echo ""
echo "🚀 ¡Abre http://localhost/ para ver tu aplicación!"
echo ""
