#!/system/bin/sh
#
# "ZepAlign" / Wheel Alignment Script (ZipAlign) created by -=zeppelinrox=-
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
# ZipAligns all data and system apks (apps) that have not yet been ZipAligned.
# ZipAlign optimizes all your apps, resulting in less RAM comsumption and a faster device! ;^]
#
# Props: Automatic ZipAlign by Wes Garner (original script)
#        oknowton for the change from MD5 to zipalign -c 4
#
# Tweaks & Enhancements by zeppelinrox...
#      - Added support for /vendor/app (POST-ICS)
#      - Added support for /mnt/asec
#      - Added support for more data directories ie. dbdata, datadata, etc.
#      - Added debugging
#      - Tweaked interface a bit ;^]
#
clear
#
# For debugging, delete the # at the beginning of the following 2 lines, and check /data/Log_ZepAlign.log file to see what may have fubarred.
# set -x
# exec > /data/Log_ZepAlign.log 2>&1
#
mount -o remount,rw /data 2>/dev/null
busybox mount -o remount,rw /data 2>/dev/null
line=================================================
cd "${0%/*}" 2>/dev/null
echo ""
echo $line
echo "  -=Wheel Alignment=- script by -=zeppelinrox=-"
echo $line
echo ""
sleep 2
id=$(id); id=${id#*=}; id=${id%%[\( ]*}
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	sleep 1
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
elif [ ! "`which zipalign`" ]; then
	sleep 1
	echo " Doh... zipalign binary was NOT found..."
	echo ""
	sleep 3
	echo $line
	echo "                    ...No ZepAligning For You!!"
	echo $line
	echo ""
	sleep 3
	echo " Load the XDA SuperCharger thread..."
	echo ""
	sleep 3
	echo "   ...and install The SuperCharger Starter Kit!"
	echo ""
	echo $line
	echo ""
	sleep 3
	su -c "LD_LIBRARY_PATH=/vendor/lib:/system/lib am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity -d file:///storage/emulated/legacy/!SuperCharger.html"
	echo ""
	echo $line
	echo ""
	sleep 3
	exit 69
fi
mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null
LOG_FILE=/data/Ran_ZepAlign.log
START=`busybox date +%s`
BEGAN=`date`
TOTAL=$((`ls /d*/*/*.apk | wc -l`+`ls /system/*/*.apk | wc -l`+`ls /vendor/*/*.apk | wc -l`+`ls /mnt/asec/*/*.apk | wc -l`)) 2>/dev/null
INCREMENT=3
PROGRESS=0
PROGRESS_BAR=""
ALIGNED=0; ALREADY=0; FAILED=0; SKIPPED=0
echo " Start Wheel Alignment ( \"ZepAlign\" ): $BEGAN" > $LOG_FILE
echo "" >> $LOG_FILE
sync
for apk in /d*/*/*.apk /system/*/*.apk /vendor/*/*.apk /mnt/asec/*/*.apk; do
	PROGRESS=$(($PROGRESS+1))
	PERCENT=$(( $PROGRESS * 100 / $TOTAL ))
	if [ "$PERCENT" -eq "$INCREMENT" ]; then
		INCREMENT=$(( $INCREMENT + 3 ))
		PROGRESS_BAR="$PROGRESS_BAR="
	fi
	clear
	echo ""
	echo -n "                                        >"
	echo -e "\r       $PROGRESS_BAR>"
	echo "       Wheel Alignment by -=zeppelinrox=-"
	echo -n "                                        >"
	echo -e "\r       $PROGRESS_BAR>"
	echo ""
	echo "       Processing APKs - $PERCENT% ($PROGRESS of $TOTAL)"
	echo ""
	if [ -f "$apk" ]; then
		if [ "$(busybox basename $apk )" = "framework-res.apk" ] || [ "$(busybox basename $apk )" = "SystemUI.apk" ] || [ "$(busybox basename $apk )" = "com.htc.resources.apk" ]; then
			echo " NOT ZipAligning (Problematic) $apk..." | tee -a $LOG_FILE
			SKIPPED=$(($SKIPPED+1))
			skippedapp="$skippedapp$(busybox basename $apk ),"
		else
			zipalign -c 4 $apk
			ZIPCHECK=$?
			if [ "$ZIPCHECK" -eq 1 ]; then
				echo " ZipAligning $apk..." | tee -a $LOG_FILE
				zipalign -f 4 $apk /cache/$(busybox basename $apk)
				rc="$?"
				if [ "$rc" -eq 0 ]; then
					if [ -e "/cache/$(busybox basename $apk)" ]; then
						busybox cp -f -p /cache/$(busybox basename $apk) $apk | tee -a $LOG_FILE
						ALIGNED=$(($ALIGNED+1))
					else
						echo " ZipAligning $apk... Failed (No Output File!)" | tee -a $LOG_FILE
						FAILED=$(($FAILED+1))
						failedapp="$failedapp$(busybox basename $apk ),"
					fi
				else echo "ZipAligning $apk... Failed (rc: $rc!)" | tee -a $LOG_FILE
					FAILED=$(($FAILED+1))
					failedapp="$failedapp$(busybox basename $apk ),"
				fi
				if [ -e "/cache/$(busybox basename $apk)" ]; then busybox rm /cache/$(busybox basename $apk); fi
			else
				echo " ZipAlign already completed on $apk" | tee -a $LOG_FILE
				ALREADY=$(($ALREADY+1))
			fi
		fi
	fi
done
sync
mount -o remount,ro /system 2>/dev/null
busybox mount -o remount,ro /system 2>/dev/null
busybox mount -o remount,ro $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null
STOP=`busybox date +%s`
ENDED=`date`
RUNTIME=`busybox expr $STOP - $START`
HOURS=`busybox expr $RUNTIME / 3600`
REMAINDER=`busybox expr $RUNTIME % 3600`
MINS=`busybox expr $REMAINDER / 60`
SECS=`busybox expr $REMAINDER % 60`
RUNTIME=`busybox printf "%02d:%02d:%02d\n" "$HOURS" "$MINS" "$SECS"`
echo ""
echo $line
echo "" | tee -a $LOG_FILE
sleep 1
echo " Done \"ZepAligning\" ALL data and system APKs..." | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
sleep 1
echo " $ALIGNED   Apps were zipaligned..." | tee -a $LOG_FILE
echo " $ALREADY Apps were already zipaligned..." | tee -a $LOG_FILE
echo " $FAILED   Apps were NOT zipaligned due to error..." | tee -a $LOG_FILE
if [ "$failedapp" ]; then echo "     ($failedapp)" | tee -a $LOG_FILE; fi
echo " $SKIPPED   (Problematic) Apps were skipped..." | tee -a $LOG_FILE
echo "     ($skippedapp)" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
echo " $TOTAL Apps were processed!" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
sleep 1
echo "                ...Say Hello To Optimized Apps!"
echo ""
echo $line
echo ""
sleep 1
echo "      Start Time: $BEGAN" | tee -a $LOG_FILE
echo "       Stop Time: $ENDED" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
echo " Completion Time: $RUNTIME" | tee -a $LOG_FILE
echo ""
sleep 1
echo " See $LOG_FILE for more details!"
echo ""
sleep 1
echo "        ================================"
echo "         ) Wheel Alignment Completed! ("
echo "        ================================"
echo ""
sleep 1
exit 0
