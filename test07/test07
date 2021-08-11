#! /bin/bash
# 
#La array estará vacía si no encuentra coincidencias
shopt -s nullglob #Aquí también hay un comentario y tiene if, do, for, while 
#shopt -s dotglob

#Inicializamos el archivo de resultados
#touch ResultadosComparacion.data
echo "	 _______________________________________________________________">ResultadosComparacion.data
echo "	|								|">>ResultadosComparacion.data
echo "	|			INFORME RESULTADOS 			|">>ResultadosComparacion.data
echo "	|		    SCRIPT COMPARACIÓN ARCHIVOS 		|">>ResultadosComparacion.data
echo "	|_______________________________________________________________|">>ResultadosComparacion.data
echo "	|								|">>ResultadosComparacion.data
echo "	|	NOMBRE:	CompareFiles.sh					|">>ResultadosComparacion.data
echo "	|	AUTOR:	Carlos Martínez Hernández			|">>ResultadosComparacion.data
echo "	|	FECHA:	09/04/2020					|">>ResultadosComparacion.data 
echo "	|	DESCRIPCIÓN: Este Script compara el porcentaje de	|">>ResultadosComparacion.data
echo "	|		     coincidencias que existe entre una serie 	|">>ResultadosComparacion.data
echo "	|		     de bash scripts cuyo nombre coincide con 	|">>ResultadosComparacion.data
echo "	|		     el del subdirectorio que los contiene	|">>ResultadosComparacion.data
echo "	|_______________________________________________________________|">>ResultadosComparacion.data
#Nueva línea
echo>>ResultadosComparacion.data
echo>>ResultadosComparacion.data


#Crea una cadena con los subdirectorios del directorio en el que nos encontramos
Subdirectorios=(*/)

