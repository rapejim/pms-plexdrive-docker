#!/bin/bash
# Plexdrive updater
cd /tmp
if [[ ${1} = 'beta' ]]
then
  echo This script only supports updating to stable versions right now.
  exit
else
  wget $(curl -s https://api.github.com/repos/dweidenfeld/plexdrive/releases/latest | grep 'browser_' | cut -d\" -f4 | grep plexdrive-linux-amd64) -O plexdrive > /dev/null 2>&1
  sudo chown root:root /tmp/plexdrive
  sudo chmod 755 /tmp/plexdrive
fi
cd /usr/local/bin
A=$(plexdrive --version)
B=$(/tmp/plexdrive --version)
if [[ ${A} = ${B} ]]
then
  echo ${A} is already current
else
  echo Installing new ${B}
  #install plexdrive
  sudo mv /tmp/plexdrive /usr/local/bin/
  sudo chown root:root /usr/local/bin/plexdrive
  sudo chmod 755 /usr/local/bin/plexdrive
fi
