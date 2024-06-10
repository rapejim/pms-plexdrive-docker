#!/bin/sh
# Plexdrive installer

# Determine architecture
ARCH=$(dpkg --print-architecture)
# Validate architecture
if [ "$ARCH" != "amd64" ] && [ "$ARCH" != "arm64" ]; then
  echo "Arquitectura no soportada: $ARCH. El script solo soporta amd64 y arm64."
  exit 1
fi

# Get plexdrive
cd /tmp
echo "Downloading https://github.com/plexdrive/plexdrive/releases/download/$PLEXDRIVE_VERSION/plexdrive-linux-$ARCH"
wget "https://github.com/plexdrive/plexdrive/releases/download/$PLEXDRIVE_VERSION/plexdrive-linux-$ARCH" --no-verbose -O plexdrive
chmod -c +x /tmp/plexdrive
version=$(/tmp/plexdrive --version)

# Install plexdrive
echo "Installing Plexdrive v. ${version}"
mv -v /tmp/plexdrive /usr/local/bin/
chown -c root:root /usr/local/bin/plexdrive
