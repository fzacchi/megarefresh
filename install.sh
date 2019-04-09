#!/bin/bash
################################################################
##
## Zak's MegaRefresh Installer
## Version 0.8 - added support for offline installation method
##
################################################################

mkdir -p /opt/retropie/configs/all/megarefresh/
# set the correct permissions in case the files were manually copied with something that set them as owned by and belonging to root
sudo chown -R pi:pi /opt/retropie/configs/all/megarefresh/
cd /opt/retropie/configs/all/megarefresh/

if [ ! -f master.zip ] ; then 
	wget https://github.com/fzacchi/megarefresh/archive/master.zip
fi

unzip -oj master.zip
rm master.zip

chmod +x megarefresh-onstart.sh
chmod +x megarefresh-onend.sh

mkdir -p "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"
mv "Toggle MegaRefresh ON-OFF.sh" "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"
mv "Update MegaRefresh Script.sh" "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"
mv "Edit Arcade Refresh List.sh" "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"
mv "Edit Systems List.sh" "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"
mv "Edit Skip List.sh" "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"
mv "Show Instructions.sh" "/home/pi/RetroPie/retropiemenu/Zak's MegaRefresh/"

if [ ! -f /opt/retropie/configs/all/runcommand-onstart.sh ] || grep -Fq "mr_safetycheck" /opt/retropie/configs/all/runcommand-onstart.sh ; then
	cp runcommand-onstart.sh /opt/retropie/configs/all/
else
	echo
	echo "*** WARNING ***"
	echo "Pre-existing runcommand-start.sh found: MegaRefresh installer will not overwrite it, but MegaRefresh won't work."
	echo "You'll need to cut and paste the MegaRefresh launch commands manually into your runcommand-onstart.sh"
	echo "See README.md for more information"
fi

if [ ! -f /opt/retropie/configs/all/runcommand-onend.sh ] || grep -Fq "mr_safetycheck" /opt/retropie/configs/all/runcommand-onend.sh ; then
	cp runcommand-onend.sh /opt/retropie/configs/all/
else 
	echo
	echo "*** WARNING ***"
	echo "Pre-existing runcommand-onend.sh found: MegaRefresh installer will not overwrite it, but MegaRefresh won't work."
	echo "You'll need to cut and paste the MegaRefresh launch commands manually into your runcommand-onend.sh"
	echo "See README.md for more information"
fi

echo
echo "Zak's MegaRefresh Script v1.0 installed/updated successfully."

sleep 5
