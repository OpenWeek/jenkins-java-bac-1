#!/usr/bin/env python
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

