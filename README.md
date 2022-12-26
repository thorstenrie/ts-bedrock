# ts-bedrock

[![CodeFactor](https://www.codefactor.io/repository/github/thorstenrie/ts-bedrock/badge)](https://www.codefactor.io/repository/github/thorstenrie/ts-bedrock)
![OSS Lifecycle](https://img.shields.io/osslifecycle/thorstenrie/ts-bedrock)

![Docker Pulls](https://img.shields.io/docker/pulls/thorstenrie/ts-bedrock)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/thorstenrie/ts-bedrock)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/thorstenrie/ts-bedrock)

![GitHub release (latest by date)](https://img.shields.io/github/v/release/thorstenrie/ts-bedrock)
![GitHub last commit](https://img.shields.io/github/last-commit/thorstenrie/ts-bedrock)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/thorstenrie/ts-bedrock)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/thorstenrie/ts-bedrock)
![GitHub Top Language](https://img.shields.io/github/languages/top/thorstenrie/ts-bedrock)
![GitHub](https://img.shields.io/github/license/thorstenrie/ts-bedrock)

Minecraft [Bedrock dedicated server](https://www.minecraft.net/en-us/download/server/bedrock) container based on [Archlinux](https://archlinux.org/) that tries to keep it simple ([KISS principle](https://en.wikipedia.org/wiki/KISS_principle)). One purpose could be to play Minecraft with family and friends on a self-hosted Minecraft bedrock server. After the network and container setup is completed, just share the address of your server with your family and friends. They can login to your server using the address with their bedrock client.

- **Security**: the Bedrock server is run from a non-root system user, ready and recommended to be run in a new user namespace
- **Functionality**: the Bedrock server is pre-configured for use on a home/self-hosted server
- **Easy setup**: Use the example shell scripts for an easy start to launch the container and start playing Minecraft
- **Easy use**: Connect to the server address (e.g., IP) and server port (default `19132`) in minecraft and start playing

Three options to get it running:

- **Build & run with the Quick Start Guide**: Run the container with minimal effort by using provided example scripts
*(Warning: only recommended for development environments!)*
- **Build & run with the Setup Guide**: Follow each step of the setup guide and adapt it to your needs
- **Directly pull the container image**: Follow the Readme on [docker.io/thorstenrie/ts-bedrock](https://hub.docker.com/repository/docker/thorstenrie/ts-bedrock) (fixed world generation seed and container building not needed)

Clone the git repository with:

    git clone https://github.com/thorstenrie/ts-bedrock.git

## Prerequisites

The container is build and tested with [Podman](https://podman.io/). To complete the guide, [Podman](https://podman.io/) on a x86-64 Linux system and root access is required.

The container is expected to also run with Docker. To complete the guide with Docker, adaptations are needed.
- To build the container image with Docker: Rename [Containerfile](https://github.com/thorstenrie/ts-bedrock/blob/main/bedrock/Containerfile) to `Dockerfile` and [substitute](https://podman.io/whatis.html) `podman` commands with `docker` commands. Further adaptations may be necessary.
- To complete the guide and run the container with docker: [Substitute](https://podman.io/whatis.html) the `podman` commands with `docker` commands, omit the [podman pod create](https://docs.podman.io/en/latest/markdown/podman-pod-create.1.html) command, instead add the `--publish` flags to the `docker run` command. Further adaptations may be necessary.

Memory usage is ~128 MB in idle with no players ever connected and easily reaches 300 MB+ with one player exploring a small area playing for a few minutes. A 2 GB+ available RAM, a SSD and at least a quad core CPU with 3 GHz+ is recommended for a good server experience with a handful of players.

## Network setup

To run properly, two ports are needed: 

- `UDP port 19132 (IPv4) / 19133 (IPv6)`: listening for incoming connections
- `UDP port 43351 (IPv4) / 51885 (IPv6)`: authentication

Note: To keep the guide simple, the rest of the guide will be assuming a IPv4 server address. For IPv6 servers, please substitute the ports.

The ports need to be opened and forwarded in routers and firewalls with the corresponding UDP protocol. Check your hardware and software documentation on how to open and forward ports. For example, if you use [ufw](https://launchpad.net/ufw) as firewall, you could run as root

    # ufw route allow proto udp to any port 19132
    # ufw route allow proto udp to any port 43351

Additionally, both ports need to be published with the container or pod. With [podman-run](https://docs.podman.io/en/latest/markdown/podman-run.1.html) and [podman-pod-create](https://docs.podman.io/en/latest/markdown/podman-pod-create.1.html), this can be done by using the `--publish` flag.

## Quick start with example scripts

> Use the example scripts with caution and only in a development environment. The scripts create directories and a non-root system user, therefore change the host system.

> Requires `sudo`: Some commands need root user rights and therefore are preceded with `sudo`

> It is recommended to check the scripts before executing them to prevent unwanted behavior

1. Change your current directory to `example_scripts`

        $ cd example_scripts

1. Configure a new environment variable `$TS_MCBR_HOME` pointing to the directory where config files and worlds are stored, e.g., 

        $ export TS_MCBR_HOME=/srv/bedrock
        
1. Configure a new environment variable `$TS_USERNS_MCBR` for the new container user namespace (on most platforms as 32-bit unsigned integer). The uid and gid in the container starting with `0` (root) are mapped to uid and gid starting with `$TS_USERNS_MCBR` on the host system. Following uids and gids are mapped consecutively. It is recommended to run the container in such of a new user namespace mapped to the host system. The mapping on the host system starts with uid and gid `$TS_USERNS_MCBR`, e.g.,

        $ export TS_USERNS_MCBR=1966080
        
1. Configure a new environment variable `$TS_UGID_MCBR`. It must be `$TS_USERNS_MCBR` + 667 and is the target uid and gid of the minecraft-bedrock user on the host system, e.g., 

        $ export TS_UGID_MCBR=1966747

2. Run the setup script once to set up your system by creating the config and worlds directories, a non-root system user and group `minecraft-bedrock` with `UID` and `GID` defined by `$TS_UGID_MCBR`

        $ ./setup-ts-bedrock.sh
        
3. Run the start script to start a pod, the container and an interactive bash shell to the bedrock server. The config and worlds directories are mounted into the container

        $ ./start-ts-bedrock.sh
        
4. To stop the bedrock server, execute

        $ stop

in the interactive bash shell.
        
5. To stop the pod and container, execute

        $ ./stop-ts-bedrock.sh
        
6. To remove all container images, run

        $ ./remove-ts-bedrock.sh

## Setup guide & execution

### Server configuration files

Server configuration files can be stored in the container `config` directory `/home/minecraft-bedrock/config`. Before the server is launched the supported configuration files are copied into the server directory. Supported configuration files are `server.properties`, `allowlist.json` and `permissions.json`. Example configuration files can be found in [example_config](https://github.com/thorstenrie/ts-bedrock/tree/main/example_config)

To load server configuration files from the host system, a bind mount mapping is needed mapping the container `config` directory in the container to a defined directory on the host system. Therefore, the `config` directory needs to be created in the container and in the host system.

- For the container, the directory will be automatically created in the container build.
- For the host system, you need to define and create it by yourself.

First, create an environment variable, holding the main host system bedrock server directory path, e.g., `/srv/bedrock`

        $ export TS_MCBR_HOME=/srv/bedrock

Afterwards, create the directory, e.g.,

        # mkdir -p "$TS_MCBR_HOME"/config

With the `--volume` flag, the container `config` directory can be mapped to the host `config` directory: `--volume "$TS_MCBR_HOME"/config:/home/minecraft-bedrock/config`

### Worlds

Every created world has a folder in the `worlds` container directory `/home/minecraft-bedrock/server/worlds`. The world folders are named according to their `level-name` inside the `server.properties` file. To persist worlds independent of the container lifecycle, a bind mount mapping is needed mapping the container `worlds` directory in the container to a defined directory on the host system. Therefore, the `worlds` directory needs to be created in the container and in the host system.

- For the container, the directory will be automatically created in the container build.
- For the host system, you need to define and create it by yourself.

First, create an environment variable, holding the main host system bedrock server directory path, e.g., `/srv/bedrock`

        $ export TS_MCBR_HOME=/srv/bedrock

Afterwards, create the directory, e.g.,

        # mkdir -p "$TS_MCBR_HOME"/server/worlds

With the `--volume` flag, the container `worlds` directory can be mapped to the host `worlds` directory: `--volume "$TS_MCBR_HOME"/server/worlds:/home/minecraft-bedrock/server/worlds`

### Non-root system user

Within the container, the bedrock client will be executed by a non-root system user with username `minecraft-bedrock` in group `minecraft-bedrock`. The user is also required to be existent on the host system to actually store config and worlds files in the bind mount.

- For the container, the user will be automatically created in the container build
- For the host system, you need to create the user, group and change the owner of `$TS_MCBR_HOME`
- It is recommended, for security reasons, to have a new user namespace for the container, which is mapped to host system uid and gid ranges. Multiples of 2^16 with size 2^16 are a reasonable mapping on the host system uid and gid ranges. As example, container uid and gid `0` to `65535` can be mapped to the host system starting with uid and gid `1966080` (and size `65536`)
- In this case, the minecraft-bedrock uid and gid on the host system is different from the uid and gid in the container. On the host system, the minecraft-bedrock uid and gid must correspond to the user namespace mapping.
- In the following, the above mapping is assumed. Therefore, on the host system, minecraft-bedrock uid and gid is `1966747` (1966080 + 667). In the container, minecraft-bedrock uid and gid is `667`.

To create the group and user on the host system, run

    # groupadd -r --gid 1966747 minecraft-bedrock
    # useradd -r --uid 1966747 --gid 1966747 -s /usr/bin/nologin minecraft-bedrock
    
Next, change the owner of `$TS_MCBR_HOME` to the new user

    # chown -R 1966747:1966747 "$TS_MCBR_HOME"
    
With the `--uidmap 0:1966080:65536` and `--gidmap 0:1966080:65536` flags, the container gids and uids are mapped on the corresponding host gids and uids, as defined in the example above.

### Build the container image

The container image `bedrock` is build with [podman-build](https://docs.podman.io/en/latest/markdown/podman-build.1.html). With the flags `--pull` and `--no-cache` it explicitely requires the base image to be pulled from the registry and build from start.

    # podman build --pull --no-cache -t bedrock ./bedrock/

### Create a pod

The container will be launched in a pod [1](https://kubernetes.io/docs/concepts/workloads/pods/) [2](https://developers.redhat.com/blog/2019/01/15/podman-managing-containers-pods). Here, we will create a new pod named `ts_bedrock_pod`. To enable the bedrock server in the container to use the required ports, they have to be published to the host.

    # podman pod create \
        --name ts_bedrock_pod \
        --uidmap 0:1966080:65536 \
        --gidmap 0:1966080:65536 \
        --publish 19132:19132/udp \
        --publish 43351:43351/udp

### Launch the container

With [podman-run](https://docs.podman.io/en/latest/markdown/podman-run.1.html), the bedrock server is launched in container `mcbr` in pod `ts_bedrock_pod`. With the `--volume` flags, the config and worlds directories bind mounts are used.

        # podman run --rm -it \
            --pod ts_bedrock_pod \
            --volume "$TS_MCBR_HOME"/config:/home/minecraft-bedrock/config \
            --volume "$TS_MCBR_HOME"/server/worlds:/home/minecraft-bedrock/server/worlds \
            --name mcbr \
            bedrock
            
- With `--rm` the container will be removed when it exits.
- With `-it` a pseudo-TTY is allocated and connected to the container’s stdin, so that an interactive bash shell in the container is created. It can be used to execute commands on the bedrock server.
- With `-d` instead of `-it`, the container is run in the background. To attach to the container and execute commands on the bedrock server, use `# podman attach mcbr`

The container automatically starts the bedrock server using the configuration files in `/home/minecraft-bedrock/config`.

### Execute commands and stop the bedrock server

- If the container is run with an interactive bash shell (`-it`) just type in the server command and press Enter.
- If the container is run detached in the background(`-d`), first attach to the container with `# podman attach mcbr`, then  type in the server command and press Enter.
- It is recommended to gracefully stop the bedrock server with the server command `stop`. The bedrock server will quit and the container will be stopped.

### Stop the pod and remove all

The following commands stop the pod, stop all containers in the pod, and remove the pod, container and container images. It is recommended to first gracefully stop the bedrock server with the server command `stop` before stopping the pod.

    # podman pod stop ts_bedrock_pod
    # podman pod rm ts_bedrock_pod
    # podman container rm mcbr
    # podman rmi archlinux
    # podman rmi bedrock

## Maintainance

- The container will be kept up to date in this repository to support the latest Minecraft Bedrock version.
- For switching to another version manually, `ARG VER_BUILD=<version>` in the [Containerfile](https://github.com/thorstenrie/ts-bedrock/blob/main/bedrock/Containerfile) has to be changed to the desired version.
- In the sense of the Arch Linux rolling-release model, it is recommended to rebuild the container image frequently, e.g., based on time periods, like weekly, or every time it is launched. This ensures that the container stays up-to-date with latest updates making full use of the rolling-release model of Arch Linux.

## Known Limitations & Issues

- The container does not support resource or behavior packs (yet).
