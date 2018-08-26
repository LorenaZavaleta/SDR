#!/bin/bash
#del.sh
#Creador: Lorena Gpe. Zavaleta Rivera
#Fecha: 24/08/18
#Descripción: Script para hacer un borrado de archivo, y poder recuperarlo si se desea

while true; do

	echo "Ingrese la opcion que desea realizar"
	echo "	-Borrar (1)"
	echo "	-Recuperar (2)"
	echo "	-Salir (0)"
	read accion

	case $accion in
		1)
			ls
			echo "Ingrese el nombre del archivo o carpeta a borrar"
			read archivo
			mv -i $archivo /home/lorezr/.Papelera/$archivo
			;;
		2)
			cd /home/lorezr/.Papelera 
			ls
			cd /home/lorezr
			echo "Ingrese el nombre del archivo o carpeta a recuperar"
			read archivo
			existe=`ls /home/lorezr/.Papelera/$archivo | grep -c $archivo`
			if [[ $existe -eq 1 ]]; then
				mv -i /home/lorezr/.Papelera/$archivo $archivo
			fi
			;;
		0)
			echo "¡¡Hasta luego!!"
			exit 1
			;;
		*)
			echo "Ingresó una opción inválida"
			;;
	esac
done

