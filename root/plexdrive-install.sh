#!/bin/sh
# Plexdrive updater
cd /tmp
wget "https://github.com/plexdrive/plexdrive/releases/download/$PLEXDRIVE_VERSION/plexdrive-linux-$ARCH" -q -O plexdrive
chmod -c +x /tmp/plexdrive
version=$(/tmp/plexdrive --version)
echo "Installing Plexdrive v. ${version}"
#install plexdrive
mv -v /tmp/plexdrive /usr/local/bin/
chown -c root:root /usr/local/bin/plexdrive
