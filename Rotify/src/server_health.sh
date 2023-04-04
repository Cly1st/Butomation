#!/bin/bash
DEFAULT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Import packages
. ${DEFAULT_DIR}/resource.sh
. ${DEFAULT_DIR}/notification.sh

# For resource
HUNDRED=100
MAX_DISK=15
MAX_CPU=95
MAX_RAM=95

# For Telegram
TOKEN_ID=$(cat ${DEFAULT_DIR}/secret/token)
CHAT_ID=$(cat ${DEFAULT_DIR}/secret/chatid)


while :

    do

        # 1) Get resource information
        # Disk
        disk_info
        disk_used=$?

        # CPU
        cpu_info
        cpu_used=$(bc <<< "scale=2;$HUNDRED-$cpu_free")

        # RAM
        ram_info

        # 2) Send notification  
        if [ $disk_used -ge $MAX_DISK ]; then
            echo -e "\nWarning! Critical condition!"
            echo -e "----------------------------\n"

            check_date=$(date '+%D %X')

            # Write resources to file
            hostname=$(hostname)
            echo -e "Warning!\n\nCheck date: ${check_date}\nHostname: ${hostname}\nDisk used:\
                ${disk_used}%\nCPU: ${cpu_used}%\nRAM: ${ram_used}%" > "${DEFAULT_DIR}/info"

            # Send
            sendMessage $TOKEN_ID $CHAT_ID "Warning!" # Send text
            sendFile $TOKEN_ID $CHAT_ID "${DEFAULT_DIR}/info" # Send file
        else
            echo -e "\nNormal condition!"
            echo -e "------------------"
        fi

        echo "Disk used: ${disk_used} %"
        echo "CPU used: ${cpu_used} %"
        echo "RAM used: ${ram_used} %"

        sleep 3

    done
