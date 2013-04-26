#!/system/bin/sh
#
# PowerShift Script for use with The V6 SuperCharger created by zeppelinrox.
# SuperMinFree Calculator & MFK Calculator (for min_free_kbytes) created by zeppelinrox also ;^]
#
# See http://goo.gl/krtf9 - Linux Memory Consumption - Nice article!
# See http://goo.gl/hFdNO - Memory and SuperCharging Overview ...or... "Why 'Free RAM' Is NOT Wasted RAM!"
# See http://goo.gl/4w0ba - MFK Calculator Info - explanation for vm.min_free_kbytes.
#
line=================================================
clear
cd "${0%/*}" 2>/dev/null
echo ""
echo $line
echo "   The -=V6 SuperCharger=- by -=zeppelinrox=-"
echo $line
echo ""
sleep 1
id=`id`; id=`echo ${id#*=}`; id=`echo ${id%%\(*}`; id=`echo ${id%% *}`
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	sleep 2
	echo " You are NOT running this script as root..."
	echo ""
	sleep 3
	echo $line
	echo "                      ...No SuperUser for you!!"
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
busybox mount -o remount,rw /data 2>/dev/null
busybox mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw `busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p` 2>/dev/null
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
echo "         ...8, 16, 194, 214, 233, 253 MB"
echo $line
echo ""
sleep 1
echo 2048,4096,49664,54784,59648,64768 > /sys/module/lowmemorykiller/parameters/minfree
echo 2048,4096,49664,54784,59648,64768 > /data/V6_SuperCharger/SuperChargerMinfree
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
echo -n "         ...";busybox sysctl -w vm.min_free_kbytes=39731
echo ""
sleep 1
echo $line
echo " Updating MFK in *99SuperCharger Boot Scripts..."
echo $line
echo ""
sleep 1
sed -i 's/vm.min_free_kbytes=.*/vm.min_free_kbytes=39731;/' /system/etc/init.d/*SuperCharger* 2>/dev/null
sed -i 's/free_kbytes`" -ne .* ] /free_kbytes`" -ne 39731 ] /' /system/etc/init.d/*SuperCharger* 2>/dev/null
sed -i 's/vm.min_free_kbytes=.*/vm.min_free_kbytes=39731;/' /data/99SuperCharger.sh 2>/dev/null
sed -i 's/free_kbytes`" -ne .* ] /free_kbytes`" -ne 39731 ] /' /data/99SuperCharger.sh 2>/dev/null
echo "          ==========================="
echo "           ) PowerShift Completed! ("
echo "          ==========================="
echo ""
busybox mount -o remount,ro /system 2>/dev/null
busybox mount -o remount,ro `busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p` 2>/dev/null
exit 0
