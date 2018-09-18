#!/bin/bash
#NUEVO SCRIPT
#Creador: Lorena Gpe. Zavaleta Rivera
#Fecha: 18/09/18
#Descripción: Se debe conectar tanto en red cableada como inalámbrica
#La conexión puede ser temporal o permanente
#Se puede manejar diferentes tipos de cifrado
#Se puede elegir que la configuración lógica sea dinámica o estática
while true; do
	echo "Elige una opcion a configurar"
	echo "0) Conexion Cableada Dinamica"	
	echo "1) Conexion Cableada Estatica"
	echo "2) Conexion Inalambrica Estatica"
	echo "3) Conexion Cableada Dinamica"
	echo "4) Salir "

	read opcion

	case $opcion in
		0)
			dhclient eth0
		;;
		1)
			#read -p "Inserte el nombre de su interfaz que desea asignar" interfaz
			read -p "Inserte la direccion IP que desea asignar" IP
			read -p "Inserta la mascara de subred" mask
			read -p "Inserta la direccion de la puerta de enlace (gateway)" gateway
			echo "Configurando red cableada estaticamente"
			sleep 3
			ifconfig eth0 $IP netmask $mask up
			route add default gw $gw
			echo "Se ha configurado la red adecuadamente, se mostrara la configuracion"
			sleep 3
			ifconfig eth0
			exit
		;;
		2)
			read -p "Inserte el nombre de su interfaz inalamrica" interfaz
			echo -e "Estas son las redes a las que se puede conectar:\n"
			iwlist $interfaz scan | grep ESSID
			read -p "Ingrese el ESSID de la red que desea conectarse" nombreRed
			read -p ""

		;;

		3)
			echo "Configurando red dinamicamente"
			ifconfig eth0 down
			sleep 3
			ifconfig eth0 up
			sleep 2
			dhclient eth0
		;;

		4)
			echo "Saliendo..."
			clear
			exit 1
		;;

		*)
			echo "Ingreso una opcion invalida"
		;;
	esac
done
