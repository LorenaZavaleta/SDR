#!/bin/bash
#Crear usuarios versión 1
#Creador: Lorena Gpe. Zavaleta Rivera
#Fecha: 09/09/18
#Descripción: Script que permite crear nuevos usuarios

user=""
dir=""
estruc=""
inter=""
nombre=""
grupo=""

function makeUser {
		read -p "Ingresa el nombre del usuario " user

		while true; do
			read -p "Deseas usar el directorio definido por defecto?(Y/N): " resp
				if [ $resp == 'y' ] || [ $resp == 'Y' ]; then
					dir="/home/"$user
					break
				elif [ $resp == 'n' ] || [ $resp == 'N' ]; then
					echo -n "Ingresa el directorio: "
					read dir 
					break
				else
					echo "Opción inválida"
					sleep 1
				fi
		done

		while true; do
			read -p "¿Usarás la estructura por defecto (/etc/skel)? (Y/n): " resp
			if [ $resp == 'y' ] || [ $resp == 'Y' ]; then
				estruc="/etc/skel"
				break
			elif [ $resp == 'n' ] || [ $resp == 'N' ]; then
				read -p "Ingresa la estructura que usaras: " estruc
				break
			else
				echo "Opción inválida"
				sleep 1
			fi
		done

		while true; do
			read -p "¿Usarás el interprete por defecto (/bin/bash)(Y/n): " resp
				if [ $resp == 'y' ] || [ $resp == 'Y' ]; then
					inter="/bin/bash"
					break
				elif [ $resp == 'n' ] || [ $resp == 'N' ]; then
					read -p "Ingresa el interprete que usarás :" inter
					break
				else
					echo "Opción inválida"
					sleep 1
				fi
		done

		
	        while true; do
        	        read -p "¿Desea ingresar el nombre de usuario completo?(Y/n):" resp
                	if [[ $resp == 'y' ]] || [[ $resp == 'Y' ]]; then
                        	read -p "Ingrese el nombre completo del usuario: " nombre
                        	break
                	elif [ $resp == 'n' ] || [ $resp == 'N' ];    then
                        	nombre=""
                        	break
                	else
                        	echo "Opción inválida"
                        	sleep 1
                	fi
        	done


		while true; do
                	read -p "¿Desea ingresar un grupo en especifico?(Y/n):" resp
                	if [ $resp == 'y' ] || [ $resp == 'Y' ]; then
                        	while true; do
                                	read -p "Ingrese el nombre del grupo completo del usuario: " grupo
                                	verGrupos=`more /etc/group | grep -c $grupo`
                                	if [ $grupo == "" ];then
                                        	grupo=""
                                        	break
                                	elif [ $verGrupos -ne 0 ];then
                                        	break
                                	else    
                                        	grupo=""
                                	fi
                        	done
                        	break
                	else
                        	if [ $resp == 'n' ] || [ $resp == 'N' ]; then
                                	grupo=""
                                	break
                        	else
                                	echo "Opción inválida"
                                	sleep 1
                        	fi
                	fi
        	done

		if [[ $grupo == "" ]];then
                	if [[ $nombre == "" ]]; then
                        	useradd -d $dir -m -k $estruc -s $inter $user
                	else
                        	useradd -c $nombre -d $dir -m -k $com -s $inter $user
               		fi
        	else
                	useradd -c "$nombre" -d $dir -m -k $estruc -g $grupo -s $inter $user
        	fi
		
		passwd $user
}


echo -e "SOLO SE EJECUTA CON ROOT\n "
sleep 1

while [ true ]; do
	echo "Ingresa la opción deseada"
	echo -e "\t-Crear Usuario (1)"
	echo -e "\t-Salir(0)"
	read opcion

	case $opcion in
		1)
			makeUser
		;;
		0)
			echo "Saliendo..."
			clear
			exit 1
		;;
		*)
			echo "Ingresa una opción válida"
		;;
	esac
done
