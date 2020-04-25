#!/bin/sh
# Plexdrive updater
cd /tmp
wget $(curl -s https://api.github.com/repos/plexdrive/plexdrive/releases/latest | grep 'browser_' | cut -d\" -f4 | grep plexdrive-linux-amd64) -q -O plexdrive
chmod -c +x /tmp/plexdrive
version=$(/tmp/plexdrive --version)
echo "Installing Plexdrive v. ${version}"
#install plexdrive
mv -v /tmp/plexdrive /usr/local/bin/
chown -c root:root /usr/local/bin/plexdrive
