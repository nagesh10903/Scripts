#!/bin/bash

SP_TEXT=""
VOL=60
############################
# Google Speech API - Online
############################
function googlesay() {
local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=en";
}

#######################
# Telegu Voice TTS - iit
#####################
function telugusay() {
 LANG_TEXT=`sudo /home/pi/Scripts/speech/trans -b  -t te  "$*"`
  #URL Encode
 DATA=$(python -c "import urllib, sys; print urllib.quote(sys.argv[1])"  "$LANG_TEXT")
#echo "$DATA"
 URL=`curl -s -G $(echo "http://tts.iiit.ac.in/~kishore/cgi-bin/TTS_telugu.cgi?sel_voice=lenina_tel_hts&utf8=${DATA}")  |grep path | awk -F[\<\ ] '{print "http://tts.iiit.ac.in/~kishore/" $2  }' `
#echo "$URL" 
 IFS=`/usr/bin/mplayer -volume $VOL -ao alsa -really-quiet -noconsolecontrols $URL;`
 }

#######################
# Hindi Voice TTS - Text in english.
#####################
function hindisay() {
#echo "TEXT= $*"
   HINDI=`sudo /home/pi/Scripts/speech/trans -p -b  -t hi  "$*"`
# local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=en";
 }

##############################
# pico2wave - Text to Speech coverter.
###############################
function picosay() {
    picosay=`sudo pico2wave -w /tmp/pspeech.wav  "$*" && /usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols  --volume=$VOL /tmp/pspeech.wav && sudo rm -f /tmp/pspeech.wav`
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
       # googlesay $*  &  # Online -using google api
      # hindisay $*  &
       telugusay $*  &
    else
        picosay $*   # offline -using pico2wave ibrary.
    fi
}

##############################
# Wake Up time : early morning
# switch on light
##############################
function wakeup(){
WAKEUP=`sudo python /home/pi/Scripts/python/ir_devices.py  LIGHT ON   >>/tmp/ir_devices.log`
sleep 1
WAKEUP=`sudo python /home/pi/Scripts/python/ir_devices.py  FAN  OFF   >>/tmp/ir_devices.log`
}

##############################
# Night time : Sleeping time
# switch off light
##############################
function goodnight(){
GOODNIGHT=`sudo python /home/pi/Scripts/python/ir_devices.py  LIGHT OFF  >>/tmp/ir_devices.log`
RADIO=`mpc stop`
}

################################
# Get the text to speak  and set the scene.
###############################
function setscene(){
 # Time for every half hour.
 # sp_time=`date +"Time is %T"`
  sp_time=`date +"Time is %I %M %p"`
  SP_TEXT=$sp_time
  sp_date=`date +"Today %A %d %B %Y"`
  sp_hr=`date +%H`
  sp_hr12=`date +%I`
  sp_mi=`date +%M`
  time_text=""
 if [[ $sp_mi <1 ]];
  then
    time_text=$(echo "$sp_hr12 hours")
  else
   time_text=$(echo "$sp_hr12 hours $sp_mi minutes")
  fi
  SP_TEXT=$(echo "Time is $time_text")
  #echo " set -- $SP_TEXT"

 # Morning time
  if [ $sp_hr -ge 6 -a  $sp_hr -le 11 ];
  then
    #wakeup
   # SP_TEXT=`echo $sp_date $sp_time`
   SP_TEXT=`echo "$sp_date and time is morning $time_text"`

# After Noon -Office time
  elif [[ ( $sp_hr > 12 && $sp_hr < 14 ) ]];
  then
   #goodnight
   # SP_TEXT=`echo "$sp_time , Office Time"`
   SP_TEXT=`echo "time is afternoon $time_text, office Time"`

# Evening Time
  elif [[ ( $sp_hr > 13 && $sp_hr < 22 ) ]];
  then
    SP_TEXT=`echo "Time is $time_text "`
# Night Time
  elif [[ ( $sp_hr > 21 ) ]];
  then
    goodnight
  #  SP_TEXT=`echo "$sp_time , Sleeping Time"`
    SP_TEXT=`echo "time is night $time_text sleeping time"`
 elif [[ ($sp_hr < 5 ) ]];
  then
    goodnight
  #  SP_TEXT=`echo "$sp_time , Sleeping Time"`
    SP_TEXT=`echo "time is night $time_text sleeping time"`
  fi

#### Handle Radio
#Radio Morning Start
 if [ $sp_hr -eq 6 -a  $sp_mi -lt 55 -a $sp_mi -ge 5 ];
 then
#  RADIO=`mpc play`
   RADIO="" 
#Radio Morning/Night Stop
 elif [[ ( $sp_hr == 9 || $sp_hr > 22 ) && (  $sp_mi > 3 ) ]];
 then
  RADIO=`mpc stop`
  SP_TEXT=$SP_TEXT',Stoping Radio..'
 fi
  }


###################################################
# Main script.
###################################################

if [ -z $1 ];
then
 setscene
 #echo $SP_TEXT
 text2speech $SP_TEXT
else
  text2speech "$@"
 echo "Param is: $@"
fi


# Set Time  from google
sudo sntp -s time.google.com > /dev/null
