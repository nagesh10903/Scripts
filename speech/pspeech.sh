#!/bin/bash

picosay() {sudo pico2wave -w /tmp/pspeech.wav  "$*" && aplay -q /tmp/pspeech.wav && rm /tmp/pspeech.wav }

picosay $*

