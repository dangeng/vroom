#!/bin/bash

while :
do
    # Read /proc/stat file (for first datapoint)
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

    # compute active and total utilizations
    cpu_active_prev=$((user+system+nice+softirq+steal))
    cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))

    #usleep 50000
    sleep 2

    # Read /proc/stat file (for second datapoint)
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

    # compute active and total utilizations
    cpu_active_cur=$((user+system+nice+softirq+steal))
    cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))

    # compute CPU utilization (%)
    cpu_util=$((100*( cpu_active_cur-cpu_active_prev ) / (cpu_total_cur-cpu_total_prev) ))

    cpu_util=$(echo "scale=4;$cpu_util/50" | bc)


    # Debugging...
    #echo $cpu_util


    # Play sound at volume, no output
    play -q -v $cpu_util vroom.wav &
done

