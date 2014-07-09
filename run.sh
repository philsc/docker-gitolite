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
chown root:root ${BASE_DIR}
chmod 770 ${BASE_DIR}

docker run \
    -d \
    -p "${EXPORTED_PORT}:22" \
    -v "${BASE_DIR}/repositories:${MOUNT_DIR}/repositories" \
    gitolite