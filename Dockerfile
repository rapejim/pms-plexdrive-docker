FROM plexinc/pms-docker:beta

MAINTAINER sh1ny@me.com

ENTRYPOINT ["/init"]

ENV CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP="true"

COPY root/ /

RUN apt-get update && apt-get -y install \
    fuse \
    wget \
  && /plexdrive-install.sh \
  && rm -rf /tmp/* /var/lib/apt/lists/*

HEALTHCHECK --interval=5m --timeout=3s \
  CMD ls /home/Plex/Movies || exit 1
