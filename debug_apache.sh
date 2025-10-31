#!/bin/bash
echo "===== 1. Estado del servicio Apache ====="
sudo systemctl status httpd

echo -e "\n===== 2. Verificar sintaxis de configuración ====="
sudo httpd -t

echo -e "\n===== 3. Últimos errores del log de Apache ====="
sudo tail -n 30 /var/log/httpd/error_log

echo -e "\n===== 4. Permisos y propietario del DocumentRoot ====="
ls -ld /home/proyectos/tecno-exposicion/public
ls -l /home/proyectos/tecno-exposicion/public

echo -e "\n===== 5. Contexto SELinux del DocumentRoot ====="
if command -v ls &> /dev/null && command -v restorecon &> /dev/null; then
  ls -Zd /home/proyectos/tecno-exposicion/public
  ls -Z /home/proyectos/tecno-exposicion/public
fi

echo -e "\n===== 6. Archivos de configuración extra en /etc/httpd/conf.d/ ====="
ls -l /etc/httpd/conf.d/

echo -e "\n===== 7. Espacio en disco ====="
df -h | grep -E 'Filesystem|/home|/var'

echo -e "\n===== 8. Reinicio de Apache ====="
sudo systemctl restart httpd
sudo systemctl status httpd