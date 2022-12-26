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

Clone the git repository with:

    git clone https://github.com/thorstenrie/ts-bedrock.git
    
Three options to get it running:

- **Build & run with the Quick Start Guide**: Run the container with minimal effort by using provided example scripts
*(Warning: only recommended for development environments!)*
- **Build & run with the Setup Guide**: Follow each step of the setup guide and adapt it to your needs
- **Directly pull the container image**: Follow the Readme on [docker.io/thorstenrie/ts-bedrock](https://hub.docker.com/repository/docker/thorstenrie/ts-bedrock) (fixed world generation seed and container building not needed)

## Prerequisites

The container is build and tested with [Podman](https://podman.io/). To complete the guide, [Podman](https://podman.io/) on a x86-64 Linux system and root access is required.

The container is expected to also run with Docker. To complete the guide with Docker, adaptations are needed.
- To build the container image with Docker: Rename [Containerfile](https://github.com/thorstenrie/ts-bedrock/blob/main/bedrock/Containerfile) to `Dockerfile` and [substitute](https://podman.io/whatis.html) `podman` commands with `docker` commands. Further adaptations may be necessary.
- To complete the guide and run the container with docker: [Substitute](https://podman.io/whatis.html) the `podman` commands with `docker` commands, omit the [podman pod create](https://docs.podman.io/en/latest/markdown/podman-pod-create.1.html) command, instead add the `--publish` flags to the `docker run` command. Further adaptations may be necessary.

Memory usage is ~128 MB in idle with no players ever connected and easily reaches 300 MB+ with one player exploring a small area playing for a few minutes. A 2+ GB available RAM, a SSD and at least a quad core CPU with 3 GHz+ is recommended for a good server experience with a handful of players.

## Network Setup

To run properly, two ports are needed: 

- `UDP port 19132 (IPv4) / 19133 (IPv6)`: listening for incoming connections
- `UDP port 43351 (IPv4) / 51885 (IPv6)`: authentication

Note: To keep the guide simple, the rest of the guide will be assuming a IPv4 server address. For IPv6 servers, please substitute the ports.

The ports need to be opened and forwarded in routers and firewalls with the corresponding UDP protocol. Check your hardware and software documentation on how to open and forward ports. For example, if you use [ufw](https://launchpad.net/ufw) as firewall, you could run as root

    # ufw route allow proto udp to any port 19132
    # ufw route allow proto udp to any port 43351

Additionally, both ports need to be published with the container or pod. With [podman-run](https://docs.podman.io/en/latest/markdown/podman-run.1.html) and [podman-pod-create](https://docs.podman.io/en/latest/markdown/podman-pod-create.1.html), this can be done by using the `--publish` flag.

## Server Configuration Files

Server configuration files can be stored in the container `config` directory `/home/minecraft-bedrock/config`. Before the server is launched the supported configuration files are copied into the server directory. Supported configuration files are `server.properties`, `allowlist.json` and `permissions.json`.

To load server configuration files from the host system, a bind mount mapping is needed mapping the container `config` directory in the container to a defined directory on the host system. Therefore, the `config` directory needs to be created in the container and in the host system.

- For the container, the directory will be automatically created in the container build.
- For the host system, you need to define and create it by yourself.

First, create an environment variable, holding the main host system bedrock server directory path, e.g., `/srv/bedrock`

        $ export TS_MSBR_HOME=/srv/bedrock

Afterwards, create the directory, e.g.,

        # mkdir -p "$TS_MSBR_HOME"/config

With the `--volume` flag, the container `config` directory can be mapped to the host `config` directory.

## Worlds

Every created world has a folder in the `worlds` container directory `/home/minecraft-bedrock/server/worlds`. The world folders are named according to their `level-name` inside the `server.properties` file. To persist worlds independent of the container lifecycle, a bind mount mapping is needed mapping the container `worlds` directory in the container to a defined directory on the host system. Therefore, the `worlds` directory needs to be created in the container and in the host system.

- For the container, the directory will be automatically created in the container build.
- For the host system, you need to define and create it by yourself.

First, create an environment variable, holding the main host system bedrock server directory path, e.g., `/srv/bedrock`

        $ export TS_MSBR_HOME=/srv/bedrock

Afterwards, create the directory, e.g.,

        # mkdir -p "$TS_MSBR_HOME"/server/worlds

With the `--volume` flag, the container `worlds` directory can be mapped to the host `worlds` directory.

## Non-root system user

Within the container, the bedrock client will be executed by a non-root system user with username `minecraft-bedrock` in group `minecraft-bedrock`. The user is also required to be existent on the host system to actually store downloaded files in the bind mount.

- For the container, the user will be automatically created in the container build
- For the host system, you need to create the user, group and change the owner of `$TS_MSBR_HOME`
- It is recommended, for security reasons, to have a new user namespace for the container, which is mapped to host system uid and gid ranges. Multiples of 2^16 with size 2^16 are a reasonable mapping on the host system uid and gid ranges. As example, container uid and gid `0` to `65535` can be mapped to the host system starting with uid and gid `524288` (and size `65536`)
- In this case, the rtorrent uid and gid on the host system is different from the uid and gid in the container. On the host system, the rtorrent uid and gid must correspond to the user namespace mapping.
- In the following, the above mapping is assumed. Therefore, on the host system, rtorrent uid and gid is `524955` (524288 + 667). In the container, rtorrent uid and gid is `667`.

To create the group and user on the host system, run

    # groupadd -r --gid 524955 minecraft-bedrock
    # useradd -r --uid 524955 --gid 524955 -s /usr/bin/nologin minecraft-bedrock
    
Next, change the owner of `$TS_MSBR_HOME` to the new user

    # chown -R 524955:524955 "$TS_MSBR_HOME"
    
With the `--uidmap 0:524288:65536` and `--gidmap 0:524288:65536` flags, the container gids and uids are mapped on the corresponding host gids and uids, as defined in the example above.




