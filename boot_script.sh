#!/bin/sh

# reset in case battery_status script fails
echo 0 > /home/root/debian/home/buendia/battery_shutdown.txt

cd /home/root/gpio

mkdir -p sd/logs   # in case absent
touch sd/logs/server_status_log.txt
touch sd/logs/battery_status_log.txt
touch sd/logs/battery_charge_log.txt
touch sd/logs/scripts_check_log.txt
touch sd/logs/button_log.txt

# mount SD, test it is writable, and if not unmount
mount /dev/mmcblk1p1 /home/root/debian/home/buendia/sd/ || touch sd_mount_failed
touch sd/write_test && rm sd/write_test || umount -l /dev/mmcblk1p1

# update system time from RTC
python systime/set_edison_from_rtc > sd/logs/rtc_log.txt 2>&1 &

# splash screen
sleep 15
python splash_screen.py &
sleep 15

# SERVER STATUS
python server_status.py >> sd/logs/server_status_log.txt 2>&1 &

# BATTERY STATUS
echo 101 > battery_charge.txt  # reset status file
python battery_status.py >> sd/logs/battery_status_log.txt 2>&1 &

# SHUTDOWN BUTTON
python button_shutdown.py >> sd/logs/button_log.txt 2>&1 &

# OTHER SCRIPTS

# monitor scripts
./scripts_check.sh >> sd/logs/scripts_check_log.txt 2>&1 &

# truncate log files
./truncate_logs.sh  >> /dev/null 2>&1 &

exit 0
