#!/usr/bin/env bash
# set -x

source ./libs/function.sh
source ./config/config.sh

# 지원하는 OS인지 확인
OS_CHECK
case ${OS}${OS_VERSION} in
    centos8)
        for file in $(ls ./os/centos8/*.sh); do source ${file}; done ;;
    centos7)
        for file in $(ls ./os/centos7/*.sh); do source ${file}; done ;;
    centos6)
        for file in $(ls ./os/centos6/*.sh); do source ${file}; done ;;
    centos5)
        for file in $(ls ./os/centos5/*.sh); do source ${file}; done ;;
    *)
        LOG "Not support OS version ${OS}"
        exit 1                       
        ;;
esac

MAX_PID=$(cat /proc/sys/kernel/pid_max |wc -m)
if [[ ${MAX_PID} -eq 0 ]]; then
    MAX_PID=12
fi

# 접속자 계정명 관리를 위한 배열 생성
declare -A CONNECTOR

# 실시간 검사 시작
tail -n0 -F ${CONNET_LOG} | while read line; do
    time=$(TIME "${line}")
    host=$(HOST "${line}")
    cmd=$(CMD "${line}")

    if [[ ${cmd} =~ ^su: ]]; then
        cmd="su"
        SU_PARSING "${line}"
        if [[ -n ${TYPE} ]]; then
            curl -m 30 -o ${SU_URL}"?type=${TYPE}&user=${USER}&new_user=${NEW_USER}"
        fi        
    elif [[ ${cmd} =~ ^sudo: ]]; then
        cmd="sudo"
        SUDO_PARSING "${line}"
        if [[ -n ${TYPE} ]]; then
            curl -m 30 -o ${SUDO_URL}"?type=${TYPE}&user=${USER}&cmd=${COMMAND}"
        fi
    elif [[ ${cmd} =~ ^ssh ]]; then
        pid=$(PID_CHECK "${cmd}")
        cmd="ssh"
        SSH_PARSING "${line}"
        if [[ -n ${TYPE} ]]; then
            curl -m 30 ${SSH_URL}"?type=${TYPE}&ip=${IP}&port=${PORT}&user=${USER}"
        fi
    fi
done
