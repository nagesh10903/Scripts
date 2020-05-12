#!/bin/bash

############################
# Google Speech API - Online
############################
function googlesay() { local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=en"; }

##############################
# pico2wave - Text to Speech coverter. 
###############################
function picosay() { 
    picosay=`pico2wave -w /tmp/pspeech.wav  "$*" && aplay -q /tmp/pspeech.wav && rm /tmp/pspeech.wav`
 }

##############################
# Text to Speach Conversion  (offline/online)
##############################
function text2speech()
{
   # Check internet connection.
   # ping google.com
    STATE=`sudo ping -q -w 1 -c 1 google.com > /dev/null && echo OK || echo ERROR`
  # echo "Internet Status:$STATE"
  
    if [ "$STATE" = "OK" ];
    then
        googlesay $*  &  # Online -using google api
    else
        picosay $*   # offline -using pico2wave ibrary.
    fi
}


text2speech $*