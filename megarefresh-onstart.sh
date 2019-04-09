#!/bin/bash
#========================================================================================================================
#
#title			:	megarefresh-onstart.sh - Zak's MegaRefresh script
#description		:	This script performs the following:
#			:	Dynamic, game-specific LCD monitor refresh rate switching under RetroPie for Raspberry Pi
#			:		companion to megarefresh-onend.sh
#author			:	Francesco Zacchi - fzlists@gmail.com
#date			:	2019-03-30
#version		:	2.1 - do nothing if there's no need instead of setting the monitor's standard res anyway
#notes			:	everything working, needs refreshlist.txt and systems.txt in same directory
#
#========================================================================================================================

# reset the script status
rm -f /opt/retropie/configs/all/megarefresh/megarefresh-engaged

# skip if script toggle is set as disabled
if [ ! -f /opt/retropie/configs/all/megarefresh/megarefresh-enabled ] ; then exit ; fi

# lenght of on-screen notification at launch in seconds (0 for silent operation)
slen=2

# parse for empty or unset runcommand variables on input and exit right away, just to be safe
if [[ -z "$1" ]] || [[ -z "$2" ]] ; then
echo
	echo    "   Zak's MegaRefresh script v1.0"
	echo	"   Missing system or emulator name"
	echo	"   Bypassing the script ..."
	sleep $slen
	exit
fi

# get the system name
system=$1

# get the emulator name
emul=$2

# get the full path filename of the ROM
rom_fp=$3
rom_bn=$3

# game or Rom name
rom_bn="${rom_bn%.*}"
rom_bn="${rom_bn##*/}"

# parse skip.txt for systems, emulators or roms that need to bypass MegaRefresh for proper functioning
if grep -xq "$system\|$emul\$rom_bn" /opt/retropie/configs/all/megarefresh/skip.txt ; then
	echo
	echo    "   Zak's MegaRefresh script v1.0"
	echo	"   This system, emulator or game is flagged as 'skip'"
	echo	"   Bypassing the script ..."
	sleep $slen
	exit
fi

# get native LCD resolution
res=$(tvservice -s | cut -d "," -f2)
x_res=$(echo $res | cut -d "x" -f1)
y_res=$(echo $res | cut -d "x" -f2 | cut -c 1-4)

# step 1 of 4
# parse the ROM's filename for PAL region tags (for mixed PAL/NTSC romsets)

if grep -q "(Europe)\|(Spain)\|(France)\|(Germany)\|(Italy)\|(UK)\|(Netherlands)\|(PAL)\|(pal)" <<< "$rom_bn" ; then

	game_name=$(echo $rom_bn | cut -d "(" -f1 | rev | cut -c 2- | rev)
	echo
	echo    "   Zak's MegaRefresh script v1.0"
	echo -e "   \e[41m$game_name\e[0m is a PAL game"
	echo -e "   Engaging \e[41m50 Hz\e[0m refresh frequency"
	vcgencmd hdmi_cvt $x_res $y_res 50 0 0 0 1 > /dev/null
	sleep $slen
	tvservice -e "DMT 87" > /dev/null
	sleep 0.2 && fbset -depth 8 && fbset -depth 16
	touch /opt/retropie/configs/all/megarefresh/megarefresh-engaged

# step 2 of 4
# ... otherwise parse systems.txt for system-specific settings (for all PAL-only systems, X68000, MS-DOS, etc)
elif grep -wq "$system" /opt/retropie/configs/all/megarefresh/systems.txt ; then

	refresh=$(grep -w $system /opt/retropie/configs/all/megarefresh/systems.txt | cut -d " " -f2 | tr -d "\r\n")
	echo
	echo    "   Zak's MegaRefresh script v1.0"
	echo -e "   System-specific settings found for \e[41m$system\e[0m"
	echo -e "   Engaging \e[41m$refresh Hz\e[0m refresh frequency"
	vcgencmd hdmi_cvt $x_res $y_res $refresh 0 0 0 1 > /dev/null
	sleep $slen
	tvservice -e "DMT 87" > /dev/null
	sleep 0.2 && fbset -depth 8 && fbset -depth 16
	touch /opt/retropie/configs/all/megarefresh/megarefresh-engaged

# step 3 of 4
# ... otherwise parse arcade refresh list and look for the the rom name (for arcade games)
# scummvm ROM names can clash with arcade ones (like "atlantis"), scummvm never needs nonstandard refreshes
# also skip this step if MegaRefresh detects a RetroPie port or standalone emulator that's being fed an empty romname variable by runcommand (crash on launch otherwise)
elif grep -wq "$rom_bn" /opt/retropie/configs/all/megarefresh/refreshlist.txt && [[ "$system" != "scummvm" ]] && [[ ! -z "$3" ]] ; then

	refresh=$(grep -w $rom_bn /opt/retropie/configs/all/megarefresh/refreshlist.txt | cut -d " " -f2 | tr -d "\r\n")
	echo
	echo    "   Zak's MegaRefresh script v1.0"
	echo -e "   Game-specific settings found for \e[41m$rom_bn\e[0m"
	echo -e "   Engaging \e[41m$refresh Hz\e[0m refresh frequency"
	vcgencmd hdmi_cvt $x_res $y_res $refresh 0 0 0 1 > /dev/null
	sleep $slen
	tvservice -e "DMT 87" > /dev/null
	sleep 0.2 && fbset -depth 8 && fbset -depth 16
	touch /opt/retropie/configs/all/megarefresh/megarefresh-engaged


# step 4 of 4
# ... otherwise do nothing (boots faster than setting the standard monitor mode even if it's not needed).

fi

