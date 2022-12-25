#!/bin/sh

# Unzip bedrock server
unzip -q ../bedrock-server.zip -d .
rm ../bedrock-server.zip

# Copy custom config files, if any
for f in ../config/{server.properties,permissions.json,allowlist.json}
do
    if [ -e "$f" ]
        then cp "$f" .
    fi
done

# Export LD_LIBRARY_PATH
export LD_LIBRARY_PATH=.

# Launch bedrock server
exec ./bedrock_server
