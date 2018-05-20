#!/usr/bin/env bash

# ^^ you saw that, right? Yes I'm using bash for this. Do not follow in my footsteps. Ever.

set -u
set -e
trap 'echo "Error line $LINENO"' ERR

gngga_lines=$(cat syslog | grep GNGGA | cut -d, -f2- | cut -d. -f1)
#gngga_lines=$(cat syslog | grep GNGGA | tail -n 2 | cut -d, -f2- | cut -d. -f1) # testing

echo "timestamp_utc,lat,lon,num_sats,altitude,lm75_temp,bme280_temp,bme280_humidity,bme280_pressure,voltage,current,pi_photo"
for timestamp in $gngga_lines; do # oh yeah baby, work that bash range magic
    if [ $timestamp -le 105854 ]; then # this is when the "production" run of the tracker started
        echo "early"
        continue
    fi
    #echo "Timestamp: $timestamp"
    gps_line=$(grep GNGGA,$timestamp syslog | awk '{print $7}')
    sensor_line=$(grep GNGGA,$timestamp syslog -B 20 | grep Sensors: | tail -n 1 | cut -d: -f5-)
    photo=$(grep GNGGA,$timestamp syslog -B 50 | grep "Camera: taking picture" | tail -n 1 | awk '{print $10}')
    #echo $gps_line
    #echo $sensor_line
    #echo $photo
    echo -n $(echo $gps_line | cut -d, -f2,3,5,8,10)
    echo -n ,
    echo -n $(echo $sensor_line | cut -d= -f2 | cut -d, -f1)
    echo -n ,
    echo -n $(echo $sensor_line | cut -d= -f3 | cut -d\  -f1)
    echo -n ,
    echo -n $(echo $sensor_line | cut -d= -f4 | cut -d\  -f1)
    echo -n ,
    echo -n $(echo $sensor_line | cut -d= -f5 | cut -d\  -f1)
    echo -n ,
    echo -n $(echo $sensor_line | cut -d= -f6 | cut -d\  -f1)
    echo -n ,
    echo -n $(echo $sensor_line | cut -d= -f7 | cut -d\  -f1)
    echo -n ,
    echo -n $photo
    echo
done
