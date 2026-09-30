#!/bin/bash

threshold=70

check_value() {
    name=$1
    value=$2

    if [ "$value" -lt "$threshold" ]; then
        echo "$name: $value% used — OK"
    else
        echo "$name: $value% used — WARNING"
    fi
}

check_value "Disk" 62
