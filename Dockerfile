FROM plexinc/pms-docker:beta

MAINTAINER sh1ny@me.com

ENTRYPOINT ["/init"]

RUN \
  apt update &&\
  apt -y install wget unzip fuse &&\
  mkdir -p /tmp/rclone && cd /tmp/rclone &&\
  wget -q "https://downloads.rclone.org/rclone-current-linux-amd64.zip" &&\
  unzip /tmp/rclone-current-linux-amd64.zip &&\
  cp ./rclone*linux-amd64/rclone /usr/sbin &&\
  chown root:root /usr/sbin/rclone &&\
  chmod 755 /usr/sbin/rclone &&\
  mkdir -p /tmp/plexdrive && cd /tmp/plexdrive &&\
  wget \
  $(curl -s "https://api.github.com/repos/dweidenfeld/plexdrive/releases/latest"\
    | grep 'browser_' \
    | cut -d "\"" -f4 \
    | grep plexdrive-linux-amd64) \
  -O plexdrive &&\
  mv plexdrive /usr/local/bin/ &&\
  chown root:root /usr/local/bin/plexdrive &&\
  chmod 755 /usr/local/bin/plexdrive &&\
  apt remove -y unzip && apt -y autoremove && apt -y clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* var/tmp/*

VOLUME /home/Plex
