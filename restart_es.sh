#!/bin/bash

script=$(ls /etc/init.d | grep S*emulationstation)

nohup /etc/init.d/$script restart &
