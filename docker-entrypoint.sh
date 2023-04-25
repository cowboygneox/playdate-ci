#!/bin/bash

export DISPLAY=:1

Xvfb :1 -screen 0 1024x768x16 &

cp -R /tests/* /runner/
cp -r /playdate/main.lua /runner/
cp -r /playdate/luaunit /runner/

rm -fr ${PLAYDATE_SDK_PATH}/Disk/System/Launcher.pdx

cd /runner
pdc -m main.lua ${PLAYDATE_SDK_PATH}/Disk/System/Launcher.pdx

# Override Github's attempt to change the HOME
export HOME=/root

PlaydateSimulator | tee /runner/tests.log

grep -q -E '^Ran ([0-9]+) tests in ([0-9]+\.[0-9]+) seconds, ([0-9]+) successes, 0 failures$' /runner/tests.log
