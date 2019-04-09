#!/bin/bash

clear

echo
echo "   Zak's MegaRefresh Script toggle utility"

if [ -f /opt/retropie/configs/all/megarefresh/megarefresh-enabled ] ; then 

	echo "   Current script status: Enabled. Disabling ..."
	rm /opt/retropie/configs/all/megarefresh/megarefresh-enabled
	sleep 2
	echo -e "   MegaRefresh is now \e[41mOFF\e[0m, relaunch toggle utility to enable"
	sleep 4

else	

	echo "   Current script status: Disabled. Enabling ..."
	touch /opt/retropie/configs/all/megarefresh/megarefresh-enabled
	sleep 2
	echo -e "   MegaRefresh is now \e[41mON\e[0m, relaunch toggle utility to disable"
	sleep 4

fi

