#!/bin/sh

# Export LD_LIBRARY_PATH
export LD_LIBRARY_PATH=.

# Launch bedrock server
exec ./bedrock_server
