#!/bin/bash
SCRIPTPATH=/recalbox/scripts/myscripts

# 1 Verification présence Dossier et fichiers 

if [ ! -d $SCRIPTPATH ]; then #si le dossier myscripts n'existe pas on le crée et on récupere les scripts
	mkdir $SCRIPTPATH 
	wget -P $SCRIPTPATH https://raw.githubusercontent.com/Scaff31/toolboxrecalbox/master/reboot_recalbox.sh
	wget -P $SCRIPTPATH https://raw.githubusercontent.com/Scaff31/toolboxrecalbox/master/restart_es.sh
	wget -P $SCRIPTPATH https://raw.githubusercontent.com/substring/fullscrape/master/fullscrape.sh
	
	#On applique les droits pour les utiliser
	
	chmod 755 $SCRIPTPATH/restart_es.sh
	chmod 755 $SCRIPTPATH/reboot_recalbox.sh
	chmod 755 $SCRIPTPATH/fullscrape.sh
fi
