#!/bin/bash
# Buscar para web por http, https, https?, ssl, ssl|http, ssl|https, ssl|https?
# xtract-proto-srv.sh http file.gnmap

grep $1 $2  > temporal.txt
numlinea=1
prevIFS=$IFS
IFS=$'\n'
for linea in `cat temporal.txt`
	do 
		echo $linea > lineatemp.txt
		host=`cat lineatemp.txt | cut -d " " -f 2`
		flagquiebrehost=1
		camposxlinea=`cat lineatemp.txt | wc -w`
		for (( campo = 1; campo <= camposxlinea; campo++ ))
			do
				tipodelim=`grep , lineatemp.txt | wc -l`
				if [ $tipodelim -ge 1 ]
				then
					delim=","
				else
					delim=" "
				fi
				cat lineatemp.txt | cut -d $delim -f $campo > puertotemp.txt
				proto=`cat puertotemp.txt | cut -d "/" -f 5`
				if  [[ $proto =~ $1 ]]
				then
					estado=`cat puertotemp.txt | cut -d "/" -f 2`
					if [ "$estado" == "open" ]
					then
						#Definicion default de puerto para cualquier linea
						port=`cat puertotemp.txt | cut -d "/" -f 1`
						#Quiebre por host en reporte y definicion de puerto en caso cumple el primer puerto escaneado
						if [ $flagquiebrehost -eq 1 ]
						then
							echo -e "######### Host : $host ---> \n"
							if [ `grep ^Host puertotemp.txt | wc -l` -ge 1 ] 
							then
								port=`cat puertotemp.txt | cut -d " " -f  4 | cut -d "/" -f 1`
							fi
							flagquiebrehost=0
						fi
						service=`cat puertotemp.txt | cut -d "/" -f 7`
						echo -e "$proto / $port / $estado ---> $service \n"
					fi
				fi
			done
		#echo -e "\n"
	done
IFS=$prevIFS
