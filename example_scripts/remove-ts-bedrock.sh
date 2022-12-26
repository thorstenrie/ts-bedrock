#!/bin/sh

# Make sure to stop the bedrock server and container before removing it.

# Remove pod
sudo podman pod rm ts_bedrock_pod

# Remove container images
sudo podman rmi archlinux
sudo podman rmi bedrock
