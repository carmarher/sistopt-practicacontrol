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

#Establecemos la separación de decimales como en C, para usar sus comandos sin errores
LC_NUMERIC=C


#################################################################################################
#												#
#				INICIO ARCHIVO RESULTADOS:					#
#												#
#################################################################################################

#Inicializamos el archivo de resultados
ArchivoResultados=$(basename "`pwd`").data

echo "	 _______________________________________________________________">$ArchivoResultados
echo "	|								|">>$ArchivoResultados
echo "	|			INFORME RESULTADOS 			|">>$ArchivoResultados
echo "	|		    SCRIPT COMPARACIÓN ARCHIVOS 		|">>$ArchivoResultados
echo "	|_______________________________________________________________|">>$ArchivoResultados
echo "	|								|">>$ArchivoResultados
echo "	|	NOMBRE:	CompareFiles.sh					|">>$ArchivoResultados
echo "	|	AUTOR:	Carlos Martínez Hernández			|">>$ArchivoResultados
echo "	|	FECHA:	09/04/2020					|">>$ArchivoResultados 
echo "	|	DESCRIPCIÓN: Este Script compara el porcentaje de	|">>$ArchivoResultados
echo "	|		     coincidencias que existe entre una serie 	|">>$ArchivoResultados
echo "	|		     de bash-scripts cuyo nombre coincide con 	|">>$ArchivoResultados
echo "	|		     el del subdirectorio que los contiene	|">>$ArchivoResultados
echo "	|_______________________________________________________________|">>$ArchivoResultados
echo>>$ArchivoResultados		#Línea vacía
echo>>$ArchivoResultados


#################################################################################################
#												#
#				CONTROL DE SUBDIRECTORIOS:					#
#												#
#################################################################################################

#Crea una cadena con los subdirectorios del directorio en el que nos encontramos
Subdirectorios=(*/)

