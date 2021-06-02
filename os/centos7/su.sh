#!/usr/bin/env bash

SU_PARSING() {
    msg=$(echo $1 | tr '[A-Z]' '[a-z]' | grep -Eo "session opened for user|session closed for user|authentication failure;")
    case ${msg} in
        "session opened for user")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'session opened for user' '{print $2}')
            TYPE="connect"
            USER=$(echo ${text} | awk '{print $3}' | awk -F'(' '{print $1}')
            NEW_USER=$(echo ${text}| awk '{print $1}')
        ;;
        "session closed for user")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'session closed for user' '{print $2}')
            TYPE="disconnect"
            USER=$(echo ${text}| awk '{print $1}')
            NEW_USER=""
        ;;
        "authentication failure;")
            text=$(echo $1 | tr '[A-Z]' '[a-z]' | awk -F'authentication failure' '{print $2}')
            TYPE="closed"
            USER=$(echo ${text} | awk -F'=' '{print $6}' | awk '{print $1}')
            NEW_USER=$(echo ${text} | awk -F'=' '{print $8}' | awk '{print $1}')
        ;;
        *)
            TYPE=""
        ;;
    esac
}
