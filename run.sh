#!/usr/bin/env bash

set -e

if ((EUID != 0)); then
    echo "Please run this as root." >&2
    exit 1
fi

readonly BASE_DIR=/data/gitolite
readonly MOUNT_DIR=/home/git
readonly EXPORTED_PORT=46000

mkdir -p ${BASE_DIR}/repositories/
mkdir -p ${BASE_DIR}/settings/
chown root:root ${BASE_DIR}
chmod 770 ${BASE_DIR}

docker run \
    --name gitolite \
    -d \
    -p "${EXPORTED_PORT}:22" \
    -v "${BASE_DIR}/repositories:${MOUNT_DIR}/repositories" \
    -v "${BASE_DIR}/settings:${MOUNT_DIR}/.gitolite" \
    gitolite
