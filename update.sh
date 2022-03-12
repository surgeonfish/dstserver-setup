#!/bin/sh ./functions.sh

include setup

dstserver_shutdown
dstserver_update
# NOTE: the mod configuration of DST server will be covered sometimes, need to
# setup mods in this case.
mods_setup
