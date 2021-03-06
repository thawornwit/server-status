#!/bin/sh

# Every 6 hours truncate the main log files on SD card to n lines

cd /home/root/gpio/sd/logs

echo "system reboot" >> battery_status_log.txt
echo "system reboot" >> server_status_log.txt
echo "system reboot" >> battery_charge_log.txt
echo "system reboot" >> button_log.txt
echo "system reboot" >> rtc_log.txt

truncate() { tail -$2 $1 > $1.tmp; cat $1.tmp > $1; rm $1.tmp; }

while true; do
	truncate battery_status_log.txt 2000
	truncate server_status_log.txt 2000
	truncate battery_charge_log.txt 2000
	truncate button_log.txt 500
	truncate rtc_log.txt 500
	sleep 21600
done
