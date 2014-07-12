#!/usr/bin/env bash

readonly ADMIN_KEY=id_rsa.pub
readonly SCRIPT_PATH="${BASH_SOURCE[0]}"
readonly DIR_PATH="${SCRIPT_PATH%/*}"

if [[ ! -e "${DIR_PATH}/${ADMIN_KEY}" ]]; then
    echo "Please provide the admin key ${ADMIN_KEY} in ${DIR_PATH}."
    exit 1
fi

pushd "${DIR_PATH}"
docker build --rm -t gitolite .
popd
