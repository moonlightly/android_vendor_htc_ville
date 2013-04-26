#!/system/bin/sh
#
# 2 in 1 Engine Flush Script created by -=zeppelinrox=-
# The 2 Modes are: -=Fast Engine Flush=- and -=Engine Flush-O-Matic=-
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
# See http://goo.gl/krtf9 - Linux Memory Consumption - Nice article which also discusses the "drop system cache" function!
# See http://goo.gl/hFdNO - Memory and SuperCharging Overview, or... "Why 'Free RAM' Is NOT Wasted RAM!"
#
# Credit imoseyon for making the drop caches command more well known :)
# See http://www.droidforums.net/forum/liberty-rom-d2/122733-tutorial-sysctl-you-guide-better-preformance-battery-life.html
# Credit dorimanx (Cool XDA dev!) for the neat idea to show before and after stats :D
#
# Note: To enable "Engine Flush-O-Matic" mode, change the "flushOmaticHours" variable to the number of hours you want.
#       Valid values are from 1 to 24 (hours).
#       If 0, or if the value is invalid or missing, "Engine Flush-O-Matic" mode is disabled.
#       Example: If you want it to run every 4 hours, make the line read "flushOmaticHours=4".
#
# Usage: 1. Type in Terminal: "su" and enter, "flush" and enter. ("flush" is indentical to !FastEngineFlush.sh but easier to type :p)
#        2. Script Manager: launch it once like any other script OR with a widget (DO NOT PUT IT ON A SCHEDULE!)
#
# Important! Whether you run this with Terminal or Script Manager or widget, the script relaunches and kills itself after the first run.
#            So let it run ONCE, close the app, and "Engine Flush-O-Matic" continues in the background!
#
# To verify that it's running, just run the script again!
# OR you can type in Terminal:
# 1. "pstree | grep -i flus" - for usage option 1 (with Terminal)
# 2. "pstree | grep sleep" - for usage option 2 (with Script Manager)
# 3. "cat /proc/*/cmdline | grep -i flush" - Sure-Fire method ;^]
#     The output should be 3 items:
#         a. "/data/V6_SuperCharger/!FastEngineFlush.sh" OR "/system/xbin/flush" (depending on which script you ran)
#         b. "Engine_Flush-O-Matic_is_In_Effect!" (sleep message)
#         c. "flush" (created by your query so this doesn't mean anything)
# 4. "busybox ps | grep -i flus" would give similar results as 3.
#
# For debugging, delete the # at the beginning of the following 2 lines, and check /data/Log_FastEngineFlush.log file to see what may have fubarred.
# set -x
# exec > /data/Log_FastEngineFlush.log 2>&1
#
mount -o remount,rw /data 2>/dev/null
busybox mount -o remount,rw /data 2>/dev/null
line=================================================
cd "${0%/*}" 2>/dev/null
# To set the next line manually, see comments at the top for instuctions!
flushOmaticHours=2
if [ ! "$flushOmaticHours" ] || [ "`echo $flushOmaticHours | grep "[^0-9]"`" ] || [ "$flushOmaticHours" -gt 24 ]; then flushOmaticHours=0; fi
intervalsecs="sleep $(($flushOmaticHours*60*60))"
animspeed="busybox sleep 0.125"
FOMactive=; changeoptions=
if [ "`busybox ps -w`" ]; then w=" -w"; fi 2>/dev/null
if [ -f "/data/FOMtemp" ]; then
	rm /data/FOMtemp
	$intervalsecs | grep "Engine_Flush-O-Matic_is_In_Effect!"
fi
clear
echo ""
echo $line
echo " $( date +"%m-%d-%Y %H:%M:%S" ): Flushing Engine with $0!" | tee /data/Ran_EngineFlush-O-Matic.log
echo $line
echo ""
sleep 2
if [ "$flushOmaticHours" -ne 0 ]; then
	flushmode="   -=Engine Flush-O-Matic=- by -=zeppelinrox=-"
	echo " Engine Flush-O-Matic is enabled!" >> /data/Ran_EngineFlush-O-Matic.log
	echo " So this should update every $flushOmaticHours hours!" >> /data/Ran_EngineFlush-O-Matic.log
