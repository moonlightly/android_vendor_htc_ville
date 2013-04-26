#!/system/bin/sh
#
# Fix Emissions Script (Fix Permissions) created by -=zeppelinrox=-
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
# Sets permissions for android data directories and apks.
# This should fix app force closes (FCs).
# It's quite fast - setting permissions for 300 apps in approximately 1 minute.
#
# Props: Originally and MOSTLY (erm... something like 90% of it lol) by Jared Rummler (JRummy16).
# However, I actually meshed together 3 different Fix Permissions scripts ;^]
#
# Tweaks & Enhancements by zeppelinrox...
#      - Removed the usage of the "pm list packages" command - it didn't work on boot.
#      - Added support for /vendor/app (POST-ICS)
#      - No longer excludes framework-res.apk or com.htc.resources.apk
#      - Added support for more data directories ie. dbdata, datadata, etc.
#      - Added debugging
#      - Tweaked interface a bit ;^]
#
clear
#
# For debugging, delete the # at the beginning of the following 2 lines, and check /data/Log_FixEmissions.log file to see what may have fubarred.
# set -x
# exec > /data/Log_FixEmissions.log 2>&1
#
mount -o remount,rw /data 2>/dev/null
busybox mount -o remount,rw /data 2>/dev/null
line=================================================
cd "${0%/*}" 2>/dev/null
echo ""
echo $line
echo "   -=Fix Emissions=- script by -=zeppelinrox=-"
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
fi
mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw /system 2>/dev/null
busybox mount -o remount,rw $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null
LOG_FILE=/data/Ran_FixEmissions.log
START=`busybox date +%s`
BEGAN=`date`
TOTAL=`cat /d*/system/packages.xml | grep -c "^<package.*serId"`
INCREMENT=3
PROGRESS=0
PROGRESS_BAR=""
echo " Start Fix Emissions: $BEGAN" > $LOG_FILE
echo "" >> $LOG_FILE
echo " Setting & Fixing Permissions For..." >> $LOG_FILE
echo "" >> $LOG_FILE
sync
grep "^<package.*serId" /d*/system/packages.xml | while read pkgline; do
	PKGNAME=`echo $pkgline | sed 's%.* name="\(.*\)".*%\1%' | cut -d '"' -f1`
	CODEPATH=`echo $pkgline | sed 's%.* codePath="\(.*\)".*%\1%' |  cut -d '"' -f1`
	DATAPATH=/d*/d*/$PKGNAME
	PKGUID=`echo $pkgline | sed 's%.*serId="\(.*\)".*%\1%' | cut -d '"' -f1`
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
	echo "       \"Fix Emissions\" by -=zeppelinrox=-"
	echo -n "                                        >"
	echo -e "\r       $PROGRESS_BAR>"
	echo ""
	echo "       Processing Apps - $PERCENT% ($PROGRESS of $TOTAL)"
	echo ""
	echo " Setting & Fixing Permissions For..."
	echo ""
	echo " ...$PKGNAME"
	echo " $PKGNAME ($CODEPATH)" >> $LOG_FILE
	if [ -e "$CODEPATH" ]; then
		APPDIR=`busybox dirname $CODEPATH`
		if [ "$APPDIR" = "/system/app" ] || [ "$APPDIR" = "/vendor/app" ]; then
			busybox chown 0 $CODEPATH
			busybox chown :0 $CODEPATH
			busybox chmod 644 $CODEPATH
		elif [ "$APPDIR" = "/data/app" ]; then
			busybox chown 1000 $CODEPATH
			busybox chown :1000 $CODEPATH
			busybox chmod 644 $CODEPATH
		elif [ "$APPDIR" = "/data/app-private" ]; then
			busybox chown 1000 $CODEPATH
			busybox chown :$PKGUID $CODEPATH
			busybox chmod 640 $CODEPATH
		fi
		if [ -d "$DATAPATH" ]; then
			busybox chmod 755 $DATAPATH
			busybox chown $PKGUID $DATAPATH
			busybox chown :$PKGUID $DATAPATH
			DIRS=`busybox find $DATAPATH -mindepth 1 -type d`
			for file in $DIRS; do
				PERM=755
				NEWUID=$PKGUID
				NEWGID=$PKGUID
				FNAME=`busybox basename $file`
				case $FNAME in
							lib)busybox chmod 755 $file
								NEWUID=1000
								NEWGID=1000
								PERM=755;;
				   shared_prefs)busybox chmod 771 $file
								PERM=660;;
					  databases)busybox chmod 771 $file
								PERM=660;;
						  cache)busybox chmod 771 $file
								PERM=600;;
						  files)busybox chmod 771 $file
								PERM=775;;
							  *)busybox chmod 771 $file
								PERM=771;;
				esac
				busybox chown $NEWUID $file
				busybox chown :$NEWGID $file
				busybox find $file -type f -maxdepth 2 ! -perm $PERM -exec busybox chmod $PERM {} ';'
				busybox find $file -type f -maxdepth 1 ! -user $NEWUID -exec busybox chown $NEWUID {} ';'
				busybox find $file -type f -maxdepth 1 ! -group $NEWGID -exec busybox chown :$NEWGID {} ';'
			done
		fi
	fi 2>/dev/null
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
echo " FIXED Permissions For ALL $TOTAL Apps..." | tee -a $LOG_FILE
echo ""| tee -a $LOG_FILE
sleep 1
echo "          ...Say Buh Bye To Force Close Errors!"
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
echo "         =============================="
echo "          ) Fix Emissions Completed! ("
echo "         =============================="
echo ""
sleep 1
exit 0
