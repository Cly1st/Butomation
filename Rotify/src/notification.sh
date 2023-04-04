#!/bin/bash

sendMessage()
{
    url="https://api.telegram.org/bot${1}/sendMessage?chat_id=${2}"
    curl -X POST --silent -d text=$3  $url > /dev/null
    return $?
}

sendFile()
{
    url="https://api.telegram.org/bot${1}/sendDocument?chat_id=${2}"
    curl -X POST --silent -F document=@${3} $url > /dev/null
}
