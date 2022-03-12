#!/bin/sh ./functions.sh

include setup

#initialize defaults
# export USER_DIR="/home/lighthouse"
export CLUSTER="Cluster_1"
export DSTSERVER_DIR="${HOME}/dstserver"
export DSTWORLDS_DIR="${HOME}/dstworlds"
export STEAM_CMD_DIR="${HOME}/steamcmd"
export STEAM_CMD_IMAGE="steamcmd_linux.tar.gz"
export STEAM_CMD_URL="https://steamcdn-a.akamaihd.net/client/installer/${STEAM_CMD_IMAGE}"

export VERBOSE=0

while [ -n "$1" ]; do
        case "$1" in
                -s) export DSTSERVER_DIR="$2"; shift;;
                -w) export DSTWORLDS_DIR="$2"; shift;;
                -c) export CLUSTER="$2"; shift;;
                -x) export STEAM_CMD_DIR="$2"; shift;;
                -v) export VERBOSE=1; shift;;
                *) break;;
        esac
        shift;
done

export CLUSTER_DIR="${DST_WORLDS_DIR}/${CLUSTER}"

check_deps
check_utils

steam_setup
dstserver_setup
mods_setup