else flushmode="    -=Fast Engine Flush=- by -=zeppelinrox=-"
fi
if [ "`busybox ps$w | grep "{.*}.*${0##*/}" | grep -v bin`" ]; then
	clear;sleep 1;echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "              |   |";echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "              |   D";echo "              |   |";echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";$animspeed
	clear;echo "";echo $line;echo "               ___";echo "              |   D";echo "              |   |";echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;$animspeed;$animspeed
	clear;echo "";echo $line;echo "              |   D";echo "              |   |";echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";$animspeed
	clear;echo "";echo $line;echo "              |   |";echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "              |   |";echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "              |___|            __";echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                || ________  -( (-";echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                |_(--------)  '-'";echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                   \      /";echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "                    )_.._(";echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "                                         zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "                               zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "                     zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo "           zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo " zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo " zoom...                                zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo " zoom...                     zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo " zoom...           zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";$animspeed
	clear;echo " zoom... zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";busybox sleep 0.5
	clear;echo " zOOM... zOOM...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";busybox sleep 0.5
	clear;echo " zoom... zoom...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";busybox sleep 0.5
	clear;echo " zOOM... zOOM...";echo $line;echo "$flushmode";echo $line;echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";echo "";busybox sleep 1
	clear;echo " zOOM... zOOM...";echo $line;echo "$flushmode";echo $line;echo "";busybox sleep 1
fi
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
elif [ "`busybox ps | grep Engine_ | grep Matic_`" ]; then
	echo " -=Engine Flush-O-Matic=- is already in memory!"
	echo ""
	sleep 1
	echo " Do you want to flush now anyway?"
	echo ""
	sleep 1
	echo " If you do, you can access Options too..."
	echo ""
	sleep 1
	echo "  ...but you can't enter another \"Flush Cycle\"."
	echo ""
	sleep 1
	echo -n " Enter Y for Yes, any key for No: "
	stty -icanon min 0 time 200
	read FOMactive
	stty sane
	if [ ! "$FOMactive" ]; then echo ""; fi
	echo ""
	echo $line
	case $FOMactive in
	  y|Y)echo " Alrighty Then!"
		  echo $line
		  echo ""
		  sleep 1;;
		*)echo " No Options For You!"
		  echo $line
		  echo ""
		  exit 69;;
	esac
fi
ram=$((`free | awk '{ print $2 }' | sed -n 2p`/1024))
ramused=$((`free | awk '{ print $3 }' | sed -n 2p`/1024))
ramkbytesfree=`free | awk '{ print $4 }' | sed -n 2p`
ramkbytescached=`cat /proc/meminfo | grep Cached | awk '{print $2}' | sed -n 1p`
ramfree=$(($ramkbytesfree/1024));ramcached=$(($ramkbytescached/1024));ramreportedfree=$(($ramfree + $ramcached))
echo "  Note that \"Used RAM\" INCLUDES Cached Apps!!"
echo ""
sleep 1
echo $line
echo " RAM Stats BEFORE Engine Flush..."
echo $line
echo ""
sleep 1
echo " Total: $ram MB  Used: $ramused MB  True Free: $ramfree MB"
echo ""
sleep 1
echo " Reported Free by most tools: $ramreportedfree MB Free RAM!"
echo ""
sleep 1
echo $line
echo " True Free $ramfree MB = \"Free\" $ramreportedfree - Cached Apps $ramcached"
echo $line
echo ""
sleep 1
echo " ...OR...    True Free RAM   $ramfree"
echo "               Cached Apps + $ramcached"
echo "                           ========"
echo "       Reported \"Free\" RAM = $ramreportedfree MB"
echo ""
sleep 1
busybox sync;
echo $line
echo -n " Engine Flush In Progress... ";busybox sysctl -w vm.drop_caches=3
echo $line
echo ""
sleep 3
busybox sysctl -w vm.drop_caches=1 1>/dev/null
ramused=$((`free | awk '{ print $3 }' | sed -n 2p`/1024))
ramkbytesfree=`free | awk '{ print $4 }' | sed -n 2p`
ramkbytescached=`cat /proc/meminfo | grep Cached | awk '{print $2}' | sed -n 1p`
ramfree=$(($ramkbytesfree/1024));ramcached=$(($ramkbytescached/1024));ramreportedfree=$(($ramfree + $ramcached))
echo $line
echo "                ...RAM Stats AFTER Engine Flush"
echo $line
echo ""
sleep 1
echo " Total: $ram MB  Used: $ramused MB  True Free: $ramfree MB"
echo ""
sleep 1
echo " Reported Free by most tools: $ramreportedfree MB Free RAM!"
echo ""
sleep 1
echo $line
echo " True Free $ramfree MB = \"Free\" $ramreportedfree - Cached Apps $ramcached"
echo $line
echo ""
sleep 1
echo " ...OR...    True Free RAM   $ramfree"
echo "               Cached Apps + $ramcached"
echo "                           ========"
echo "       Reported \"Free\" RAM = $ramreportedfree MB"
echo ""
sleep 1
echo $line
echo "                  ...Enjoy Your Quick Boost ;^]"
echo $line
echo ""
sleep 1
if [ "$flushOmaticHours" -ne 0 ]; then
	echo "      ====================================="
	echo "       ) Engine Flush-O-Matic Completed! ("
	echo "      ====================================="
else
	echo "       =================================="
	echo "        ) Fast Engine Flush Completed! ("
	echo "       =================================="
fi
echo ""
sleep 1
echo " If desired, you can change options for..."
echo ""
sleep 1
echo $line
echo "            -=Engine Flush-O-Matic=-"
echo $line
echo ""
sleep 1
echo " Current Status..."
echo ""
sleep 1
if [ "$flushOmaticHours" -ne 0 ]; then
	echo " Engine Flush-O-Matic is ON @ $flushOmaticHours hour intervals!"
	echo " =============================================="
else
	echo " Engine Flush-O-Matic is currently OFF!"
	echo " ======================================"
fi
echo ""
sleep 1
echo " You can turn it on or off..."
echo ""
sleep 1
echo "        ...or just change how often it runs ;^]"
echo ""
sleep 1
if [ "`ls /system/etc/init.d/*SuperCharger*`" ]; then
	echo " Note that when it's enabled..."
	echo ""
	sleep 1
	echo $line
	echo " -=Engine Flush-O-Matic=- on boot is AUTOMATIC!"
	echo $line
	echo ""
	sleep 1
	echo " Since it is loaded via *99SuperCharger... heh."
	echo ""
	sleep 1
fi 2>/dev/null
echo " Change Options? You have 20 seconds to decide!"
echo ""
sleep 1
echo -n " Enter Y for Yes, any key for No: "
stty -icanon min 0 time 200
read changeoptions
stty sane
if [ ! "$changeoptions" ]; then echo ""; fi
echo ""
echo $line
case $changeoptions in
  y|Y)changedopt=yes
	  mount -o remount,rw /system 2>/dev/null
	  busybox mount -o remount,rw /system 2>/dev/null
	  busybox mount -o remount,rw $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null
	  echo "        -=Engine Flush-O-Matic=- Options"
	  while :; do
		echo $line
		echo ""
		sleep 1
		echo -n " Enter E to Enable, D to Disable: "
		read able
		echo ""
		echo $line
		case $able in
			e|E)echo "       -=Engine Flush-O-Matic=- ENABLED!!"
				echo $line
				echo ""
				sleep 1
				if [ ! "`ls /system/etc/init.d/*SuperCharger*`" ]; then
					echo $line
					echo " An Option from 2 - 13 still needs to be run!"
					echo $line
					echo ""
					sleep 1
				fi 2>/dev/null
				echo " How often do you want it to flush?"
				while :; do
					echo ""
					sleep 1
					echo -n " Enter a value from 1 to 24 (hours): "
					read flushOmaticHours
					echo ""
					echo $line
					case $flushOmaticHours in
					  [1-9]|1[0-9]|2[0-4])echo " Engine Flush-O-Matic Set To Run Every $flushOmaticHours Hours!"
										  break 2;;
										*)echo "      Invalid entry... Please try again :p"
										  echo $line;;
					esac
				done;;
			d|D)flushOmaticHours=0
				echo "       -=Engine Flush-O-Matic=- DISABLED!!"
				break;;
			  *)echo "      Invalid entry... Please try again :p";;
		esac
	  done
	  sed -i 's/^flushOmaticHours=.*/flushOmaticHours='$flushOmaticHours'/' $0
	  if [ "$0" != "/data/V6_SuperCharger/!FastEngineFlush.sh" ]; then sed -i 's/^flushOmaticHours=.*/flushOmaticHours='$flushOmaticHours'/' /data/V6_SuperCharger/!FastEngineFlush.sh; fi 2>/dev/null
	  if [ "$0" != "/system/xbin/flush" ]; then sed -i 's/^flushOmaticHours=.*/flushOmaticHours='$flushOmaticHours'/' /system/xbin/flush; fi 2>/dev/null
	  mount -o remount,ro /system 2>/dev/null
	  busybox mount -o remount,ro /system 2>/dev/null
	  busybox mount -o remount,ro $(busybox mount | grep system | awk '{print $1,$3}' | sed -n 1p) 2>/dev/null;;
	*)echo "               No Change For You!";;
