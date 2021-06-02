#!/usr/bin/env bash

LOG() {
    if [[ -z "$1" ]]; then date_format=$(date "+%Y-%m-%d %H:%M:%S"); echo -e "${date_format} $1" >> ${LOG_FILE}; fi
}

OS_CHECK() {
    case $(uname) in
        AIX)
            OS="AIX"
            OS_VERSION=$(oslevel | tr '[a-z]' '[A-Z]')
            CONNET_LOG="/var/log/secure"
        ;;
        Linux)
            OS=$(grep "^ID=" /etc/os-release | awk -F= '{print $2}' | tr -d '"' | tr '[A-Z]' '[a-z]')
            OS_VERSION=$(grep "^VERSION_ID=" /etc/os-release | awk -F= '{print $2}' | tr -d '"')
            CONNET_LOG="/var/log/secure"
        ;;
        *)
            OS=$(uname)
            OS_VERSION="unknown"
        ;;
    esac
}

IN_ARRAY() {
    if [[ -n ${CONNECTOR[$1]} ]]; then
        echo ${CONNECTOR[$1]}
        unset ${CONNECTOR[$1]}
    else
        echo "unknown"
    fi
}
