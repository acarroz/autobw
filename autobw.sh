#!/bin/bash

logfile=$(echo "$0.log" | sed "s/.sh//g")

maxdownspeed="90.0"
maxupspeed="30.0"

regdownspeed="60.0"
regupspeed="15.0"

wincount=$(smbtree -S -N -b | grep '\\\\' | grep -v "`hostname`" | wc -l)
currdownspeed=$(deluge-console "config max_download_speed" | sed 's/  max_download_speed: //g')
now=$(date +"%F %T")

if [ $wincount -gt 0 ]; then
  if [ $currdownspeed != $regdownspeed ]; then
    deluge-console "config --set max_download_speed $regdownspeed"
    deluge-console "config --set max_upload_speed $regupspeed"

    echo "$now	*REG*	$wincount hosts found" >> $logfile
  fi
else
  if [ $currdownspeed != $maxdownspeed ]; then
    deluge-console "config --set max_download_speed $maxdownspeed"
    deluge-console "config --set max_upload_speed $maxupspeed"

    echo "$now	*MAX*	$wincount hosts found" >> $logfile
  fi
fi