#Aviso de que no se ha encontrado ningún subdirectorio para comparar
if [ ${#Subdirectorios[@]} = 0 ]
  then 
  #Salida en negrita:
  #echo -e '\033[1mError: No hay subdirectorios en esta carpeta para comparar\033[0m'>>ResultadosComparacion.data 
  echo "Error: No hay subdirectorios en esta carpeta para comparar">>ResultadosComparacion.data 
  cat ResultadosComparacion.data
  exit 0
fi


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
#echo "${PathFile[@]}"
#Imprime el número de elementos de la cadena de Paths de archivos a comparar
#echo "${#PathFile[@]}"

#Aviso de que no se ha encontrado ningún archivo para comparar
if [ ${#PathFile[@]} = 0 ] || [ ${#PathFile[@]} = 1 ]
  then 
  echo "Error: No hay suficienes archivos para comparar">>ResultadosComparacion.data 
  cat Resultados_Comparacion.data
  exit 0
else
  echo "El Script a encontrado ${#PathFile[@]} ficheros y los comparará entre sí.">>ResultadosComparacion.data
  echo>>ResultadosComparacion.data
  echo>>ResultadosComparacion.data
fi

#Bucle que compara los archivos uno a uno sin repetir comparaciones:
for ((i=0; i<${#PathFile[@]};i++))
do
  for ((j=($i+1); j<${#PathFile[@]};j++))  
  do 
    Nlineas_i=`wc -l < ${PathFile[$i]}`
    Nlineas_j=`wc -l < ${PathFile[$j]}` # Si escribimos $(wc -l ${PathFile[$j]}) obtenemos lo mismo
    NlineasVacias_i=`grep -c "^\s*$" ${PathFile[$i]}`
    NlineasVacias_j=`grep -c "^\s*$" ${PathFile[$j]}`
    NlineasComent_i=`grep -c "^\#" ${PathFile[$i]}`
    NlineasComent_j=`grep -c "^\#" ${PathFile[$j]}`
    NlineasCodigo_i=$[$Nlineas_i-$NlineasVacias_i-$NlineasComent_i]
    NlineasCodigo_j=$[$Nlineas_j-$NlineasVacias_j-$NlineasComent_j]
    
    NSentenciasIF_i=`grep -c "^\s*if" ${PathFile[$i]}`
    NSentenciasIF_j=`grep -c "^\s*if" ${PathFile[$j]}`
    NSentenciasFOR_i=`grep -c "^\s*for" ${PathFile[$i]}`
    NSentenciasFOR_j=`grep -c "^\s*for" ${PathFile[$j]}`
    NSentenciasWHILE_i=`grep -c "^\s*while" ${PathFile[$i]}`
    NSentenciasWHILE_j=`grep -c "^\s*while" ${PathFile[$j]}`
    NSentenciasECHO_j=`grep -c "^\s*echo" ${PathFile[$j]}`
    NSentenciasECHO_i=`grep -c "^\s*echo" ${PathFile[$i]}`

    NVariables_i=`grep -v "^\s*#" ${PathFile[$i]} | grep = | grep -cv "\s="`
    NVariables_j=`grep -v "^\s*#" ${PathFile[$j]} | grep = | grep -cv "\s="`
    
    #Sólo cuenta las líneas comunes de código neto. No cuenta líneas en blanco ni comentarios
    NlineasComunes=`comm -12 <(sort ${PathFile[$i]}) <(sort ${PathFile[$i]}) | grep -v "^\s*$" | grep -v "^\s*#" | wc -l`


####A completar!!!###PONER NÚMERO DE LINEAS COMUNES
    PorcentajeCoincidencia=100
    
    #diff ${PathFile[$i]} ${PathFile[$j]}  

    #Impresión de resultados
    echo "Comparando Fichero $[$i+1]:\"${PathFile[$i]}\" con Fichero $[$j+1]: \"${PathFile[$j]}\":">>ResultadosComparacion.data
    echo " 			 ____________________________________________________________________">>ResultadosComparacion.data
    echo "			|			|			|                    |">>ResultadosComparacion.data
    echo "			|	FICHERO $[$i+1]	|	FICHERO $[$j+1]	|    COINCIDENCIA    |">>ResultadosComparacion.data
    echo "			|_______________________|_______________________|____________________|">>ResultadosComparacion.data
    echo "			|			|			|                    |">>ResultadosComparacion.data
    echo "Num. líneas totales:	| 	    $Nlineas_i		|	    $Nlineas_j		|                    |">>ResultadosComparacion.data
    echo "Num. líneas vacías:	|	    $NlineasVacias_i		|	    $NlineasVacias_j		|                    |">>ResultadosComparacion.data
    echo "Num. líneas comentario:	|	    $NlineasComent_i		|	    $NlineasComent_j		|                    |">>ResultadosComparacion.data
    echo "Num. líneas código:	|	    $NlineasCodigo_i		|	    $NlineasCodigo_j		|                    |">>ResultadosComparacion.data
    echo "			|			|			|                    |">>ResultadosComparacion.data
    echo "Num. sentencias if:	|	    $NSentenciasIF_i		|	    $NSentenciasIF_j		|                    |">>ResultadosComparacion.data
    echo "Num. sentencias for:	|	    $NSentenciasFOR_i		|	    $NSentenciasFOR_j		|                    |">>ResultadosComparacion.data
    echo "Num. sentencias while:	|	    $NSentenciasWHILE_i		|	    $NSentenciasWHILE_j		|                    |">>ResultadosComparacion.data
    echo "Num. sentencias echo:	|	    $NSentenciasECHO_i		|	    $NSentenciasECHO_j		|                    |">>ResultadosComparacion.data
    echo "			|			|			|                    |">>ResultadosComparacion.data
    echo "Num. total variables:	|	    $NVariables_i		|	    $NVariables_j		|                    |">>ResultadosComparacion.data
    echo "			|_______________________|_______________________|____________________|">>ResultadosComparacion.data
    echo>>ResultadosComparacion.data 
    echo "El Fichero \"${PathFile[$i]}\" y el Fichero \"${PathFile[$j]}\" coinciden en un $PorcentajeCoincidencia%">>ResultadosComparacion.data
    echo>>ResultadosComparacion.data 
    echo>>ResultadosComparacion.data 

    done
done

cat ResultadosComparacion.data

#Imprime el contenido del path guardado en PathFile[1]
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
