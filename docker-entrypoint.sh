#!/bin/bash

set -x

export DISPLAY=:1

Xvfb :1 -screen 0 1024x768x16 &

cp -r /playdate/main.lua /tests/
cp -r /playdate/luaunit /tests/

rm -fr ${PLAYDATE_SDK_PATH}/Disk/System/Launcher.pdx

pdc -m /tests/main.lua ${PLAYDATE_SDK_PATH}/Disk/System/Launcher.pdx

PlaydateSimulator | tee playdate.log

grep -E '^Ran ([0-9]+) tests in ([0-9]+\.[0-9]+) seconds, ([0-9]+) successes, 0 failures$' playdate.log
