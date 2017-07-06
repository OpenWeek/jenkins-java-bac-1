#!/usr/bin/env python

#   Copyright (c) 2017 Carolina Unriza Salamanca, Tom Rousseaux
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

import json
import sys

from pprint import pprint

attributes = [u"customscript", u"nexercices", u"corr", u"execcustom", u"exercice"]

try: 
	with open('config.json') as data_file:
		data = json.load(data_file)
	rep = 0
	for attr in attributes:
		if attr not in data:
			rep = 1
except ValueError:
	rep = 1
if rep == 1:		
	pprint("Le fichier config.json ne contient pas tous les champs necessaires")
sys.exit(rep)	

