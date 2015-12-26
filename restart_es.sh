#!/bin/bash

if ls /etc/init.d | grep S92emulationstation; then 
	script=S92emulationstation
else
	script=S31emulationstation
fi

nohup /etc/init.d/$script restart &
