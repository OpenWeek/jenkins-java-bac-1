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


#   This script checks the pull requests

cd Tasks
LIST=$(ls)
REP=0

for d in $LIST
do
	#   Let's check if the name of the task corresponds to the nomenclature
	NOMS=$(echo $d | sed "/M[0-9][0-9]Q[0-9][0-9]_[A-Z].*/d")
	if [ ! -z "$NOMS" ]; then
		REP=1
		echo -e "\nThe name of the following folder does not correspond to the nomenclature: "
		echo $NOMS
	else
		CODE=$(echo $d | sed "s/_.*//g")
		TYPE=$(grep environment: $d/task.yaml | sed 's/environment://g' | sed 's/ //g')
		if [ "$TYPE" != "mcq" ]; then
			#   Let's check if the name of the files corresponds to the nomenclature
		
			if [ ! -d "$d/student" ]; then
				echo "missing student folder in $d"
				REP=1
			fi
			for c in "$d/config.json" "$d/run" "$d/task.yaml" "$d/student/$CODE.java" "$d/student/"$CODE"Vide.java" "$d/student/"$CODE"Corr.java"
			do
				if [ ! -f "$c" ]; then
					echo "missing file $c"
					REP=1
				fi
			done
			#   Let's check if all attributes are in config.json file (cfr script.py)
			if [ -f "$d/config.json" ]; then
				cd $d
				chmod +x ../../jenkins-java-bac-1/Scripts/script.py
				../../jenkins-java-bac-1/Scripts/script.py
				REP=$(($REP+$?))
				cd ..	
			fi
			
			#   Let's check if there is no change to the run file
			DIF=$(diff $d/run ../Template/\{exercice\}/run) 
			if [ ! $? -eq 0 ]; then
				REP=$(($REP+$?))
				echo "run file changed in $d"
			fi
		fi
	fi
done
if [ $REP -eq 0 ]; then
	echo "Your submission is OK !"
fi
exit $REP
