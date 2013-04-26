#!/system/bin/sh
#
# V6 SuperCharger, OOM Grouping & Priority Fixes created by -=zeppelinrox=-
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
# Entropy-ness Enlarger (sysctl tweak for kernel.random.read_wakeup_threshold that keeps entropy_avail full) discovered by zeppelinrox.
#
# See http://goo.gl/krtf9 - Linux Memory Consumption - Nice article!
# See http://goo.gl/hFdNO - Memory and SuperCharging Overview, or... "Why 'Free RAM' Is NOT Wasted RAM!"
# See http://goo.gl/4w0ba - MFK Calculator Info - explanation for vm.min_free_kbytes.
# See http://goo.gl/P8Bvu - How Entropy-ness Enlarger works.
# See http://goo.gl/Zc85j - Possible reasons why it may actually do something :p
#
  ################################
 #  SuperCharger Service Notes  #
################################
# To leave the SuperCharger Service running, insert a # at the beginning of the "stop super_service" entry near the bottom of this script (3rd or 4th last line).
#
# To stop the SuperCharger Service, run Terminal Emulator and type...
# "su" and Enter.
# "stop super_service" and Enter.
#
# To restart the SuperCharger Service so it stays running, type...
# "su" and Enter.
# "start super_service" and Enter.
#
# If the service is running and you type: "cat /proc/*/cmdline | grep Super".
# The output would be 2 items:
#     a. "/data/99SuperCharger.sh"
#     b. "Super" (created by your query so this doesn't mean anything)
#
# If it's not running, the output would be the last item ie. "Super" which was generated by the typed command.
#
# Similar results can be had with: "busybox ps | grep Super".
#
if [ "`pgrep -l android`" ]; then terminate=yes;
else
	if [ -f "/data/!!SuperChargerBootLoopMessage.log" ]; then
		exit 69;
	fi;
