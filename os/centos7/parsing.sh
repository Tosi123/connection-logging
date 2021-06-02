#!/usr/bin/env bash

TIME() {
    echo $1 | awk '{print $3}'
}

HOST() {
    echo $1 | awk '{print $4}'
}

CMD() {
    echo $1 | awk '{print $5}'
}
