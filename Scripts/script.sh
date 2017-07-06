#! /bin/bash

#   Copyright (c) 2017 Tom Rousseaux
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


#   Ce script lance tous les tests de conformité de la pull request.

cd tasks
LIST=$(ls)
REP=0

for d in $LIST
do
	#   On vérifie que le nom de la tâche correspond à la nomenclature
	NOMS=$(echo $d | sed "/M[0-9][0-9]Q[0-9][0-9]_[A-Z].*/d")
	if [ ! -z "$NOMS" ]; then
		REP=1
		echo -e "\nLe nom de dossier suivant ne correspond pas à la nomenclature de nomage : "
		echo $NOMS
	else
		CODE=$(echo $d | sed "s/_.*//g")
		TYPE=$(grep environment: $d/task.yaml | sed 's/environment://g' | sed 's/ //g')
		if [ "$TYPE" != "mcq" ]; then
			#   On vérifie que les noms des fichiers correspondent à la nomenclature
		
			if [ ! -d "$d/student" ]; then
				echo "absence du dossier student dans $d"
				REP=1
			fi
			for c in "$d/config.json" "$d/run" "$d/task.yaml" "$d/student/$CODE.java" "$d/student/"$CODE"Vide.java" "$d/student/"$CODE"Corr.java"
			do
				if [ ! -f "$c" ]; then
					echo "absence du fichier $c"
					REP=1
				fi
			done
			#   On vérifie la présence de tous les éléments dans le config.json (voir script.py)
			if [ -f "$d/config.json" ]; then
				cd $d
				../../script.py
				cd ..
				REP=$(($REP+$?))	
			fi
			
			#   On vérifie que le fichier run n'a pas été modifié
			DIF=$(diff $d/run ../template/\{exercice\}/run) 
			if [ ! $? == 0 ]; then
				REP=$(($REP+$?))
				echo -e "\n\nMODIFICATION DU RUN DE $d\n\n"
				echo "$DIF"
				echo -e "\n\nFIN DES MODIFICATION\n\n"
			fi
		fi
	fi
done
exit $REP