fi;
#
# echo ""; echo " See /data/Log_SuperCharger.log for the output!"; echo "";
# For debugging, delete the # at the beginning of the following 2 lines, and check /data/Log_SuperCharger.log file to see what may have fubarred.
# set -x;
# exec > /data/Log_SuperCharger.log 2>&1;
#
mount -o remount,rw /data 2>/dev/null;
busybox mount -o remount,rw /data 2>/dev/null;
line=================================================;
echo "";
echo $line;
echo "   The -=V6 SuperCharger=- by -=zeppelinrox=-";
echo $line;
echo "";
id=$(id); id=${id#*=}; id=${id%%[\( ]*}
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	echo " You are NOT running this script as root...";
	echo "";
	echo $line;
	echo "                      ...No SuperUser For You!!";
	echo $line;
	echo "";
	echo "     ...Please Run as Root and try again...";
	echo "";
	echo $line;
	echo "";
	exit 69;
fi;
echo " To verify application of settings...";
echo "";
echo "       ...check out /data/Ran_SuperCharger.log!";
echo "";
echo $line;
echo "";
mount -o remount,rw /system 2>/dev/null;
busybox mount -o remount,rw /system 2>/dev/null;
busybox mount -o remount,rw $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null;
if [ "`ls /system/etc/init.d/*oopy*`" ] && [ "/system/etc/init.d/*oopy*" != "/system/etc/init.d/zzloopy_runs_last_so_others_do_too" ]; then
	mv /system/etc/init.d/*oopy* /system/etc/init.d/zzloopy_runs_last_so_others_do_too
	sed -i '1 a## Hey you should try BulletProofing Apps from within V6 SuperCharger instead!#' /system/etc/init.d/zzloopy_runs_last_so_others_do_too
fi 2>/dev/null
if [ "$terminate" ]; then
	if [ ! "`pgrep scriptmanager`" ]; then
		echo " Waiting 2 minutes (avoid conflicts)... then...";echo "";
		echo " Gonna SuperCharge this Android... zoOM... zOOM!";
		echo "";
		echo $line;
		echo "";
		sleep 120;
	fi;
fi;
if [ "`cat /proc/sys/vm/min_free_kbytes`" -ne 15360 ] || [ "`cat /proc/sys/net/core/rmem_max`" -ne 1048576 ] || [ "`cat /sys/block/mmcblk0/bdi/read_ahead_kb`" -ne 2048 ]; then
	  ####################################
	 #  Kernel & Virtual Memory Tweaks  #
	####################################
	busybox sysctl -w vm.min_free_kbytes=15360;
	busybox sysctl -w vm.oom_kill_allocating_task=0;
	busybox sysctl -w vm.panic_on_oom=0;
	busybox sysctl -w vm.overcommit_memory=1;
	busybox sysctl -w vm.swappiness=20;
	busybox sysctl -w kernel.panic_on_oops=0;
	busybox sysctl -w kernel.panic=0;
	busybox sysctl -w kernel.random.read_wakeup_threshold=1376;  # Entropy-ness Enlarger - keeps entropy_avail full - MAY save battery and/or boost responsiveness
	  ##################################
	 #  3G TurboCharger Enhancement!  #
	#################=################
	busybox sysctl -w net.core.wmem_max=1048576;
	busybox sysctl -w net.core.rmem_max=1048576;
	busybox sysctl -w net.core.optmem_max=20480;
	busybox sysctl -w net.ipv4.tcp_moderate_rcvbuf=1;            # Be sure that autotuning is in effect
	busybox sysctl -w net.ipv4.route.flush=1;
	busybox sysctl -w net.ipv4.udp_rmem_min=6144;
	busybox sysctl -w net.ipv4.udp_wmem_min=6144;
	busybox sysctl -w net.ipv4.tcp_rmem='6144 87380 1048576';
	busybox sysctl -w net.ipv4.tcp_wmem='6144 87380 1048576';
	  #########################
	 #  SD Read Speed Tweak  #
	############==###########
	if [ "`ls /sys/devices/virtual/bdi/179*/read_ahead_kb`" ]; then
		for i in `ls /sys/devices/virtual/bdi/179*/read_ahead_kb`; do echo 2048 > $i; done;
	fi 2>/dev/null;
	echo 2048 > /sys/block/mmcblk0/bdi/read_ahead_kb 2>/dev/null;
	echo 2048 > /sys/block/mmcblk0/queue/read_ahead_kb 2>/dev/null;
	echo "";
	echo $line;
	echo "";
fi;
currentadj=`cat /sys/module/lowmemorykiller/parameters/adj` 2>/dev/null;
currentminfree=`cat /sys/module/lowmemorykiller/parameters/minfree` 2>/dev/null;
scadj=`cat /data/V6_SuperCharger/SuperChargerAdj`;
scminfree=`cat /data/V6_SuperCharger/SuperChargerMinfree`;
if [ "$scminfree" ] && [ "$currentminfree" != "$scminfree" ]; then applyscminfree=yes; fi;
if [ "$scadj" ] && [ "$currentadj" != "$scadj" ]; then applyscadj=yes; fi;
if [ "$applyscminfree" ] || [ "$applyscadj" ]; then
	  ###########################
	 #  Get 50% SuperCharged!  #
	###########################
	chmod 777 /sys/module/lowmemorykiller/parameters/adj 2>/dev/null;
	chmod 777 /sys/module/lowmemorykiller/parameters/minfree 2>/dev/null;
	if [ "$scadj" ]; then echo $scadj > /sys/module/lowmemorykiller/parameters/adj; fi 2>/dev/null;
	if [ "$scminfree" ]; then echo $scminfree > /sys/module/lowmemorykiller/parameters/minfree; fi 2>/dev/null;
	echo " $( date +"%m-%d-%Y %H:%M:%S" ): Applied settings from $0!" >> /data/Ran_SuperCharger.log;
	echo "         SuperCharger Settings Applied!";
elif [ "`pgrep -l android`" ]; then
	echo " $( date +"%m-%d-%Y %H:%M:%S" ): No need to reapply settings from $0!" >> /data/Ran_SuperCharger.log;
	echo " SuperCharger Settings Were ALREADY Applied...";
	echo "";
	echo "            ...there's no need to reapply them!";
fi;
echo "";
echo " $0 Executed...";
echo "";
echo "          ===========================";
echo "           ) SuperCharge Complete! (";
echo "          ===========================";
echo "";
if [ "$terminate" ]; then
	mount -o remount,ro /system 2>/dev/null;
	busybox mount -o remount,ro /system 2>/dev/null;
	busybox mount -o remount,ro $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null;
	stop super_service;
else
	$0 & exit 0;
fi;
sleep 90;
sed -i 's/# exec >/exec >/' /data/V6_SuperCharger/!FastEngineFlush.sh 2>/dev/null;
/data/V6_SuperCharger/!FastEngineFlush.sh & sleep 2;
sed -i 's/exec >/# exec >/' /data/V6_SuperCharger/!FastEngineFlush.sh 2>/dev/null;
exit 0;
# End of V6 SuperCharged Entries.
