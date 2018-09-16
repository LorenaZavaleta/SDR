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

function contraseñaVer {
	#Verifica si la contraseña cuenta con todo lo pedido
	#Imprimo dos saltos de linea
	echo -e "\n"
	#Solo son las instrucciones
	echo "Ingresar una contraseña con las siguientes caracteristicas:"
	echo -e "\t-Minimo 6 caracteres"
	echo -e "\t-Maximo 10 caracteres"
	echo -e "\t-Que contenga lo siguente:"
	echo -e "\t\t>Mayúsculas"
	echo -e "\t\t>Minúsculas"
	echo -e "\t\t>Numeros"
	echo -e "\t\t>Caracteres especiales (+ @ # $ ¿ ? % & / ( ) _ -)(Extrictamente uno de estos)"
	while true; do
		#Se lee el password
		echo -n "Password:" 
		read -s password
		echo ""
		#numero de caracteres en el password
		numPass=`echo $password | wc -c`
		numPass=$[ $numPass - 1 ]
		
		#Validación de logitud de password
		if [ $numPass -ge 8 ] && [ $numPass -le 20 ];	then
			#Validación de mayúsculas
			passValido=`echo $password|grep '[A-Z]'`
			#Validación de minúsculas
			if [[ $passValido != "" ]];	then
				passValido=`echo $password|grep '[a-z]'`
				if [[ $passValido != "" ]];	then
				#Validación de numeros
					passValido=`echo $password|grep '[0-9]'`
					if [[ $passValido != "" ]];	then
					#Validación de caracteres especiales
						passValido=`echo $password|grep '[+ @ # $ ¿ ? % & / ( ) _ -]'`
						if [[ $passValido != "" ]];	then
							echo "La contraseña es valida"
							echo "Se asigno la contraseña correctamente"
							echo "$user:$password" | chpasswd
							break
							sleep 2
						else
							echo "Falta ingresar un caracter especial a la contraseña"
							sleep 2
						fi
					else
						echo "Falta ingresar un numero a la contraseña"
						sleep 2
					fi
				else
					echo "Falta ingresar una minuscula a la contraseña"
					sleep 2
				fi
			else
				echo "Falta ingresar una mayuscula a la contraseña"
				sleep 2
			fi
		else
			echo "Numero de caracteres invalidos, favor de ingresar un numero de caracteres validos"
			sleep 2
		fi
	done

}

function confSudo {
	
	while true; do
		read -p "¿Desea ingresar el usuario a los sudos?(Y/n):" resp
		if [ $resp == 'y' ] || [ $resp == 'Y' ]; then
			echo "$user	ALL=(ALL:ALL) ALL" >> /etc/sudoers
			break
		elif [ $resp == 'n' ] || [ $resp == 'N' ]; then
			break
		else
			echo "Opción inválida"
			sleep 1
		fi
	done

}



echo -e "SOLO SE EJECUTA CON ROOT\n "
sleep 1

while [ true ]; do
	echo "Ingresa la opción deseada"
	echo -e "\t-Crear Usuario (1)"
	echo -e "\t-Cambiar contraseña a un usuario(2)"
	echo -e "\t-Configurar sudo(3)"
	echo -e "\t-Salir(0)"
	read opcion

	case $opcion in
		1)
			makeUser
		;;
		2) 
			read -p "¿Qué usuario quieres editar su contraseña?: " user
			contraseñaVer
		;;
		3)
			read -p "¿Qué usuario deseas agregar a sudo?: " user
			confSudo
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