esac
echo $line
echo ""
sleep 1
if [ "$flushOmaticHours" -eq 0 ]; then exit 0
elif [ "$FOMactive" ] || [ "`busybox ps | grep Engine_ | grep Matic_`" ]; then
	echo $line
	echo " -=Engine Flush-O-Matic=- is already in memory!"
	echo $line
	echo ""
	exit 69
elif [ "$changedopt" ]; then
	echo ""
	echo " You can change options by..."
	echo ""
	sleep 1
	echo "               ...running this script again :o)"
	echo ""
	echo $line
	echo ""
	sleep 1
	echo " After closing this app you may wonder..."
	echo ""
	sleep 1
	echo " Is -=Engine Flush-O-Matic=- working?"
	echo " ===================================="
	echo ""
	sleep 1
	echo " Check out /data/Ran_EngineFlush-O-Matic.log!"
	echo ""
	sleep 1
	echo " Or... in Terminal Emulator, you can type..."
	echo ""
	sleep 1
	echo " \"pstree | grep -i flus\" OR \"pstree|grep sleep\""
	echo ""
	sleep 1
	echo " OR... get COMPLETE information with..."
	echo ""
	sleep 1
	echo "      ...\"cat /proc/*/cmdline | grep -i flush\"!"
	echo ""
	sleep 1
	echo " The output should look like this:"
	echo ""
	sleep 1
	echo "   /data/V6_SuperCharger/!FastEngineFlush.sh..."
	echo "   OR /system/xbin/flush (either script name)"
	echo "   Engine_Flush-O-Matic_is_In_Effect!"
	echo "   flush"
	echo ""
	sleep 1
	echo " Easier: Similar results can be had with..."
	echo ""
	sleep 1
	echo "                 ...\"busybox ps | grep -i flus\""
	echo ""
	sleep 1
	echo " ...OR run this script again...I'll tell ya LOL"
	echo ""
	sleep 1
	echo $line
	echo "   Also READ THE COMMENTS inside this script!"
	echo $line
	echo ""
	sleep 1
	echo $line
	echo " Now executing -=Engine Flush-O-Matic=-..."
	echo $line
	echo ""
	sleep 1
fi
echo $line
echo "       Here We Go Again... in $flushOmaticHours hours LOL"
echo $line
echo ""
sleep 1
echo $line
echo "         Oh Hey! You can close this App!"
echo $line
echo ""
sleep 1
if [ "`busybox --help | grep nohup`" ] && [ ! "`busybox ps$w | grep "/${0##*/}" | grep {`" ]; then echo "cookie!" > /data/FOMtemp; (busybox nohup $0 > /dev/null &)
elif [ "`busybox --help | grep start-stop-daemon`" ] && [ ! "`busybox ps$w | grep "/${0##*/}" | grep {`" ]; then echo "cookie!" > /data/FOMtemp; busybox start-stop-daemon -S -b -x $0
else echo "cookie!" > /data/FOMtemp; $0 & exit 0
fi
