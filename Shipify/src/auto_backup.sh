#!/bin/bash
DEFAULT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. ${DEFAULT_DIR}/notification.sh

today=$(date '+%Y%m%d')

# 1) Zip files

    # Current working directory
src_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/files/

declare -a extension=("jpg" "csv" "txt")

    # Loop through extension
for ext in ${extension[@]};
    
    do 

        echo "Working on: ${ext} ..."
        
        files=${src_dir}*.${ext}
        zipfile=${src_dir}${ext}_${today}

        ls $files -R 2>/dev/null
        
        if [ $? -eq 0 ]; then
            
            zip $zipfile $files

        fi
        
    done

# 2) Send backup

dst_dir="/home/chhayly/backup/" # Replace with your backup server directory
ip="172.17.3.181" # Replace with your backup server ip address
username="chhayly" # Replace with your backup server username

src_files=${src_dir}*${today}.zip

while :

    do
        ls ${src_files}

        if [ $? -eq 0 ]; then

            echo "Finished zip!"
            echo "Starting backup to server ..."

            #scp is secure copy (copy with ssh, so make sure you have generate ssh key and add to your backup server)
            scp ${src_files} ${username}@${ip}:${dst_dir}

            echo "Finished backup!"
            break
        else
            echo "Waiting for zip to finish..."
        fi

        sleep 1
    done

# 3) Send notification
TOKEN_ID=$(cat ${DEFAULT_DIR}/secret/token)
CHAT_ID=$(cat ${DEFAULT_DIR}/secret/chatid)
finish_date=$(date '+%D %X')

echo -e "Datetime: ${finish_date}\n\nDear team,\n\nThe backup is finished on the server ip address ${ip}.\nThank you!" > "${DEFAULT_DIR}/info"

# Send as file
sendFile $TOKEN_ID $CHAT_ID "${DEFAULT_DIR}/info"
