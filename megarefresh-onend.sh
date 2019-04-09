#!/bin/bash
#========================================================================================================================
#
#title		: megarefresh-onend.sh - Zak's MegaRefresh script
#description	: This script performs the following:
#		: restores native LCD resolution and 60 Hz refresh after exiting game in Retropie
#		: companion to megarefresh-onstart.sh
#author		: Francesco Zacchi - fzlists@gmail.com
#date		: 2019-03-30
#version	: 1.3 - do nothing if -onstart did nothing
#notes		:
#
#========================================================================================================================

# skip if script toggle is set as disabled
if [ ! -f /opt/retropie/configs/all/megarefresh/megarefresh-enabled ] ; then exit ; fi

# restore the monitor's native, preferred resolution and refresh rate only if it's been changed by -onstart
# else do nothing (shave a couple of seconds going back into EmulationStation)
if [ -f /opt/retropie/configs/all/megarefresh/megarefresh-engaged ] ; then 
	
	tvservice -p > /dev/null
	sleep 0.2 && fbset -depth 8 && fbset -depth 16

fi

