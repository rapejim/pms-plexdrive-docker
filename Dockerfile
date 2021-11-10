FROM plexinc/pms-docker:beta

LABEL maintainer="rapejim"

ARG ARCH='amd64'
ARG PLEXDRIVE_VERSION='5.1.0'

ENTRYPOINT ["/init"]

ENV PLEXDRIVE_CONFIG_DIR=".plexdrive" \
    CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP="true" \
    PLEXDRIVE_MOUNT_POINT="/home/Plex" \
    EXTRA_PARAMS=""

COPY root/ /

RUN apt-get update -qq && apt-get install -qq -y \
    fuse \
    wget \
    && \
    # Update fuse.conf
    sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf &&\
    # Install plexdrive
    /plexdrive-install.sh && \
    # Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

HEALTHCHECK --interval=15s --timeout=100s \
CMD test -r $(find ${PLEXDRIVE_MOUNT_POINT} -maxdepth 1 -print -quit) && /healthcheck.sh || exit 1
