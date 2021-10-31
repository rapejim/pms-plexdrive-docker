# ***Plex Media Server and Plexdrive 🐳***

<div align="center"><img src="https://raw.githubusercontent.com/rapejim/pms-plexdrive-docker/public/images/banner.png" width="50%"></div>

Combina el poder de **Plex Media Server** *(por sus siglas en Inglés PMS)* con
los archivos multimedia en tu cuenta de Google Drive (o
[unidad compartida de equipo](https://support.google.com/a/users/answer/9310156?hl=es))
montados por [**Plexdrive**](https://github.com/plexdrive/plexdrive).

Este respositorio está basado en la
[imagen Docker oficial de PMS](https://hub.docker.com/r/plexinc/pms-docker) e
instalado en sobre [Plexdrive v.5.1.0](https://github.com/plexdrive/plexdrive). <br/>
*Bifurcado del repositorio original <https://bitbucket.org/sh1ny/docker-pms-plexdrive>.*

***IMPORTANTE:*** *Todas las opciones son heredadas del contenedor PMS oficial.
[Consulta la documentación de PMS para obtener más información](https://github.com/plexinc/pms-docker).*

Puedes leer este documento en otros idiomas:
[English](https://github.com/rapejim/pms-plexdrive-docker/blob/develop/README.md),
[Español](https://github.com/rapejim/pms-plexdrive-docker/blob/develop/README.ES.md)


## *Prerrequisitos*
---

Debes tener tu propio identificador de client (`Client ID`) y secreto de cliente
(`Client Secret`) para configurar Plexdrive. En caso no cuentes con ello, puedes
seguir cualquier guía en Internet, por ejemplo:

- [Español](https://www.uint16.es/2019/11/04/como-obtener-tu-propio-client-id-de-google-drive-para-rclone/)
- [English](https://github.com/Cloudbox/Cloudbox/wiki/Google-Drive-API-Client-ID-and-Client-Secret)

O puedes usar los archivos `config.json` y` token.json` de una instalación
previa de Plexdrive. En este caso, es preferible utilizar el archivo
`cache.bolt` de una instalación nueva.

## *Ejemplos de comandos de ejecución*
---

###  Ejemplo *básico* de ejecución del comando *(usando la red del host)*:

```bash
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

***NOTA:*** *Debes reemplazar `Europe/Madrid` por tu zona horaria y las rutas
de los volúmenes `/docker/pms-plexdrive/...` por la que tienes en tu ordenador
(en caso no uses la misma estructura de carpetas). Si tienes los archivos de
configuración (`config.json` y ` token.json`) de una instalación anterior de
plexdrive, colocalos en la carpeta `docker/pms-plexdrive/config/.plexdrive`.*
<br/>
<br/>
<br/>

### Ejemplo *Avanzado* de ejecución del comando *(usando la red tipo puente)*:

```bash
docker run --name Plex -h Plex -d \
    -p 32400:32400/tcp \
    -p 3005:3005/tcp \ # Opcional
    -p 8324:8324/tcp \ # Opcional
    -p 32469:32469/tcp \ # Opcional
    -p 1900:1900/udp \ # Opcional
    -p 32410:32410/udp \ # Opcional
    -p 32412:32412/udp \ # Opcional
    -p 32413:32413/udp \ # Opcional
    -p 32414:32414/udp \ # Opcional
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

***NOTA:*** *Debes reemplazar `Europe/Madrid` por tu zona horaria y las rutas
de los volúmenes `/docker/pms-plexdrive/...` por la que tienes en tu ordenador
(en caso no uses la misma estructura de carpetas). Si tienes los archivos de
configuración (`config.json` y ` token.json`) de una instalación anterior de
plexdrive, colocalos en la carpeta `docker/pms-plexdrive/config/.plexdrive`.*
<br/>
<br/>
<br/>

## *Primer uso y configuración inicial*
---

En la primer ejecución del contenedor (sin los archivos de configuración de una
instalación previa) debes ingresar dentro de la consola del contenedor. Luego
copiar, pegar y ejecutar el siguiente comando:

```bash
plexdrive mount -c ${HOME}/${PLEXDRIVE_CONFIG_DIR} --cache-file=${HOME}/${PLEXDRIVE_CONFIG_DIR}/cache.bolt -o allow_other ${PLEXDRIVE_MOUNT_POINT} {EXTRA_PARAMS}
```

Este comando iniciará un asistente de configuración:

- Solicitará tu `Client ID` y `Client Secret`
- Te mostrará un enlace para iniciar sesión con tu cuenta de Google Drive (la 
  que utilizaste para obtener los `Client ID` y `Client Secret`).
- El sitio web del enlace anterior, te mostrará un token que debes copiar y
  pegar en el terminal.
- Cuando completes el proceso, Plexdrive comienzará a almacenar en caché los
  archivos de tu cuenta de Google Drive en el segundo plano. No es necesario
  esperar a que Plexdrive complete su proceso inicial de creación de caché en
  esta consola. Ahora que los archivos `config.json` y ` token.json` fueron
  creados, puedes salir de la terminal (*Cntrl+C*).

***NOTA:*** *Si estas ejecutando este contenedor en una computadora remota
(fuera de la red local), se recomienda utilizar la variable de entorno
`PLEX_CLAIM` de la
[imagen Docker oficial PMS](https://github.com/plexinc/pms-docker) para vincular
este nuevo servidor a su propia cuenta en la primer ejecución.*
<br/>
<br/>
<br/>

## *Parámetros*
---

Estos parámetros, no son necesarios a menos que desees conservar la estructura de carpetas
actual o mantener permisos de archivo especiales.

- `PLEXDRIVE_CONFIG_DIR` Establece el nombre de la carpeta de configuración de
  Plexdrive que se encuentra dentro de la carpeta de configuración de PMS. El
  valor predeterminado es `.plexdrive`.
- `PLEXDRIVE_MOUNT_POINT` Establece el nombre del punto de montaje interno de
  Plexdrive. El valor predeterminado es `/home/Plex`.
- `CHANGE_PLEXDRIVE_CONFIG_DIR_OWNERSHIP` Define si el contenedor debe intentar 
  corregir los permisos de los archivos de configuración de Plexdrive existentes.
- `PLEX_UID` y `PLEX_GID` Establece el ID de usuario y el ID de grupo para el
  usuario de `Plex`. Útil si deseas que coincidan con los de su propio usuario 
  en el ordenador.
- `EXTRA_PARAMS` Permite agregar parámetros más avanzados para que plexdrive 
  pueda montar el comando inicial. Por ejemplo puedes utilizar:
  - `--drive-id=ABC123qwerty987` para montar un **Team Drive** con el 
  identificador `ABC123qwerty987`
  - `--root-node-id=DCBAqwerty987654321_ASDF123456789` para un montar solo el 
  subdirectorio con el identificador `DCBAqwerty987654321_ASDF123456789`
  - *[... Documentación de Plexdrive para más información ...](https://github.com/plexdrive/plexdrive#usage)*
  -  **IMPORTANTE:** *No es permitido utilizar los parámetros
  "`-v` `--verbosity`", "`-c` `--config`", "`--cache-file`" ó
  "`-o` `--fuse-options`", porque ya están en uso.*
<br/>
<br/>

***RECUERDA:*** *Todas las opciones del contenedor PMS oficial se heredan.
[Consulta la documentación de PMS para obtener más información](https://hub.docker.com/r/plexinc/pms-docker).*
<br/>
<br/>
<br/>

## ***Ejemplo de estructura de carpetas del host***
---

```bash
$ tree
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
<br/>
<br/>
<br/>

## *Etiquetas de Docker*
---

Las etiquetas corresponden a las del contenedor Docker oficial de PMS:

- `public` — Lanzamiento público de PMS.
- `beta` — Lanzamiento beta de PMS ***(Requiere Plex Pass)***.
- `latest` — Actualmente lo mismo que `public`.
