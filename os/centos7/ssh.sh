#!/usr/bin/env bash

PID_CHECK() {
    echo $1 |grep -Eo "[0-9]{1,${MAX_PID}}"
}

SSH_PARSING() {
    msg=$(echo $1 | tr '[A-Z]' '[a-z]' | grep -Eo "accepted publickey for|disconnected from|connection closed by")
    case ${msg} in
        "accepted publickey for")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'accepted publickey for' '{print $2}')
            TYPE="connect"
            IP=$(echo ${text} | awk '{print $3}')
            PORT=$(echo ${text} | awk '{print $5}')
            USER=$(echo ${text}| awk '{print $1}')
            CONNECTOR[${PORT}]=${USER}
        ;;
        "disconnected from")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'disconnected from' '{print $2}')
            TYPE="disconnect"
            IP=$(echo ${text} | awk '{print $1}')
            PORT=$(echo ${text} | awk '{print $3}')
            USER=$(IN_ARRAY ${PORT})
        ;;
        "connection closed by")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'connection closed by' '{print $2}')
            TYPE="closed"
            IP=$(echo ${text} | awk '{print $1}')
            PORT=$(echo ${text} | awk '{print $3}')
            USER="unknown"
        ;;
        *)
            TYPE=""
        ;;
    esac
}
