FROM plexinc/pms-docker:beta

MAINTAINER sh1ny@me.com

ENTRYPOINT ["/init"]

ENV CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP="true" \
    PLEXDRIVE_MOUNT_POINT="/home/Plex" \
    CLOUD_MEDIA_LOCATION="Movies"

COPY root/ /

RUN apt-get update -qq && apt-get install -qq -y \
    fuse \
    wget \
  && echo "user_allow_other" > /etc/fuse.conf \
  && /plexdrive-install.sh \
  && rm -rf /tmp/* /var/lib/apt/lists/*

HEALTHCHECK --interval=3m --timeout=100s \
CMD ls ${PLEXDRIVE_MOUNT_POINT}/${CLOUD_MEDIA_LOCATION} && /healthcheck.sh || exit 1
