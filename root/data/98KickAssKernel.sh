#!/system/bin/sh
#
# The Kick Ass Kernelizer assembled and refined by zeppelinrox.
# See included links for resources.
#
# You can choose your scheduler by editing the "sio" line near the bottom.
# Look for the comment down there!
#
# echo ""; echo " See /data/Log_KickAssKernel.log for the output!"; echo "";
# For debugging, delete the # at the beginning of the following 2 lines, and check /data/Log_KickAssKernel.log file to see what may have fubarred.
# set -x;
# exec > /data/Log_KickAssKernel.log 2>&1;
#
line=================================================;
echo "";
echo $line;
echo " The -=Kick Ass Kernelizer=- by -=zeppelinrox=-";
echo $line;
echo "";
id=`id`; id=`echo ${id#*=}`; id=`echo ${id%%\(*}`; id=`echo ${id%%gid*}`;
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	echo " You are NOT running this script as root...";
	echo "";
	echo $line;
	echo "                      ...No SuperUser for you!!";
	echo $line;
	echo "";
	echo "     ...Please Run as Root and try again...";
	echo "";
	echo $line;
	echo "";
	exit 69;
fi;
echo " Time for your Kernel to Kick Some Ass!";
echo "";
echo " ...& double check via /data/Ran_KickAssKernel!";
echo "";
echo $line;
echo "";
busybox mount -o remount,rw /data 2>/dev/null;
if [ `cat /proc/sys/vm/dirty_background_ratio` -ne 60 ] || [ `cat /proc/sys/vm/dirty_ratio` -ne 95 ] || [ `cat /proc/sys/net/ipv4/tcp_congestion_control` != "cubic" ] || [ `cat /proc/sys/fs/lease-break-time` -ne 10 ] || [ `cat /proc/sys/vm/vfs_cache_pressure` -ne 20 ] || [ `cat /proc/sys/net/core/rmem_max` -ne 1048576 ] || [ `cat /proc/sys/net/core/optmem_max` -ne 20480 ]; then
	busybox sysctl -p;
	  ################################
	 #  Disable normalized sleeper  #
	################################
	#
	# Not applied if SmartReflex is found - since this breaks SmartReflex... lulz?
	# And DON'T ask me what SmartReflex is... Google shit for a change!
	#
	busybox mount -t debugfs none /sys/kernel/debug 2>/dev/null;
	echo NO_NORMALIZED_SLEEPER > /sys/kernel/debug/sched_features 2>/dev/null;
	busybox umount /sys/kernel/debug;
	  #########################
	 #  Memory Management++  #
	#########################
	# http://goo.gl/4w0ba - MFK Calculator Info - explanation for vm.min_free_kbytes
	# http://www.linuxinsight.com/proc_sys_hierarchy.html
	# http://forum.xda-developers.com/showthread.php?t=813309
	# http://forum.xda-developers.com/showthread.php?p=12445735
	# http://forum.xda-developers.com/showthread.php?p=4806456
	# http://www.cyberciti.biz/files/linux-kernel/Documentation/sysctl/vm.txt
	# http://www.cyberciti.biz/files/linux-kernel/Documentation/sysctl/kernel.txt
	# http://intl.feedfury.com/content/47077504-tweak-skript-f-r-android-spica.html
	#
	busybox sysctl -e -w vm.min_free_kbytes=15360;
	busybox sysctl -e -w vm.oom_kill_allocating_task=0;
	busybox sysctl -e -w vm.panic_on_oom=0;
	busybox sysctl -e -w vm.dirty_background_ratio=60;
	busybox sysctl -e -w vm.dirty_ratio=95;
	busybox sysctl -e -w vm.vfs_cache_pressure=20;
	busybox sysctl -e -w vm.overcommit_memory=1;
	busybox sysctl -e -w vm.min_free_order_shift=4;
	busybox sysctl -e -w vm.laptop_mode=0;
	busybox sysctl -e -w vm.block_dump=0;
	busybox sysctl -e -w vm.oom_dump_tasks=1;
	busybox sysctl -e -w vm.swappiness=20;
	#
	# Misc tweaks for battery life
	busybox sysctl -e -w vm.dirty_writeback_centisecs=2000;
	busybox sysctl -e -w vm.dirty_expire_centisecs=1000;
	#
	busybox sysctl -e -w kernel.panic=30;
	busybox sysctl -e -w kernel.panic_on_oops=1;
	busybox sysctl -e -w kernel.msgmni=2048;
	busybox sysctl -e -w kernel.msgmax=65536;
	busybox sysctl -e -w kernel.random.read_wakeup_threshold=128;
	busybox sysctl -e -w kernel.random.write_wakeup_threshold=256;
	busybox sysctl -e -w kernel.shmmni=4096;
	busybox sysctl -e -w kernel.shmall=2097152;
	busybox sysctl -e -w kernel.shmmax=268435456;
	busybox sysctl -e -w kernel.sem='500 512000 64 2048';
	busybox sysctl -e -w kernel.sched_features=24189;
	busybox sysctl -e -w kernel.hung_task_timeout_secs=30;             # Set to 0 to disable but can cause black screen on incoming calls
	busybox sysctl -e -w kernel.sched_latency_ns=18000000;
	busybox sysctl -e -w kernel.sched_min_granularity_ns=1500000;
	busybox sysctl -e -w kernel.sched_wakeup_granularity_ns=3000000;
	busybox sysctl -e -w kernel.sched_compat_yield=1;
	busybox sysctl -e -w kernel.sched_shares_ratelimit=256000;
	busybox sysctl -e -w kernel.sched_child_runs_first=0;
	busybox sysctl -e -w kernel.threads-max=524288;
	busybox sysctl -e -w fs.lease-break-time=10;
	busybox sysctl -e -w fs.file-max=524288;
	busybox sysctl -e -w fs.inotify.max_queued_events=32000;
	busybox sysctl -e -w fs.inotify.max_user_instances=256;
	busybox sysctl -e -w fs.inotify.max_user_watches=10240;
	  ##########################
	 #  TCP Speed & Security  #
	##########################
	# http://www.speedguide.net/articles/linux-tweaking-121
	# http://www.psc.edu/networking/projects/tcptune/#Linux
	# http://www.cyberciti.biz/faq/linux-tcp-tuning
	# http://www.cyberciti.biz/files/linux-kernel/Documentation/networking/ip-sysctl.txt
	#
	# Queue size modifications
	busybox sysctl -e -w net.core.wmem_max=1048576;
	busybox sysctl -e -w net.core.rmem_max=1048576;
	#busybox sysctl -e -w net.core.rmem_default=262144;
	#busybox sysctl -e -w net.core.wmem_default=262144;
	busybox sysctl -e -w net.core.optmem_max=20480;
	busybox sysctl -e -w net.unix.max_dgram_qlen=50;
	#
	busybox sysctl -e -w net.ipv4.tcp_moderate_rcvbuf=1;               # Be sure that autotuning is in effect
	busybox sysctl -e -w net.ipv4.route.flush=1;
	busybox sysctl -e -w net.ipv4.udp_rmem_min=6144;
	busybox sysctl -e -w net.ipv4.udp_wmem_min=6144;
	busybox sysctl -e -w net.ipv4.tcp_rfc1337=1;
	busybox sysctl -e -w net.ipv4.ip_no_pmtu_disc=0;
	busybox sysctl -e -w net.ipv4.tcp_ecn=0;
	busybox sysctl -e -w net.ipv4.tcp_rmem='6144 87380 1048576';
	busybox sysctl -e -w net.ipv4.tcp_wmem='6144 87380 1048576';
	busybox sysctl -e -w net.ipv4.tcp_timestamps=0;
	busybox sysctl -e -w net.ipv4.tcp_sack=1;
	busybox sysctl -e -w net.ipv4.tcp_fack=1;
	busybox sysctl -e -w net.ipv4.tcp_window_scaling=1;
	#
	# Re-use sockets in time-wait state
	busybox sysctl -e -w net.ipv4.tcp_tw_recycle=1;
	busybox sysctl -e -w net.ipv4.tcp_tw_reuse=1;
	#
	# KickAss UnderUtilized Networking Tweaks below initially suggested by avgjoemomma (from XDA)
	# Refined and tweaked by zeppelinrox... duh.
	#
	busybox sysctl -e -w net.ipv4.tcp_congestion_control=cubic;        # Change network congestion algorithm to CUBIC
	#
	# Hardening the TCP/IP stack to SYN attacks (That's what she said)
	# http://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening
	# http://www.symantec.com/connect/articles/hardening-tcpip-stack-syn-attacks
	#
	busybox sysctl -e -w net.ipv4.tcp_syncookies=1;
	busybox sysctl -e -w net.ipv4.tcp_synack_retries=2;
	busybox sysctl -e -w net.ipv4.tcp_syn_retries=2;
	busybox sysctl -e -w net.ipv4.tcp_max_syn_backlog=1024;
	#
	busybox sysctl -e -w net.ipv4.tcp_max_tw_buckets=16384;            # Bump up tw_buckets in case we get DoS'd
	busybox sysctl -e -w net.ipv4.icmp_echo_ignore_all=1;              # Ignore pings
	busybox sysctl -e -w net.ipv4.icmp_echo_ignore_broadcasts=1;       # Don't reply to broadcasts (prevents joining a smurf attack)
	busybox sysctl -e -w net.ipv4.icmp_ignore_bogus_error_responses=1; # Enable bad error message protection (should be enabled by default)
	busybox sysctl -e -w net.ipv4.tcp_no_metrics_save=1;               # Don't cache connection metrics from previous connection
	busybox sysctl -e -w net.ipv4.tcp_fin_timeout=15;
	busybox sysctl -e -w net.ipv4.tcp_keepalive_intvl=30;
	busybox sysctl -e -w net.ipv4.tcp_keepalive_probes=5;
	busybox sysctl -e -w net.ipv4.tcp_keepalive_time=1800;
	#
	# Don't pass traffic between networks or act as a router
	busybox sysctl -e -w net.ipv4.ip_forward=0;                        # Disable IP Packet forwarding (should be disabled already)
	busybox sysctl -e -w net.ipv4.conf.all.send_redirects=0;
	busybox sysctl -e -w net.ipv4.conf.default.send_redirects=0;
	#
	# Enable spoofing protection (turn on reverse packet filtering)
	busybox sysctl -e -w net.ipv4.conf.all.rp_filter=1;
	busybox sysctl -e -w net.ipv4.conf.default.rp_filter=1;
	#
	# Don't accept source routing
	busybox sysctl -e -w net.ipv4.conf.all.accept_source_route=0;
	busybox sysctl -e -w net.ipv4.conf.default.accept_source_route=0 ;
	#
	# Don't accept redirects
	busybox sysctl -e -w net.ipv4.conf.all.accept_redirects=0;
	busybox sysctl -e -w net.ipv4.conf.default.accept_redirects=0;
	busybox sysctl -e -w net.ipv4.conf.all.secure_redirects=0;
	busybox sysctl -e -w net.ipv4.conf.default.secure_redirects=0;
	  #########################################
	 #  Remount with noatime and nodiratime  #
	#########################################
	for k in $(busybox mount | cut -d " " -f3); do
		busybox sync;
		busybox mount -o remount,noatime $k 2>/dev/null;
	done;
	  ###########################
	 #  Tweak I/O Scheduler++  #
	###########################
	for i in /sys/block/*/queue/scheduler; do
		if [ -f "$i" ]; then busybox sync;
			echo "cfq" > $i;
		fi;
	done;
	for i in /sys/block/*/queue; do
		if [ ! "`echo $i | grep loop`" ] && [ ! "`echo $i | grep ram`" ]; then
			if [ -f "$i/rotational" ] && [ "`cat $i/rotational`" -ne 0 ]; then echo "0" > $i/rotational; fi;
			if [ -f "$i/iosched/low_latency" ]; then echo "1" > $i/iosched/low_latency; fi;
			if [ -f "$i/iosched/back_seek_penalty" ]; then echo "1" > $i/iosched/back_seek_penalty; fi;
			if [ -f "$i/iosched/back_seek_max" ]; then echo "1000000000" > $i/iosched/back_seek_max; fi;
			if [ -f "$i/iosched/slice_idle" ]; then echo "0" > $i/iosched/slice_idle; fi;
			if [ -f "$i/iosched/fifo_batch" ]; then echo "1" > $i/iosched/fifo_batch; fi;
			if [ -f "$i/iosched/quantum" ]; then echo "16" > $i/iosched/quantum; fi;
			if [ -f "$i/nr_requests" ]; then echo "512" > $i/nr_requests; fi;
			if [ -f "$i/iostats" ] && [ "`cat $i/iostats`" -ne 0 ]; then echo "0" > $i/iostats; fi;
		fi;
	done;
	sio=`cat /sys/block/mmcblk0/queue/scheduler | grep sio`;
	deadline=`cat /sys/block/mmcblk0/queue/scheduler | grep deadline`;
	noop=`cat /sys/block/mmcblk0/queue/scheduler | grep noop`;
	for i in /sys/block/*/queue/scheduler; do
		if [ -f "$i" ]; then busybox sync;
			if [ "$sio" ]; then echo "sio" > $i;               # Put your desired scheduler here - just replace the 2 instances of "sio".
			elif [ "$deadline" ]; then echo "deadline" > $i;
			elif [ "$noop" ]; then echo "noop" > $i;
			fi;
		fi;
	done;
fi;
echo " $( date +"%m-%d-%Y %H:%M:%S" ): Kernel's Kickin' Ass via $0!" >> /data/Ran_KickAssKernel.log;
echo "";
echo $line;
echo "";
echo " $0 Executed...";
echo "";
echo "         ==============================";
echo "          ) KickAssKernel Completed! (";
echo "         ==============================";
echo "";
