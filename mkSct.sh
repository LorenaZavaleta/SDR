#!/bin/bash
#Creación de un script
#Creador: Lorena Gpe. Zavaleta Rivera
#Fecha: 24/08/18
#Descripción: Script que ayude a crear la documentación de un Script

echo "nombre del nuevo script"
read name

touch $name.sh 

cat  ./.estructura.txt >> $name.sh

chmod 755 $name.sh

nano $name.sh

exit
