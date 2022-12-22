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
- **Directly pull the container image**: Follow the Readme on [docker.io/thorstenrie/ts-bedrock](https://hub.docker.com/repository/docker/thorstenrie/ts-bedrock) (fixed seed and container building not needed)

