# ***Plex Media Server and Plexdrive 🐳***

<div align="center"><img src="https://raw.githubusercontent.com/rapejim/pms-plexdrive-docker/public/images/banner.png" width="50%"></div>

Combine el poder de **Plex Media Server** *(en adelante PMS)* con los archivos multimedia de su cuenta de Google Drive (o una unidad de equipo) montados por ***Plexdrive.***

Basado en oficial [Imagen de PMS para Docker](https://hub.docker.com/r/plexinc/pms-docker) e instalado en el interior [Plexdrive v.5.1.0](https://github.com/plexdrive/plexdrive)<br>
*Bifurcado del original https://bitbucket.org/sh1ny/docker-pms-plexdrive repository.* <br>

***IMPORTANTE:*** *Todas las opciones se heredan del contenedor PMS oficial. [Consulte la documentación de PMS para obtener más información.](https://github.com/plexinc/pms-docker).* 
<br>
<br>
Lea esto en otros idiomas: [English](https://github.com/rapejim/pms-plexdrive-docker/blob/develop/README.md), [Spanish](https://github.com/rapejim/pms-plexdrive-docker/blob/develop/README.sp.md)


## ***Prerrequisitos***
---

Debes tener el tuyo `Client ID` y `Client Secret` para configurar plexdrive. Si no lo tiene, puede seguir cualquier guía de Internet, por ejemplo:
- [English](https://github.com/Cloudbox/Cloudbox/wiki/Google-Drive-API-Client-ID-and-Client-Secret)
- [Spanish](https://www.uint16.es/2019/11/04/como-obtener-tu-propio-client-id-de-google-drive-para-rclone/)

O puede usar los archivos de configuración de una instalación anterior de plexdrive (los archivos `config.json` y` token.json`, preferiblemente sin reutilizar el `cache.bolt`, es mejor que esta instalación genere uno nuevo).
<br>
<br>

## ***Ejemplo de comandos de ejecución***
---

### **Mínimo** ejemplo de comando de ejecución *(red de host)*:
```
docker run --name Plex -d \
    --net=host \
    -e TZ="Europe/Madrid" \
    -e PLEX_UID=${UID} \
    -e PLEX_GID=$(id -g) \
    -v /docker/pms-plexdrive/config:/config \
    -v /docker/pms-plexdrive/transcode:/transcode \
    --privileged \
    --cap-add MKNOD \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    --restart=unless-stopped \
    rapejim/pms-plexdrive-docker
```
***NOTA:*** *Debe reemplazar `Europe/Madrid` por su zona horaria y `/docker/pms-plexdrive/... `por su propia ruta (si no usa esta estructura de carpetas). Si tiene archivos de configuración (`config.json` y ` token.json`) de la instalación anterior de plexdrive, colóquelos en la carpeta `docker/pms-plexdrive/config/.plexdrive` folder.*
<br>
<br>
<br>

### **Avanzado** ejemplo de comando de ejecución *(red puente)*:

```
docker run --name Plex -h Plex -d \
    -p 32400:32400/tcp \
    -p 3005:3005/tcp \ # Optional
    -p 8324:8324/tcp \ # Optional
    -p 32469:32469/tcp \ # Optional
    -p 1900:1900/udp \ # Optional
    -p 32410:32410/udp \ # Optional
    -p 32412:32412/udp \ # Optional
    -p 32413:32413/udp \ # Optional
    -p 32414:32414/udp \ # Optional
    -e TZ="Europe/Madrid" \
    -e PLEX_UID=${UID} \
    -e PLEX_GID=$(id -g) \
    -v /docker/pms-plexdrive/config:/config \
    -v /docker/pms-plexdrive/transcode:/transcode \
    --privileged \
    --cap-add MKNOD \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    --restart=unless-stopped \
    rapejim/pms-plexdrive-docker
```
***NOTA:*** *Debe reemplazar `Europe/Madrid` por su zona horaria y `/docker/pms-plexdrive/... `por su propia ruta (si no usa esta estructura de carpetas). Si tiene archivos de configuración (`config.json` y ` token.json`) de la instalación anterior de plexdrive, colóquelos en la carpeta `docker/pms-plexdrive/config/.plexdrive` folder.*
<br>
<br>
<br>

## ***Primer uso y configuración inicial***
---
En la primera ejecución del contenedor (sin los archivos de configuración de la instalación anterior) debe ingresar dentro de la consola del contenedor, copiar y pegar y ejecutar este comando:
```
plexdrive mount -c ${HOME}/${PLEXDRIVE_CONFIG_DIR} --cache-file=${HOME}/${PLEXDRIVE_CONFIG_DIR}/cache.bolt -o allow_other ${PLEXDRIVE_MOUNT_POINT} {EXTRA_PARAMS}
```
Este comando inicia un asistente de configuración:
- Te pide tu `Client ID` y `Client Secret`
- Le muestra un enlace para iniciar sesión con su cuenta de Google Drive (que utilizó para obtener esa `Client ID` y `Client Secret`).
- La web te muestra un token que debes copiar y pegar en el terminal.
- Cuando lo completa, Plexdrive comienza a almacenar en caché los archivos de su cuenta de Google Drive en el segundo plano, no es necesario esperar a que Plexdrive complete su proceso inicial de creación de caché en esta consola, ahora tiene los archivos `config.json` y ` token.json` creado y puede salir de la terminal (*Cntrl+C* y `salir`).

***NOTA:*** *Si está creando este contenedor en una computadora remota (fuera de su red local), se recomienda utilizar la variable de entorno `PLEX_CLAIM` de la [imagen de la ventana acoplable PMS] original (https://github.com/plexinc/pms-docker) para vincular este nuevo servidor a su propia cuenta en la primera ejecución.*
<br>
<br>
<br>

## ***Parámetros***
---

Estos no son necesarios a menos que desee conservar la estructura de su carpeta actual o mantener permisos de archivo especiales.

- `PLEXDRIVE_CONFIG_DIR` Establece el nombre de la carpeta de configuración de Plexdrive que se encuentra dentro de la carpeta de configuración de PMS. El valor predeterminado es `.plexdrive`.
- `PLEXDRIVE_MOUNT_POINT` Establece el nombre del punto de montaje interno de Plexdrive. El valor predeterminado es `/home/Plex`.
- `CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP` Define si el contenedor debe intentar corregir los permisos de los archivos de configuración de Plexdrive existentes.
- `PLEX_UID` y `PLEX_GID` Establece el ID de usuario y el ID de grupo para el usuario de `Plex`. Útil si desea que coincidan con los de su propio usuario en el host.
- `EXTRA_PARAMS` Agregue parámetros más avanzados para que plexdrive monte el comando inicial. Puede utilizar, por ejemplo:
  - `--drive-id=ABC123qwerty987` para **Unidad de equipo** con id `ABC123qwerty987`
  - `--root-node-id=DCBAqwerty987654321_ASDF123456789` para un montaje solo el subdirectorio con id `DCBAqwerty987654321_ASDF123456789`
  - *[... plexdrive documentation for more info ...](https://github.com/plexdrive/plexdrive#usage)*
  -  **IMPORTANTE:** *No permitido "`-v` `--verbosity`", "`-c` `--config`", "`--cache-file`" o "`-o` `--fuse-options`" parámetros, porque ya se utilizan.*
<br>
<br>

***RECORDAR:*** *Todas las opciones del contenedor PMS oficial se heredan. [Consulte la documentación de PMS para obtener más información.](https://hub.docker.com/r/plexinc/pms-docker).*
<br>
<br>
<br>

## ***Ejemplo de estructura de carpetas de host***
---
```
Docker Data Folder
├── pms-plexdrive
│   ├── config
│   │   ├── .plexdrive
│   │   │   └── ...
│   │   └── Library
│   │       └── ...
│   └── transcode
└── ...
```
<br>
<br>
<br>

## ***Etiquetas***
---

Las etiquetas corresponden a las del contenedor Docker oficial de PMS:

- `public` — Lanzamiento público de PMS.
- `beta` — Lanzamiento beta de PMS ***(Requiere Plex Pass)***.
- `latest` — Actualmente lo mismo que `public`.
