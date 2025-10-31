# 🚀 SCRIPT DE SETUP FINAL - `setup-tecno-exposicion.sh`

## 📋 ¿Qué hace este script?

Este es el script **"todo en uno"** que:
1. ✅ Clona el repositorio desde GitHub
2. ✅ Instala dependencias de Composer (PHP)
3. ✅ Configura Apache con VirtualHost
4. ✅ Crea base de datos SQLite con datos de demostración
5. ✅ Habilita mod_rewrite
6. ✅ Reinicia todos los servicios

## 🎯 Requisito Previo

Debes haber ejecutado previamente el script de Laminas Demo:

```bash
#!/bin/bash
# Script original (ya ejecutado en tu VM)
# ...instala PHP 8.3, Apache, Composer, etc...
```

**Esto significa que tu VM ya tiene:**
- ✅ PHP 8.3
- ✅ Apache instalado y corriendo
- ✅ Composer instalado
- ✅ Git instalado

## 📥 Cómo Usar

### Opción 1: Copiar y ejecutar directamente en la VM

```bash
# En tu VM Fedora 43:

# 1. Copia el contenido del script
cat > /tmp/setup-tecno-exposicion.sh << 'SCRIPT_EOF'
#!/bin/bash
# [AQUÍ VA EL CONTENIDO COMPLETO DEL SCRIPT]
# ... (copiar todo el contenido de setup-tecno-exposicion.sh)
SCRIPT_EOF

# 2. Hazlo ejecutable
chmod +x /tmp/setup-tecno-exposicion.sh

# 3. Ejecuta
/tmp/setup-tecno-exposicion.sh
```

### Opción 2: Desde el repositorio clonado (más simple)

```bash
# Si ya tienes el repositorio clonado:
cd /home/proyectos/tecno-exposicion
./setup-tecno-exposicion.sh
```

## 📊 Salida Esperada

```
🚀 Clonando y levantando Tecno Exposición...

0️⃣ Verificando dependencias...
   ✅ PHP 8.3
   ✅ Composer
   ✅ Apache
   ✅ Git
   ✅ SQLite

1️⃣ Clonando repositorio...
   ✅ Repositorio clonado

2️⃣ Instalando dependencias de Composer...
   ✅ Dependencias instaladas

3️⃣ Creando directorio de datos para SQLite...
   ✅ Directorio creado

4️⃣ Ajustando permisos...
   ✅ Permisos ajustados

5️⃣ Configurando VirtualHost...
   ✅ VirtualHost configurado

6️⃣ Habilitando mod_rewrite...
   ✅ mod_rewrite habilitado

7️⃣ Verificando configuración de Apache...
   ✅ Configuración correcta

8️⃣ Reiniciando Apache...
   ✅ Apache reiniciado

9️⃣ Creando base de datos SQLite con datos de demostración...
   ✅ Base de datos creada con 5 categorías

════════════════════════════════════════════════════════════
✅ ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!
════════════════════════════════════════════════════════════

🌐 ACCESO A LA APLICACIÓN:
   URL: http://localhost/

📍 UBICACIÓN DEL PROYECTO:
   /home/proyectos/tecno-exposicion

🗄️  BASE DE DATOS SQLITE:
   /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db
   Datos iniciales: 5 categorías
```

## 🎓 Qué Se Instala

### Dependencias de Sistema (instaladas automáticamente si faltan)
- `git` - Para clonar repositorio
- `sqlite` - Para cliente SQLite (administración)

### Base de Datos
- Tabla: `categorias`
- Campos: `id`, `nombre`, `descripcion`, `created_at`, `updated_at`
- Registros iniciales: 5 categorías de demostración

### Configuración Apache
- **VirtualHost**: `localhost:80`
- **DocumentRoot**: `/home/proyectos/tecno-exposicion/public`
- **Módulo**: `mod_rewrite` habilitado
- **Logs**: `/var/log/httpd/tecno-exposicion-*.log`

## 🌐 Acceso a la Aplicación

```
http://localhost/
```

**Verás:**
- Listado de 5 categorías
- Opción para añadir nuevas categorías
- Opciones de editar y eliminar

## 🔧 Comandos Útiles Post-Instalación

### Ver base de datos
```bash
sqlite3 /home/proyectos/tecno-exposicion/module/Application/data/tecno-exposicion.db
sqlite> SELECT * FROM categorias;
```

### Ver logs de errores
```bash
tail -f /var/log/httpd/tecno-exposicion-error.log
```

### Reiniciar base de datos con datos de demo
```bash
cd /home/proyectos/tecno-exposicion
./reset_db.sh
```

### Verificar estado del proyecto
```bash
cd /home/proyectos/tecno-exposicion
./verificar_proyecto.sh
```

## 📚 Documentación del Proyecto

Después de instalar, revisa:

- **`GUIA_USO.md`** - Cómo usar la aplicación
- **`MIGRACION_SQLITE.md`** - Cambios técnicos
- **`CAMBIOS_RESUMEN.md`** - Resumen de archivos
- **`DOCUMENTACION_COMPLETA.md`** - Documentación completa

## ⚠️ Troubleshooting

### ❌ Error: "PHP not found"
```bash
# Solución: Instala PHP 8.3 primero
sudo dnf module enable php:remi-8.3 -y
sudo dnf install -y php php-cli php-mbstring php-json php-session
```

### ❌ Error: "Composer not found"
```bash
# Solución: Instala Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

### ❌ Error: "Apache not responding"
```bash
# Solución: Reinicia Apache
sudo systemctl restart httpd
```

### ❌ Página en blanco
```bash
# Solución: Revisa logs
tail -f /var/log/httpd/tecno-exposicion-error.log
```

## 🔄 Flujo Completo

```
┌─────────────────────────────────────────┐
│ Ejecuta setup-tecno-exposicion.sh       │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ Clona repo desde GitHub                 │
│ https://github.com/daviddlv007/         │
│ tecno-exposicion.git                    │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ Instala dependencias Composer           │
│ (sin reinstalar PHP, Apache, etc.)      │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ Configura VirtualHost localhost:80      │
│ (rewrite rules para Laminas)            │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ Crea BD SQLite con 5 categorías         │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ Reinicia Apache                         │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│ ✅ Accede a http://localhost/           │
└─────────────────────────────────────────┘
```

## 🎉 Resultado Final

**Tu aplicación estará lista para:**
- ✅ Ver listado de categorías
- ✅ Crear nuevas categorías
- ✅ Editar categorías
- ✅ Eliminar categorías
- ✅ Todos los datos persisten en SQLite

**Arquitectura demostrada:**
- ✅ Laminas MVC Framework
- ✅ Routing profesional
- ✅ Controllers y Actions
- ✅ Service Manager (IoC)
- ✅ Repository Pattern
- ✅ Dependency Injection
- ✅ SQLite + PDO

---

**¿Listo? Ejecuta el script y abre http://localhost/ en tu navegador! 🚀**
