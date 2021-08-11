#! /bin/bash
# 
#La array estará vacía si no encuentra coincidencias
shopt -s nullglob 
#shopt -s dotglob

#Crea una cadena con los subdirectorios del directorio en el que nos encontramos
Subdirectorios=(*/)

#Cadena con el nombre de los subs. Le hemos quitado "/" al final  
NomSubs=("${Subdirectorios[@]%/}")

#Bucle para crear una cadena llamada Pathfile con los archivos a comparar
#declaramos una cadena indexada vacía. Los índices comienzan en 0
declare -a PathFile			
for ((i=0; i<${#NomSubs[@]};i++))
do
  #Creamos una cadena auxiliar con los nombres de los archivos en el subdirectorio i
  AuxFilesSubdir=($(find ./${Subdirectorios[$i]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#  echo "${AuxFilesSubdir[@]}"
  for ((j=0; j<${#AuxFilesSubdir[@]};j++))  
  do 
#    echo "${NomSubs[$i]} ${AuxFilesSubdir[$j]}"
    #Comparamos para cada archivo j, si su nombre coincide con el del subdirectorio que lo contiene
    if [ ${NomSubs[$i]} = ${AuxFilesSubdir[$j]} ]
      #Si es así lo añadimos a la cadena PathFile
      then PathFile+=("./${Subdirectorios[$i]}${AuxFilesSubdir[$j]}") 
    fi
  done
done

#Imprime la cadena de Paths de archivos a comparar
echo "${PathFile[@]}"
#Imprime el número de elementos de la cadena de Paths de archivos a comparar
echo "${#PathFile[@]}"

#Bucle que compara los archivos uno a uno sin repetir comparaciones:
for ((i=0; i<${#PathFile[@]};i++))
do
  for ((j=($i+1); j<${#PathFile[@]};j++))  
  do 
    echo "Comparando ${PathFile[$i]} con ${PathFile[$j]}"
  done
done

#Imprimer el contenido del path guardado en PathFile[1]
#cat "${PathFile[1]}"

#OTRAS COSAS APRENDIDAS:
#
#Guarda en una variable el directorio padre:
#DirPadre=$(pwd)
#
#Lista el número de subdirectorios usando tuberías:
#NumSubd=$(ls -l | grep ^d | wc -l)
#
#Imprime el directorio en el que está el subdirectorio 1:
#echo $PWD/${Subdirectorios[1]}
#Lista lo que contiene el subdirectorio 1:
#ls "$PWD/${Subdirectorios[1]}"
#
#Crea cuatro cadenas con los path de los archivos en los subdirectorios
#Path_Files_Sub1=($(find ./${Subdirectorios[1]} -maxdepth 1 -mindepth 1 -type f))
#Path_Files_Sub2=($(find ./${Subdirectorios[2]} -maxdepth 1 -mindepth 1 -type f))
#Path_Files_Sub3=($(find ./${Subdirectorios[3]} -maxdepth 1 -mindepth 1 -type f))
#Path_Files_Sub4=($(find ./${Subdirectorios[4]} -maxdepth 1 -mindepth 1 -type f))
#
#Crea cadenas con los nombres de los ficheros en cada subdirectorio
#Las cadenas empiezan a contar en 0
#Files_Sub1=($(find ./${Subdirectorios[0]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#Files_Sub2=($(find ./${Subdirectorios[1]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#Files_Sub3=($(find ./${Subdirectorios[2]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#Files_Sub4=($(find ./${Subdirectorios[3]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#
#MANERAS DE IMPRIMIR INFORMACIÓN DE CADENAS:
#
#Imprime el número de elementos de la cadena NomSubs
#echo ${#NomSubs[@]}
#Imprime los elementos de la cadena NomSubs uno al lado del otro
#echo "${NomSubs[@]}"
#
#Imprime una lista con los elementos de la cadena
#printf '%s\n' "${NomSubs[@]}"
#
#Bucle para imprimir una lista con los elementos de una array. La variable dir es local y se refiere a los elementos de la cadena:
#for dir in "${NomSubs[@]}" 
#do 
#  echo "$dir"
#done
#
#Bucle para crear una matriz con todos los nombres de los archivos en cada directorio
#La matriz se forma definiendo una array asociativa que hay que declarar:
#declare -A FilesSubdir
#for ((i=0; i<${#NomSubs[@]};i++))
#do
#  AuxFilesSubdir=($(find ./${Subdirectorios[$i]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#  echo "${AuxFilesSubdir[@]}"
#  for ((j=0; j<${#AuxFilesSubdir[@]};j++))  
#  do
#    echo "$i $j"
#    FilesSubdir[$i,$j]=${AuxFilesSubdir[$j]}
#    echo "${FilesSubdir[$i,$j]}" 
#  done
#done
#
#echo "${FilesSubdir[1,0]} ${FilesSubdir[1,1]} ${FilesSubdir[1,2]}"