#!/system/bin/sh
#
# PowerShift Script for use with The V6 SuperCharger created by -=zeppelinrox=-
#
# V6U9RC12T6
#
# When using scripting tricks, ideas, or code snippets from here, please give proper credit.
# There are many things may look simple, but actually took a lot of time, trial, and error to get perfected.
#
# This script can be used freely and can even be modified for PERSONAL USE ONLY.
# It can be freely incorporated into ROMs - provided that proper credit is given WITH a link back to the XDA SuperCharger thread.
# If you want to share it or make a thread about it, just provide a link to the main thread.
#      - This ensures that users will always be getting the latest versions.
# Prohibited: Any modification (excluding personal use), repackaging, redistribution, or mirrors of my work are NOT PERMITTED.
# Thanks, zeppelinrox.
#
# SuperMinFree Calculator & MFK Calculator (for min_free_kbytes) created by zeppelinrox also ;^]
#
# See http://goo.gl/krtf9 - Linux Memory Consumption - Nice article!
# See http://goo.gl/hFdNO - Memory and SuperCharging Overview, or... "Why 'Free RAM' Is NOT Wasted RAM!"
# See http://goo.gl/4w0ba - MFK Calculator Info - explanation for vm.min_free_kbytes.
#
mount -o remount,rw /data 2>/dev/null
busybox mount -o remount,rw /data 2>/dev/null
clear
line=================================================
cd "${0%/*}" 2>/dev/null
echo ""
echo $line
echo "    -=PowerShift=- script by -=zeppelinrox=-"
echo $line
echo ""
sleep 1
id=$(id); id=${id#*=}; id=${id%%[\( ]*}
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	sleep 2
	echo " You are NOT running this script as root..."
	echo ""
	sleep 3
	echo $line
	echo "                      ...No SuperUser For You!!"
	echo $line
	echo ""
	sleep 3
	echo "     ...Please Run as Root and try again..."
	echo ""
	echo $line
	echo ""
	sleep 3
	exit 69
fi
mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null
echo " PowerShifting to a different gear!"
echo ""
sleep 1
echo $line
awk -F , '{printf "   Current Minfrees = %.0f,%.0f,%.0f,%.0f,%.0f,%.0f MB\n", $1/256, $2/256, $3/256, $4/256, $5/256, $6/256}' /sys/module/lowmemorykiller/parameters/minfree
echo $line
echo ""
sleep 1
echo " Setting LowMemoryKiller to..."
echo ""
sleep 1
echo $line
echo "         ...8, 14, 75, 90, 95, 125 MB"
echo $line
echo ""
sleep 1
echo 2048,3584,19200,23040,24320,32000 > /sys/module/lowmemorykiller/parameters/minfree
echo 2048,3584,19200,23040,24320,32000 > /data/V6_SuperCharger/SuperChargerMinfree
echo " OOM Minfree levels are now set to..."
echo ""
sleep 1
echo "         ...`cat /sys/module/lowmemorykiller/parameters/minfree`"
echo ""
sleep 1
echo "  They are also your new SuperCharger values!"
echo ""
echo $line
echo ""
sleep 1
echo " Updating Kernel & Virtual Memory Tweaks..."
echo ""
sleep 1
echo -n "         ...";busybox sysctl -w vm.min_free_kbytes=15360
echo ""
sleep 1
echo $line
echo " Updating MFK in *99SuperCharger Boot Scripts..."
echo $line
echo ""
sleep 1
sed -i 's/vm.min_free_kbytes=.*/vm.min_free_kbytes=15360;/' /system/etc/init.d/*SuperCharger* 2>/dev/null
sed -i 's/free_kbytes`" -ne .* ] /free_kbytes`" -ne 15360 ] /' /system/etc/init.d/*SuperCharger* 2>/dev/null
sed -i 's/vm.min_free_kbytes=.*/vm.min_free_kbytes=15360;/' /data/99SuperCharger.sh 2>/dev/null
sed -i 's/free_kbytes`" -ne .* ] /free_kbytes`" -ne 15360 ] /' /data/99SuperCharger.sh 2>/dev/null
mount -o remount,ro /system 2>/dev/null
busybox mount -o remount,ro /system 2>/dev/null
busybox mount -o remount,ro $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null
echo "          ==========================="
echo "           ) PowerShift Completed! ("
echo "          ==========================="
echo ""
sleep 1
exit 0
