#! /bin/bash

#################################################################################################
#												#
#				INICIO DEL SCRIPT:						#
#												#
#		Notas:										#
#		- #! /bin/bash --> Hemos elegido la shell Bash					#
#		- shopt -s nullglob --> Las arrays estarán vacías si no encuentran nada		#
#		- LC_NUMERIC=C --> Separación decimal con punto igual que en C			#
#												#
#################################################################################################

 
#La array estará vacía si no encuentra coincidencias
shopt -s nullglob
#shopt -s dotglob

#Establecemos la separación de decimales como en C, para usar sus comandos sin errores
LC_NUMERIC=C

#Test: Aquí también hay un comentario y tiene if, do, for, while


#################################################################################################
#	TO DO:											#
#		- PONER NÚMERO DE LINEAS COMUNES						#
#		- CONTINUAR RELLENANDO LOS VECTORES DE SENTENCIAS Y VARIABLES			#
#		- HACER MEDIA PONDERADA DE LOS PORCENTAJES					#
#		- ORGANIZAR EL CÓDIGO CON COMENTARIOS COMO ESTE					#
#		- PONER EXPLICACIÓN AL FINAL O EN OTRO ARCHIVO DE LOS PESOS CONSIDERADOS	#
#    		  EN LA PONDERACIÓN								#
#################################################################################################

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

