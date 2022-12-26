#!/bin/sh

# Do only once: create groups and users, create volume host folders, chown volume host folders
sudo groupadd -r --gid "$TS_UGID_MCBR" minecraft-bedrock
sudo useradd -r --uid "$TS_UGID_MCBR" --gid "$TS_UGID_MCBR" -s /usr/bin/nologin minecraft-bedrock
sudo mkdir -p "$TS_MCBR_HOME"/server/worlds
sudo mkdir "$TS_MCBR_HOME"/config
sudo chown -R "$TS_UGID_MCBR":"$TS_UGID_MCBR" "$TS_MCBR_HOME"
