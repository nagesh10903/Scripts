#!/bin/bash

source /home/pi/Scripts/speech/sspeech.sh NORUN

CMD=""
PLAYING=""
TEXT=""
# mpc Player -Next in Playlist
function next(){
    CMD=`sudo mpc play $(mpc | grep playing | awk -F[#/\ ] '{if($3+1 >$4) print 1; else print $3+1}')`
    TEXT="Playing $( mpc | grep playing | awk -F[#/\ ] '{print $3 " of "  $4 }')  $(mpc current | awk -F: '{print $1}')"

    }

#mpc player -Previous Playlist
 function prev(){
    CMD=`sudo mpc play $(mpc | grep playing | awk -F[#/\ ] '{if($3-1 == 0) print $4; else print $3-1}')`
   TEXT="Playing $( mpc | grep playing | awk -F[#/\ ] '{print $3 " of "  $4 }')  $(mpc current | awk -F: '{print $1}')"
    }
   
function volume(){
    CMD=`sudo mpc volume $1`
    TEXT="Radio $(mpc |grep volume | awk -F[%] '{print $1}')"
}

function toggle(){
    CMD=`sudo mpc toggle`
    TEXT="Toggel Radio"
}

function mpc_stop(){
    CMD=`sudo mpc stop`
     TEXT="Stoping Radio"
}

function mpc_start(){
    CMD=`sudo mpc play`     
     TEXT="Starting $( mpc | grep playing | awk -F[#/\ ] '{print $3 " of "  $4 }')  $(mpc current | awk -F: '{print $1}')"
}

#########################

case $1  in
   START) mpc_start ;;
   STOP)  mpc_stop ;;
   TOGGLE) toggle ;;
   VOLUME) volume $2 ;;
   VOL) volume $2 ;;
   NEXT) next ;;
   PREV) prev ;;
    *)   mpc_start ;;
esac


text2speech $TEXT

sudo echo -e "$(date +'%D %T') : $CMD \n"  >> /tmp/radio.log