#Aviso de que no se ha encontrado uno o ningún subdirectorio para comparar
if [ ${#Subdirectorios[@]} -le 1 ]
  then 
  #Salida en negrita:
  #echo -e '\033[1m'>>ResultadosComparacion.data 
  echo "Error: No hay suficientes subdirectorios en este directorio para comparar">>ResultadosComparacion.data
  #Desactiva salida en negrita:
  #echo -e '\033[0m'>>ResultadosComparacion.data 
  echo>>ResultadosComparacion.data
  cat ResultadosComparacion.data
  exit
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

#Aviso de ficheros encontrados para comparar:
echo "El Script ha encontrado ${#PathFile[@]} ficheros para comparar.">>ResultadosComparacion.data
if [ ${#PathFile[@]} = 0 ] || [ ${#PathFile[@]} = 1 ]
  then 
  echo "Error: No hay suficienes ficheros para comparar">>ResultadosComparacion.data 
  echo>>ResultadosComparacion.data
  cat ResultadosComparacion.data
  exit 0
fi
echo>>ResultadosComparacion.data
echo>>ResultadosComparacion.data

#Bucle que compara los archivos uno a uno sin repetir comparaciones:
for ((i=0; i<${#PathFile[@]};i++))
do
  for ((j=($i+1); j<${#PathFile[@]};j++))  
  do 

    #Trabajando con Arrays:
    NLineas_i[0]=`wc -l < ${PathFile[$i]}`	#Número de líneas totales en fichero i
    NLineas_j[0]=`wc -l < ${PathFile[$j]}` 	#Si escribimos $(wc -l ${PathFile[$j]}) obtenemos lo mismo
    NLineas_i[1]=`grep -c "^\s*$" ${PathFile[$i]}`	#Número de líneas vacías en fichero i
    NLineas_j[1]=`grep -c "^\s*$" ${PathFile[$j]}`
    NLineas_i[2]=`grep -c "^\#" ${PathFile[$i]}`	#Número de líneas comentario en fichero i
    NLineas_j[2]=`grep -c "^\#" ${PathFile[$j]}`
    NLineas_i[3]=$[${NLineas_i[0]}-${NLineas_i[1]}-${NLineas_i[2]}]	#Número de líneas netas de código en fichero i
    NLineas_j[3]=$[${NLineas_j[0]}-${NLineas_j[1]}-${NLineas_j[2]}]
    
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
    
    #Sólo cuenta las líneas comunes de código neto. 
    #No cuenta líneas en blanco ni comentarios
    NLineasComunes=`comm -12 <(sort ${PathFile[$i]}) <(sort ${PathFile[$i]}) | grep -v "^\s*$" | grep -v "^\s*#" | wc -l`

    #Tratamiento de las coincidencias con Arrays
    for ((k=0;k<${#NLineas_i[@]};k++))
    do
      if [ ${NLineas_i[$k]} -gt ${NLineas_j[$k]} ]
        then
        CoincidNLineas[$k]=$(echo "${NLineas_j[$k]}/${NLineas_i[$k]}" | bc -l 2>/dev/null) #Si está dividido por 0 no imprime error  con 2>/dev/null
      elif [ $NLineas_i -lt $NLineas_j ]
        then
        CoincidNLineas[$k]=$(echo "${NLineas_i[$k]}/${NLineas_j[$k]}" | bc -l 2>/dev/null)
      else
        CoincidNLineas[$k]=1
      fi  
    done

    
    PorcentajeCoincidencia=100


#################################################################################################
#												#
#				IMPRESIÓN DE RESULTADOS:					#
#												#
#		Notas:										#
#		- Printf nos permite imprimir resultados con 2 decimales			#
#												#
#################################################################################################

    #Impresión de resultados
    echo "Comparando Fichero $[$i+1]:\"${PathFile[$i]}\" con Fichero $[$j+1]: \"${PathFile[$j]}\":">>ResultadosComparacion.data
    echo " 			 ____________________________________________________________________">>ResultadosComparacion.data
    echo "			|			|			|                    |">>ResultadosComparacion.data
    echo "			|	FICHERO $[$i+1]	|	FICHERO $[$j+1]	|    COINCIDENCIA    |">>ResultadosComparacion.data
    echo "			|_______________________|_______________________|____________________|">>ResultadosComparacion.data
    echo "			|			|			|                    |">>ResultadosComparacion.data
    printf "Num. líneas totales:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[0]}" "${NLineas_j[0]}" "${CoincidNLineas[0]}">>ResultadosComparacion.data
    printf "Num. líneas vacías:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[1]}" "${NLineas_j[1]}" "${CoincidNLineas[1]}">>ResultadosComparacion.data
    printf "Num. líneas comentario:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[2]}" "${NLineas_j[2]}" "${CoincidNLineas[2]}">>ResultadosComparacion.data
    printf "Num. líneas código:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[3]}" "${NLineas_j[3]}" "${CoincidNLineas[3]}">>ResultadosComparacion.data
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
#
#    #Trabajando con variables simples
#    NLineas_i=`wc -l < ${PathFile[$i]}`
#    NLineas_j=`wc -l < ${PathFile[$j]}` # Si escribimos $(wc -l ${PathFile[$j]}) obtenemos lo mismo
#    NLineasVacias_i=`grep -c "^\s*$" ${PathFile[$i]}`
#    NLineasVacias_j=`grep -c "^\s*$" ${PathFile[$j]}`
#    NLineasComent_i=`grep -c "^\#" ${PathFile[$i]}`
#    NLineasComent_j=`grep -c "^\#" ${PathFile[$j]}`
#    NLineasCodigo_i=$[$NLineas_i-$NLineasVacias_i-$NLineasComent_i]
#    NLineasCodigo_j=$[$NLineas_j-$NLineasVacias_j-$NLineasComent_j]
#
#    #Tratamiento de las coincidencias sin arrays
#    if [ $NLineas_i -gt $NLineas_j ]
#      then
#      CoincidNLineas=$(echo "$NLineas_j/$NLineas_i" | bc -l)
#    elif [ $NLineas_i -lt $NLineas_j ]
#      then
#      CoincidNLineas=$(echo "$NLineas_i/$NLineas_j" | bc -l)
#    else
#      CoincidNLineas=1
#    fi  
#
#Impresión de resultados sólo con echo (no permite formatear decimales)
#    echo "Comparando Fichero $[$i+1]:\"${PathFile[$i]}\" con Fichero $[$j+1]: \"${PathFile[$j]}\":">>ResultadosComparacion.data
#    echo " 			 ____________________________________________________________________">>ResultadosComparacion.data
#    echo "			|			|			|                    |">>ResultadosComparacion.data
#    echo "			|	FICHERO $[$i+1]	|	FICHERO $[$j+1]	|    COINCIDENCIA    |">>ResultadosComparacion.data
#    echo "			|_______________________|_______________________|____________________|">>ResultadosComparacion.data
#    echo "			|			|			|                    |">>ResultadosComparacion.data
#    echo "Num. líneas totales:	| 	    $NLineas_i		|	    $NLineas_j		|         $CoincidNLineas	|">>ResultadosComparacion.data
#    echo "Num. líneas vacías:	|	    $NLineasVacias_i		|	    $NLineasVacias_j		|                    |">>ResultadosComparacion.data
#    echo "Num. líneas comentario:	|	    $NLineasComent_i		|	    $NLineasComent_j		|                    |">>ResultadosComparacion.data
#    echo "Num. líneas código:	|	    $NLineasCodigo_i		|	    $NLineasCodigo_j		|                    |">>ResultadosComparacion.data
#    echo "			|			|			|                    |">>ResultadosComparacion.data
#    echo "Num. sentencias if:	|	    $NSentenciasIF_i		|	    $NSentenciasIF_j		|                    |">>ResultadosComparacion.data
#    echo "Num. sentencias for:	|	    $NSentenciasFOR_i		|	    $NSentenciasFOR_j		|                    |">>ResultadosComparacion.data
#    echo "Num. sentencias while:	|	    $NSentenciasWHILE_i		|	    $NSentenciasWHILE_j		|                    |">>ResultadosComparacion.data
#    echo "Num. sentencias echo:	|	    $NSentenciasECHO_i		|	    $NSentenciasECHO_j		|                    |">>ResultadosComparacion.data
#    echo "			|			|			|                    |">>ResultadosComparacion.data
#    echo "Num. total variables:	|	    $NVariables_i		|	    $NVariables_j		|                    |">>ResultadosComparacion.data
#    echo "			|_______________________|_______________________|____________________|">>ResultadosComparacion.data
#    echo>>ResultadosComparacion.data 
#    echo "El Fichero \"${PathFile[$i]}\" y el Fichero \"${PathFile[$j]}\" coinciden en un $PorcentajeCoincidencia%">>ResultadosComparacion.data
#    echo>>ResultadosComparacion.data 
#    echo>>ResultadosComparacion.data 
