#!/usr/bin/env bash

SUDO_PARSING() {
    msg=$(echo $1 | grep -iEo "COMMAND=" | tr '[A-Z]' '[a-z]')
    case ${msg} in
        "command=")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'sudo:' '{print $2}')
            TYPE="use"
            USER=$(echo ${text}| awk '{print $1}')
            COMMAND=$(echo ${text} | awk -F'command=' '{print$2}')
        ;;
        *)
            TYPE=""
        ;;
    esac
}
