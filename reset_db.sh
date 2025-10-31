#!/bin/bash
# Script para reiniciar la base de datos SQLite con datos de demostración

PROJECT_DIR="/home/proyectos/tecno-exposicion"
DB_PATH="$PROJECT_DIR/module/Application/data/tecno-exposicion.db"

echo "🗄️  Reiniciando base de datos SQLite..."

# Eliminar BD anterior si existe
if [ -f "$DB_PATH" ]; then
    rm "$DB_PATH"
    echo "❌ Base de datos anterior eliminada"
fi

# Crear directorio data si no existe
mkdir -p "$(dirname "$DB_PATH")"

# Crear nueva BD con datos de demostración
sqlite3 "$DB_PATH" <<EOF
-- Crear tabla categorias
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de demostración
INSERT INTO categorias (nombre, descripcion) VALUES 
    ('Electrónica', 'Dispositivos y componentes electrónicos'),
    ('Informática', 'Computadoras, periféricos y software'),
    ('Telecomunicaciones', 'Equipos de comunicación y redes'),
    ('Energías Renovables', 'Tecnología solar, eólica e hidrógeno'),
    ('Inteligencia Artificial', 'Sistemas de IA y machine learning');

-- Mostrar datos creados
.mode column
.headers on
SELECT id, nombre, descripcion, created_at FROM categorias;
EOF

# Ajustar permisos
chmod 644 "$DB_PATH"
sudo chown apache:apache "$DB_PATH" 2>/dev/null || true

echo "✅ Base de datos reiniciada con datos de demostración"
echo "📍 Ubicación: $DB_PATH"
echo ""
echo "📊 Categorías creadas:"
sqlite3 "$DB_PATH" "SELECT id, nombre FROM categorias;"
