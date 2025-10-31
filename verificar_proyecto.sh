#!/bin/bash
# Script de verificación rápida del proyecto

PROJECT_DIR="/home/proyectos/tecno-exposicion"

echo "🔍 Verificando integridad del proyecto Tecno Exposición..."
echo ""

# Verificar estructura de carpetas
echo "📁 Estructura de carpetas:"
[ -d "$PROJECT_DIR/module/Application/src/Controller" ] && echo "  ✅ Controllers" || echo "  ❌ Controllers"
[ -d "$PROJECT_DIR/module/Application/src/Model" ] && echo "  ✅ Models" || echo "  ❌ Models"
[ -d "$PROJECT_DIR/module/Application/view" ] && echo "  ✅ Views" || echo "  ❌ Views"
[ -d "$PROJECT_DIR/module/Application/config" ] && echo "  ✅ Config" || echo "  ❌ Config"
[ -d "$PROJECT_DIR/public" ] && echo "  ✅ Public" || echo "  ❌ Public"
echo ""

# Verificar archivos esenciales
echo "📄 Archivos esenciales:"
[ -f "$PROJECT_DIR/module/Application/src/Controller/CategoriaController.php" ] && echo "  ✅ CategoriaController.php" || echo "  ❌ CategoriaController.php"
[ -f "$PROJECT_DIR/module/Application/src/Model/Categoria.php" ] && echo "  ✅ Categoria.php" || echo "  ❌ Categoria.php"
[ -f "$PROJECT_DIR/module/Application/src/Model/CategoriaRepository.php" ] && echo "  ✅ CategoriaRepository.php" || echo "  ❌ CategoriaRepository.php"
[ -f "$PROJECT_DIR/module/Application/config/module.config.php" ] && echo "  ✅ module.config.php" || echo "  ❌ module.config.php"
[ -f "$PROJECT_DIR/composer.json" ] && echo "  ✅ composer.json" || echo "  ❌ composer.json"
echo ""

# Verificar scripts
echo "🔨 Scripts disponibles:"
[ -x "$PROJECT_DIR/levantar_proyecto.sh" ] && echo "  ✅ levantar_proyecto.sh" || echo "  ❌ levantar_proyecto.sh"
[ -x "$PROJECT_DIR/crear_laminas_local.sh" ] && echo "  ✅ crear_laminas_local.sh" || echo "  ❌ crear_laminas_local.sh"
[ -x "$PROJECT_DIR/reset_db.sh" ] && echo "  ✅ reset_db.sh" || echo "  ❌ reset_db.sh"
echo ""

# Verificar documentación
echo "📖 Documentación:"
[ -f "$PROJECT_DIR/DOCUMENTACION_COMPLETA.md" ] && echo "  ✅ DOCUMENTACION_COMPLETA.md" || echo "  ❌ DOCUMENTACION_COMPLETA.md"
[ -f "$PROJECT_DIR/GUIA_USO.md" ] && echo "  ✅ GUIA_USO.md" || echo "  ❌ GUIA_USO.md"
[ -f "$PROJECT_DIR/MIGRACION_SQLITE.md" ] && echo "  ✅ MIGRACION_SQLITE.md" || echo "  ❌ MIGRACION_SQLITE.md"
[ -f "$PROJECT_DIR/CAMBIOS_RESUMEN.md" ] && echo "  ✅ CAMBIOS_RESUMEN.md" || echo "  ❌ CAMBIOS_RESUMEN.md"
echo ""

# Verificar PHP
echo "🐘 Entorno PHP:"
php_version=$(php -v | grep -oE 'PHP [0-9]+\.[0-9]+' | head -1)
echo "  PHP Version: $php_version"
command -v composer &> /dev/null && echo "  ✅ Composer instalado" || echo "  ❌ Composer no instalado"
echo ""

# Verificar Apache
echo "🌐 Apache:"
sudo systemctl is-active --quiet httpd && echo "  ✅ Apache corriendo" || echo "  ❌ Apache no corriendo"
[ -f "/etc/httpd/conf.d/tecno-exposicion.conf" ] && echo "  ✅ VirtualHost configurado" || echo "  ⚠️  VirtualHost no configurado"
echo ""

# Verificar Base de Datos
echo "🗄️  Base de Datos SQLite:"
db_path="$PROJECT_DIR/module/Application/data/tecno-exposicion.db"
if [ -f "$db_path" ]; then
    echo "  ✅ Base de datos existe"
    tables=$(sqlite3 "$db_path" ".tables" 2>/dev/null)
    [ -n "$tables" ] && echo "  ✅ Tablas: $tables" || echo "  ⚠️  Sin tablas"
    count=$(sqlite3 "$db_path" "SELECT COUNT(*) FROM categorias;" 2>/dev/null || echo "0")
    echo "  📊 Categorías: $count"
else
    echo "  ⚠️  Base de datos no existe (se crea en primer acceso)"
fi
echo ""

# Verificar dependencias de Composer
echo "📦 Dependencias de Composer:"
if [ -d "$PROJECT_DIR/vendor" ]; then
    echo "  ✅ vendor/ existe"
    [ -f "$PROJECT_DIR/vendor/autoload.php" ] && echo "  ✅ Autoloader disponible" || echo "  ❌ Autoloader no encontrado"
else
    echo "  ⚠️  vendor/ no existe (ejecuta composer install)"
fi
echo ""

echo "════════════════════════════════════════════════════════════"
echo "✅ Verificación completada"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📝 Próximos pasos:"
echo "   1. Ejecuta: cd $PROJECT_DIR"
echo "   2. Ejecuta: ./levantar_proyecto.sh"
echo "   3. Accede a: http://localhost/"
echo ""