#Control 1: Se ha encontrado uno o ningún subdirectorio para comparar
if [ ${#Subdirectorios[@]} -le 1 ]
  then 
  echo "Error: No hay suficientes subdirectorios en este directorio para comparar">>$ArchivoResultados
  echo>>$ArchivoResultados
  cat $ArchivoResultados
  exit
fi

#Cadena con el nombre de los subs. Le hemos quitado "/" al final  
NomSubs=("${Subdirectorios[@]%/}")


#################################################################################################
#												#
#				BÚSQUEDA DE FICHEROS:						#
#												#
#################################################################################################

#Bucle para crear una cadena llamada PathFile con los archivos a comparar
#declaramos una cadena indexada vacía para poder add elementos a ella. Los índices comienzan en 0
declare -a PathFile			
for ((i=0; i<${#NomSubs[@]};i++))
do
  #Creamos una cadena auxiliar con los nombres de los archivos en el subdirectorio i
  AuxFilesSubdir=($(find ./${Subdirectorios[$i]} -maxdepth 1 -mindepth 1 -type f | cut -f 3 -d "/"))
  
  #Bucle para encontrar los ficheros que nos interesan: aquellos cuyo nombre coincide con su subdirectorio
  #Comparamos para cada archivo j, si su nombre coincide con el del subdirectorio que lo contiene
  #Si es así lo añadimos a la cadena PathFile
  for ((j=0; j<${#AuxFilesSubdir[@]};j++))  
  do 
    if [ ${NomSubs[$i]} = ${AuxFilesSubdir[$j]} ]
      then PathFile+=("./${Subdirectorios[$i]}${AuxFilesSubdir[$j]}") 
    fi
  done
done


#################################################################################################
#												#
#				CONTROL DE FICHEROS:						#
#												#
#################################################################################################

#Control 2: Cuántos ficheros se han encontrado para comparar. Si no hay suficientes salimos del script
echo "El Script ha encontrado ${#PathFile[@]} ficheros para comparar.">>$ArchivoResultados
if [ ${#PathFile[@]} = 0 ] || [ ${#PathFile[@]} = 1 ]
  then 
  echo "Error: No hay suficienes ficheros para comparar">>$ArchivoResultados 
  echo>>$ArchivoResultados
  cat $ArchivoResultados
  exit 0
fi
echo>>$ArchivoResultados
echo>>$ArchivoResultados


#################################################################################################
#												#
#				COMPARACIÓN DE FICHEROS:					#
#												#
#################################################################################################

#Bucle que compara los archivos uno a uno sin repetir comparaciones:
for ((i=0; i<${#PathFile[@]};i++))
do
  for ((j=($i+1); j<${#PathFile[@]};j++))  
  do 

    #Trabajando con Arrays:
    NLineas_i[0]=`wc -l < ${PathFile[$i]}`		#Número de líneas totales en fichero i
    NLineas_j[0]=`wc -l < ${PathFile[$j]}` 		#Si escribimos $(wc -l ${PathFile[$j]}) obtenemos lo mismo
    NLineas_i[1]=`grep -c "^\s*$" ${PathFile[$i]}`	#Número de líneas vacías en fichero i
    NLineas_j[1]=`grep -c "^\s*$" ${PathFile[$j]}`
    NLineas_i[2]=`grep -c "^\s*#" ${PathFile[$i]}`	#Número de líneas comentario en fichero i
    NLineas_j[2]=`grep -c "^\#" ${PathFile[$j]}`
    NLineas_i[3]=$[${NLineas_i[0]}-${NLineas_i[1]}-${NLineas_i[2]}]	#Número de líneas netas de código en fichero i
    NLineas_j[3]=$[${NLineas_j[0]}-${NLineas_j[1]}-${NLineas_j[2]}]
    
    NSentencias_i[0]=`grep -c "^\s*if" ${PathFile[$i]}`		#Número de sentencias if (a principio de línea) en fichero i
    NSentencias_j[0]=`grep -c "^\s*if" ${PathFile[$j]}`		#Número de sentencias if (a principio de línea) en fichero i
    NSentencias_i[1]=`grep -c "^\s*for" ${PathFile[$i]}`	#Número de sentencias for (a principio de línea)
    NSentencias_j[1]=`grep -c "^\s*for" ${PathFile[$j]}`
    NSentencias_i[2]=`grep -c "^\s*while" ${PathFile[$i]}`	#Número de sentencias while (a principio de línea)
    NSentencias_j[2]=`grep -c "^\s*while" ${PathFile[$j]}`	
    NSentencias_j[3]=`grep -c "^\s*echo" ${PathFile[$j]}`	#Número de sentencias echo (a principio de línea)
    NSentencias_i[3]=`grep -c "^\s*echo" ${PathFile[$i]}`
    #Las variables definidas tienen entre su nombre y su valor el operador "=" sin espacios
    NSentencias_i[4]=`grep -v "^\s*#" ${PathFile[$i]} | grep = | grep -cv "\s="`	#Número de variables definidas
    NSentencias_j[4]=`grep -v "^\s*#" ${PathFile[$j]} | grep = | grep -cv "\s="`
    
    #Líneas en común 
    NLineasComunes=`comm -12 <(sort ${PathFile[$i]}) <(sort ${PathFile[$j]}) | grep -v "^\s*$" | wc -l`
    #De ellas cuáles son líneas comunes de código neto. No cuenta líneas en blanco ni comentarios
    NLineasComunesNetas=`comm -12 <(sort ${PathFile[$i]}) <(sort ${PathFile[$j]}) | grep -v "^\s*$" | grep -v "^\s*#" | wc -l`
    NLineasComunesComent=$[$NLineasComunes-$NLineasComunesNetas]

    #Tratamiento de las coincidencias de Líneas
    for ((k=0;k<${#NLineas_i[@]};k++))
    do
      Linea[$k]=1	#El indicador de línea no es nulo (1)
      if [ ${NLineas_i[$k]} -gt ${NLineas_j[$k]} ]
        then
        CoincidNLineas[$k]=$(echo "${NLineas_j[$k]}/${NLineas_i[$k]}" | bc -l) 
      elif [ ${NLineas_i[$k]} -lt ${NLineas_j[$k]} ]
        then
        CoincidNLineas[$k]=$(echo "${NLineas_i[$k]}/${NLineas_j[$k]}" | bc -l)
      else
        CoincidNLineas[$k]=1

	if [ ${NLineas_i[$k]} -eq 0 ]
	  then
	  Linea[$k]=0	#El indicador de línea es nulo (0)
	fi
      fi  
    done

    #Tratamiento de las coincidencias de Sentencias
    #Separar ambos tratamientos nos permite ampliar alguna de las Arrays
    AuxProSentencia=${#NSentencias_i[@]}
    for ((k=0;k<${#NSentencias_i[@]};k++))
    do
      Sentencia[$k]=1 		#La sentencia está presente (1)
      if [ ${NSentencias_i[$k]} -gt ${NSentencias_j[$k]} ]
        then
        CoincidNSentencias[$k]=$(echo "${NSentencias_j[$k]}/${NSentencias_i[$k]}" | bc -l) 
      elif [ ${NSentencias_i[$k]} -lt ${NSentencias_j[$k]} ]
        then
        CoincidNSentencias[$k]=$(echo "${NSentencias_i[$k]}/${NSentencias_j[$k]}" | bc -l)
      else
        CoincidNSentencias[$k]=1
        
        #Cálculo del peso específico
	if [ ${NSentencias_i[$k]} -eq 0 ]
	  then 
	  Sentencia[$k]=0 	#La sentencia no está presente (0)
	  AuxProSentencia=$(($AuxProSentencia-1))
	fi
      fi  
    done


#################################################################################################
#												#
#			CÁLCULO DEL PESO ESPECÍFICO DE CADA INDICADOR:				#
#												#
#################################################################################################

#Cálculo del Peso del Indicador Líneas:
#Peso Indicador "Líneas" en Porcentaje de Coincidencia: 40%

    PesoLinea[0]=$(echo "30/100" | bc -l)	#Peso Subindicador "número de líneas totales" en Indicador Líneas: 30%
    PesoLinea[1]=$(echo "10/100" | bc -l)	#Peso Subindicador "número de líneas en blanco" en Indicador Líneas: 10%
    PesoLinea[2]=$(echo "20/100" | bc -l)	#Peso Subindicador "número de líneas comentario" en Indicador Líneas: 20%
    PesoLinea[3]=$(echo "40/100" | bc -l)	#Peso Subindicador "número de líneas de código" en Indicador Líneas: 40%
    
    PorcentajeLineas=0
    FicherosVacios=1	#Control por si los ficheros están vacíos
    if [ ${Linea[0]} -eq 0 ]
      then
	#Los ficheros están vacíos: 
        FicherosVacios=0
    elif [ ${Linea[1]} -eq 0 ]	#Si no hay líneas vacías: todo son líneas comentario o líneas código
      then 
      PesoLinea[0]=$(echo "${PesoLinea[0]} + (${PesoLinea[1]}/3)" | bc -l)
      PesoLinea[2]=$(echo "${PesoLinea[2]} + (${PesoLinea[1]}/3)" | bc -l)
      PesoLinea[3]=$(echo "${PesoLinea[3]} + (${PesoLinea[1]}/3)" | bc -l)
      for ((k=0;k<${#Linea[@]};k++))
      do
        PorcentajeLineas=$(echo "$PorcentajeLineas+(${Linea[$k]}*${PesoLinea[$k]}*${CoincidNLineas[$k]})" | bc -l)
      done

      if [ ${Linea[2]} -eq 0 ]	#Si no hay líneas comentario: todas las líneas son de código
        then
	PorcentajeLineas=${CoincidNLineas[0]}
      elif [ ${Linea[3]} -eq 0 ] #Si no hay líneas código: todas las líneas son comentarios
        then
	PorcentajeLineas=${CoincidNLineas[0]}
      fi

    elif [ ${Linea[2]} -eq 0 ]	#Si no hay líneas comentario: todo son líneas vacías o líneas código
      then 
      PesoLinea[0]=$(echo "${PesoLinea[0]} + (${PesoLinea[2]}/3)" | bc -l)
      PesoLinea[1]=$(echo "${PesoLinea[1]} + (${PesoLinea[2]}/3)" | bc -l)
      PesoLinea[3]=$(echo "${PesoLinea[3]} + (${PesoLinea[2]}/3)" | bc -l)
      for ((k=0;k<${#Linea[@]};k++))
      do
        PorcentajeLineas=$(echo "$PorcentajeLineas+(${Linea[$k]}*${PesoLinea[$k]}*${CoincidNLineas[$k]})" | bc -l)
      done
      
      if [ ${Linea[3]} -eq 0 ]	#Si no hay líneas código: todas las líneas son vacías
        then
	PorcentajeLineas=${CoincidNLineas[0]}
      fi

    elif [ ${Linea[3]} -eq 0 ]	#Si no hay líneas código: todo son líneas vacías o líneas comentario
      then 
      PesoLinea[0]=$(echo "${PesoLinea[0]} + (${PesoLinea[3]}/3)" | bc -l)
      PesoLinea[1]=$(echo "${PesoLinea[1]} + (${PesoLinea[3]}/3)" | bc -l)
      PesoLinea[2]=$(echo "${PesoLinea[2]} + (${PesoLinea[3]}/3)" | bc -l)
      for ((k=0;k<${#Linea[@]};k++))
      do
        PorcentajeLineas=$(echo "$PorcentajeLineas+(${Linea[$k]}*${PesoLinea[$k]}*${CoincidNLineas[$k]})" | bc -l)
      done
      
    else  
      for ((k=0;k<${#Linea[@]};k++))
      do
        PorcentajeLineas=$(echo "$PorcentajeLineas+(${Linea[$k]}*${PesoLinea[$k]}*${CoincidNLineas[$k]})" | bc -l)
      done
    fi

#Cálculo del Peso del Indicador Sentencias:
#Peso Indicador "Sentencias" en Porcentaje de Coincidencia: 60%
    
    if [ $AuxProSentencia -ne 0 ]
      then
      PesoSentencia=$(echo "1/$AuxProSentencia" | bc -l)	#Todos los tipos de sentencia, si están tienen el mismo peso
    else
      PesoSentencia=0
    fi  
    
    PorcentajeSentencias=0
    for ((k=0;k<${#Sentencia[@]};k++))
    do
      PorcentajeSentencias=$(echo "$PorcentajeSentencias+(${Sentencia[$k]}*$PesoSentencia*${CoincidNSentencias[$k]})" | bc -l)
    done

#Cálculo del Porcentaje de coincidencia    
#Peso Indicador "Líneas" en Porcentaje de Coincidencia: 40%
#Peso Indicador "Sentencias" en Porcentaje de Coincidencia: 60%
    PorcentajeCoincidencia=$(echo "((0.4*$PorcentajeLineas) + (0.6*$PorcentajeSentencias))*100" | bc -l)


#################################################################################################
#												#
#				IMPRESIÓN DE RESULTADOS:					#
#												#
#		Notas:										#
#		- Printf nos permite imprimir resultados con 2 decimales			#
#												#
#################################################################################################

    echo "Comparando Fichero $[$i+1]:\"${PathFile[$i]}\" con Fichero $[$j+1]: \"${PathFile[$j]}\":">>$ArchivoResultados
    echo " 			 ____________________________________________________________________">>$ArchivoResultados
    echo "			|			|			|                    |">>$ArchivoResultados
    echo "			|	FICHERO $[$i+1]	|	FICHERO $[$j+1]	|    COINCIDENCIA    |">>$ArchivoResultados
    echo "			|_______________________|_______________________|____________________|">>$ArchivoResultados
    echo "			|			|			|                    |">>$ArchivoResultados
    printf "Num. líneas totales:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[0]}" "${NLineas_j[0]}" "${CoincidNLineas[0]}">>$ArchivoResultados
    printf "Num. líneas vacías:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[1]}" "${NLineas_j[1]}" "${CoincidNLineas[1]}">>$ArchivoResultados
    printf "Num. líneas comentario:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[2]}" "${NLineas_j[2]}" "${CoincidNLineas[2]}">>$ArchivoResultados
    printf "Num. líneas código:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NLineas_i[3]}" "${NLineas_j[3]}" "${CoincidNLineas[3]}">>$ArchivoResultados
    echo "			|			|			|                    |">>$ArchivoResultados
    printf "Num. sentencias if:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NSentencias_i[0]}" "${NSentencias_j[0]}" "${CoincidNSentencias[0]}">>$ArchivoResultados
    printf "Num. sentencias for:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NSentencias_i[1]}" "${NSentencias_j[1]}" "${CoincidNSentencias[1]}">>$ArchivoResultados
    printf "Num. sentencias while:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NSentencias_i[2]}" "${NSentencias_j[2]}" "${CoincidNSentencias[2]}">>$ArchivoResultados
    printf "Num. sentencias echo:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NSentencias_i[3]}" "${NSentencias_j[3]}" "${CoincidNSentencias[3]}">>$ArchivoResultados
    echo "			|			|			|                    |">>$ArchivoResultados
    printf "Num. total variables:\t|\t    %d\t\t|\t    %d\t\t|         %.2f       |\n" "${NSentencias_i[4]}" "${NSentencias_j[4]}" "${CoincidNSentencias[4]}">>$ArchivoResultados
    echo "			|_______________________|_______________________|____________________|">>$ArchivoResultados
    echo>>$ArchivoResultados 
    echo "El Fichero \"${PathFile[$i]}\" y el Fichero \"${PathFile[$j]}\" tienen $NLineasComunes líneas en común.">>$ArchivoResultados
    if [ $NLineasComunes -ne 0 ]
      then
      echo "Pero sólo comparten $NLineasComunesNetas líneas de código, las $NLineasComunesComent restantes son comentarios." >>$ArchivoResultados
    fi
    echo>>$ArchivoResultados 
    if [ $FicherosVacios -eq 0 ]
      then
      echo "El Fichero \"${PathFile[$i]}\" y el Fichero \"${PathFile[$j]}\" están vacíos">>$ArchivoResultados
    else
      echo -n "El Fichero \"${PathFile[$i]}\" y el Fichero \"${PathFile[$j]}\" coinciden en un ">>$ArchivoResultados 
      printf "%.2f" "$PorcentajeCoincidencia">>$ArchivoResultados
      echo "%">>$ArchivoResultados
    fi
    echo>>$ArchivoResultados 
    echo>>$ArchivoResultados 
    echo>>$ArchivoResultados 

    done
done

#Muestra Resultados por pantalla
cat $ArchivoResultados

echo "Nota: Para obtener más información de cómo se ha obtenido el porcentaje de coincidencia entre archivos, revisar la explicación al final del archivo de resultados"
echo ""
echo ""
echo>>$ArchivoResultados 
echo>>$ArchivoResultados 
echo>>$ArchivoResultados 


#################################################################################################
#												#
#				EXPLICACIÓN DE METODOLOGÍA EMPLEADA:				#
#												#
#		Notas:										#
#		- Esta explicación no se incluye en los resultados vistos por pantalla		#
#		para no saturar de información al usuario					#
#												#
#################################################################################################

echo "METODOLOGÍA EMPLEADA EN EL CÁLCULO DE LOS PORCENTAJES DE COINCIDENCIA:">>$ArchivoResultados 
echo>>$ArchivoResultados 
echo "Para calcular el porcentaje de coincidencia entre dos ficheros se ha usado una metodología de pesos ponderados, así cada variable empleada dispone, en general, de un peso específico diferente en el porcentaje final de coincidencia.

Hemos dividido el porcentaje final de coincidencias en dos Indicadores: Indicador Líneas e Indicador Sentencias

El Indicador Líneas tiene un peso sobre el porcentaje final del 40% y en él están comprendidas los siguientes
subindicadores con los siguientes pesos:
- El Subindicador Líneas Totales tiene un peso en el Indicador Líneas de un 30%
- El Subindicador Líneas en blanco tiene un peso en el Indicador Líneas de un 10%
- El Subindicador Líneas comentario tiene un peso en el Indicador Líneas de un 30%
- El Subindicador Líneas código tiene un peso en el Indicador Líneas de un 40%
Si alguno de los Subindicadores no apareciera su peso se repartiría entre el resto de Subindicadores Línea

El Indicador Sentencias tiene un peso sobre el porcentaje final del 60% y en el están comprendidos los siguientes
Subindicadores. Los pesos relativos de cada uno de ellos son iguales:
- El Subindicador Sentencias IF tiene un peso en el Indicador Sentencias de un 20%
- El Subindicador Sentencias FOR tiene un peso en el Indicador Sentencias de un 20%
- El Subindicador Sentencias WHILE tiene un peso en el Indicador Sentencias de un 20%
- El Subindicador Sentencias ECHO tiene un peso en el Indicador Sentencias de un 20%
- El Subindicador Variables tiene un peso en el Indicador Sentencias de un 20%
Si alguno de los Subindicadores no apareciera su peso se repartiría entre el resto de Subindicadores Sentencia

ATENCIÓN: Hay que tener en cuenta que este Script está orientado a comparar Scripts, no va a funcionar correctamente si comparamos otro tipo de ficheros. Puede darse el caso de que comparemos dos archivos de texto idénticos y sólo consigamos un porcentaje de coincidencia del 30%.">>$ArchivoResultados 


#################################################################################################
#												#
#					FIN DEL SCRIPT:						#
#												#
#################################################################################################
