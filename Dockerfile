FROM plexinc/pms-docker:public

LABEL maintainer="https://github.com/rapejim/pms-plexdrive-docker"

ENTRYPOINT ["/init"]

ENV PLEXDRIVE_CONFIG_DIR=".plexdrive" \
    CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP="true" \
    PLEXDRIVE_MOUNT_POINT="/home/Plex"

COPY root/ /

RUN apt-get update -qq && apt-get install -qq -y \
    fuse \
    wget \
  && echo "user_allow_other" > /etc/fuse.conf \
  && /plexdrive-install.sh \
  && rm -rf /tmp/* /var/lib/apt/lists/*

HEALTHCHECK --interval=3m --timeout=100s \
CMD test -r $(find ${PLEXDRIVE_MOUNT_POINT} -maxdepth 1 -print -quit) && /healthcheck.sh || exit 1
