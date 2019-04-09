#!/bin/bash
# mr_safetycheck - do NOT include this line if pasting this into your own pre-existing runcommand-onstart.sh

# copy and paste from here down

# set the megarefresh scripts as executable if they aren't already - installer already does that but better safe than choppy
[ -x /opt/retropie/configs/all/megarefresh/megarefresh-onstart.sh ] && : || chmod +x /opt/retropie/configs/all/megarefresh/megarefresh-onstart.sh
[ -x /opt/retropie/configs/all/megarefresh/megarefresh-onend.sh ] && : || chmod +x /opt/retropie/configs/all/megarefresh/megarefresh-onend.sh

# launch the megarefresh-onstart script
/opt/retropie/configs/all/megarefresh/megarefresh-onstart.sh "$1" "$2" "$3"

# copy and paste until here
