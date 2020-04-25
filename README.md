# Docker container for Plex Media Server and Plexdrive
Based on official Docker container for Plex Media Server. Plexdrive v.5.1.0 <br>
*Fork of original https://bitbucket.org/sh1ny/docker-pms-plexdrive*

## Usage
All options are inherited from the [official PMS container](https://github.com/plexinc/pms-docker). Refer to PMS documentation for more info.

Make sure to either place Plexdrive config files (`config.json`, `token.json`, and optionally `cache.bolt`) in `PLEXDRIVE_CONFIG_DIR` folder within Plex Media Server config folder (next to the Library folder */config*) or enter on container terminal and run the following command once to configure the credentials:
```
plexdrive mount -c ${HOME}/${PLEXDRIVE_CONFIG_DIR} --cache-file=${HOME}/${PLEXDRIVE_CONFIG_DIR}/cache.bolt -o allow_other ${PLEXDRIVE_MOUNT_POINT}
```
No need to wait for Plexdrive to complete its initial cache building process. Now you have the `config.json` and `token.json` created and can exit from terminal (Cntrl + C and `exit`).

Example run command:

```
docker run --name docker-pms-plexdrive \
           -d \
           -e TZ="<your timezone>" \
           -e CHANGE_CONFIG_DIR_OWNERSHIP="false" \
           -h <HOSTNAME> \
           -p 32400:32400/tcp \
           -p 3005:3005/tcp \
           -p 8324:8324/tcp \
           -p 32469:32469/tcp \
           -p 1900:1900/udp \
           -p 32410:32410/udp \
           -p 32412:32412/udp \
           -p 32413:32413/udp \
           -p 32414:32414/udp \
           -v /path/to/pms/config:/config \
           -v /path/to/pms/transcode/temp:/transcode \
           --cap-add MKNOD \
           --cap-add SYS_ADMIN \
           --device /dev/fuse \
           --restart=unless-stopped \
           1mmortal/docker-pms-plexdrive:beta
```

## Parameters

Those are not required unless you want to preserve your current folder structure or maintain special file permissions.

- `PLEXDRIVE_CONFIG_DIR` Sets the name of Plexdrive config folder found within PMS config folder. Default is `.plexdrive`.
- `PLEXDRIVE_MOUNT_POINT` Sets the name of internal Plexdrive mount point. Default is `/home/Plex`.
- `CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP` Defines if the container should attempt to correct permissions of existing Plexdrive config files.
- `PLEX_UID` and `PLEX_GID` Sets user ID and group ID for `Plex` user. Useful if you want them to match those of your own user on the host.
- `EXTRA_PARAMS` Add more advanced parameters for plexdrive to mount initial command. You can use, for example:
  - `--drive-id=ABC123qwerty987` for Team Drive with id `ABC123qwerty987`
  - `--root-node-id=DCBAqwerty987654321_ASDF123456789` for a mount only the sub directory with id `DCBAqwerty987654321_ASDF123456789`
  - *[... plexdrive documentation for more info ...](https://github.com/plexdrive/plexdrive#usage)*
  -  **IMPORTANT:** Not allowed "`-v` `--verbosity`", "`-c` `--config`", "`--cache-file`" or "`-o` `--fuse-options`" parameters, because are already used.


## Host folder structure example

```
Docker Data
├── pms-docker
│   ├── config
│   │   ├── .plexdrive
│   │   │   └── ...
│   │   └── Library
│   │       └── ...
│   └── transcode
└── ...
```
## Tags

Tags correspond to those of the official Plex Media Server Docker container:

- `public` — Public release of PMS.
- `beta` — Beta release of PMS, aka 'PlexPass'.
- `latest` — currently the same as `public`.
