# syntax=docker.io/docker/dockerfile:1.17
# shellcheck shell=bash

FROM mcr.microsoft.com/azure-storage/azurite:3.34.0

RUN <<'EOF'
#!/bin/sh
set -eux
# XXX disable access token validation.
# NB this allows anyone to access.
sed -i -E \
  's,(async validate.+),\1 return true;,g' \
  /opt/azurite/dist/src/blob/authentication/BlobSharedKeyAuthenticator.js
EOF
