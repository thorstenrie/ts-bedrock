#!/bin/sh

# Build container image
sudo podman build --pull --no-cache -t bedrock ../bedrock/

# Start pod
sudo podman pod create \
    --name ts_bedrock_pod \
    --uidmap 0:"$TS_USERNS_MCBR":65536 \
    --gidmap 0:"$TS_USERNS_MCBR":65536 \
    --publish "$TS_PORT_MCBR_INC_EXT":"$TS_PORT_MCBR_INC_EXT"/udp \
    --publish "$TS_PORT_MCBR_AUTH_EXT":"$TS_PORT_MCBR_AUTH_EXT"/udp

# Start container with interactive bash shell in the container
sudo podman run --rm -it \
    --pod ts_bedrock_pod \
    --volume "$TS_MCBR_HOME"/server/worlds:/home/minecraft-bedrock/server/worlds \
    --volume "$TS_MCBR_HOME"/config:/home/minecraft-bedrock/config \
    --name mcbr \
    bedrock
