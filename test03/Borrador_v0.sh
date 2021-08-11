#! /bin/bash
#
# 

DirPadre=$(pwd)

NumSubd=$(ls -l | grep ^d | wc -l)

#La array estará vacía si no encuentra coincidencias
shopt -s nullglob 
#shopt -s dotglob

#Crea una cadena con los subdirectorios del directorio en el que nos encontramos
Subdirectorios=(*/)

#Cadena con el nombre de los subs. Le hemos quitado "/" al final  
NomSubs=("${Subdirectorios[@]%/}")

#cd "./${Subdirectorios[4]}"
#Path_Files_Sub1=($(find ./${Subdirectorios[1]} -maxdepth 1 -mindepth 1 -type f))
#Path_Files_Sub2=($(find ./${Subdirectorios[2]} -maxdepth 1 -mindepth 1 -type f))
#Path_Files_Sub3=($(find ./${Subdirectorios[3]} -maxdepth 1 -mindepth 1 -type f))
#Path_Files_Sub4=($(find ./${Subdirectorios[4]} -maxdepth 1 -mindepth 1 -type f))

#Cadenas con los nombres de los ficheros en cada subdirectorio
#Las cadenas empiezan a contar en 0
#Files_Sub1=($(find ./${Subdirectorios[0]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#Files_Sub2=($(find ./${Subdirectorios[1]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#Files_Sub3=($(find ./${Subdirectorios[2]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
#Files_Sub4=($(find ./${Subdirectorios[3]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))

#echo $PWD/${Subdirectorios[1]}
#ls "$PWD/${Subdirectorios[1]}"

#Imprime el número de elementos de una cadena
#echo ${#NomSubs[@]}
#Imprime los elementos de la cadena uno al lado del otro
#echo "${NomSubs[@]}"
#echo "${Files_Sub1[@]}"
#echo "${Test[@]}"

#Imprime una lista con los elementos de una array
#printf '%s\n' "${NomSubs[@]}"

#Bucle para imprimir una lista con los elementos de una array 
#dir es una variable local:
#for dir in "${NomSubs[@]}" 
#do 
#  echo "$dir"
#done

#Bucle para listar todos los nombres de los archivos en cada directorio
declare -A FilesSubdir
declare -a PathFile
for ((i=0; i<${#NomSubs[@]};i++))
do
  AuxFilesSubdir=($(find ./${Subdirectorios[$i]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
  echo "${AuxFilesSubdir[@]}"
#  j=0
#  while [$j!=1000]
#  do
#    if ["${NomSubs[$i]}" ="${AuxFilesSubdir[$j]}"]
#    then PathFile+=($(find ./${Subdirectorios[$i]} -maxdepth 1 -mindepth 1 -type f))
#         j=1000
#    else j+=1 
#    fi
  for ((j=0; j<${#AuxFilesSubdir[@]};j++))  
  do 
    echo "${NomSubs[$i]} ${AuxFilesSubdir[$j]}"
    if [ ${NomSubs[$i]} = ${AuxFilesSubdir[$j]} ]
      then PathFile+=("./${Subdirectorios[$i]}${AuxFilesSubdir[$j]}") 
    fi
#  for ((j=0; j<${#AuxFilesSubdir[@]};j++))  
#  do
#    echo "$i $j"
#    FilesSubdir[$i,$j]=${AuxFilesSubdir[$j]}
#    echo "${FilesSubdir[$i,$j]}" 
  done
done

#echo "${FilesSubdir[1,0]} ${FilesSubdir[1,1]} ${FilesSubdir[1,2]}"
echo "${PathFile[@]}"
echo "${#PathFile[@]}"
#echo "${Files_Sub3[@]}"
#echo "${Files_Sub4[@]}"

for ((i=0; i<${#PathFile[@]};i++))
do
  for ((j=($i+1); j<${#PathFile[@]};j++))  
  do 
    echo "Comparando ${PathFile[$i]} con ${PathFile[$j]}"
  done
done
#cat "${PathFile[1]}"
