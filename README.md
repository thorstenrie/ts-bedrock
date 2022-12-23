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

