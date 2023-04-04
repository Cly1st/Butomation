#!/bin/bash

# Disk information
disk_info()
{
    disk_stat=$(df -h | grep sda1)

    IFS=" "
    
    c_line=1

    for info in $disk_stat;
        do
            if [ $c_line -eq 5 ]; then
                usage=$(tr "%" " " <<<${info})
                return $((usage))
            fi
        ((c_line++))
        done
    return -1
}

# Get CPU
# Note: Make sure install mpstat
# sudo apt-get mpstat

cpu_info()
{
    cpu_stat=$(mpstat | grep "all")
    c_line=1

    for i in $cpu_stat;
        do
            if [ $c_line == 13 ]; then
                cpu_free=$i
            fi
            ((c_line++))
        done
}

ram_info()
{
    ram_stat=$(free | grep "Mem:")
    c_line=1

    for i in $ram_stat;
        do 
            if [ $c_line -eq 2 ]; then
                t_ram=$i
            elif [ $c_line -eq 3 ]; then
                u_ram=$i
            elif [ $c_line -gt 3 ]; then
                ram_used=$(bc <<< "scale=2;($u_ram/$t_ram)*100")
                break
            fi
            ((c_line++))
        done
}