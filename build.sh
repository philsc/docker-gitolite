#!/usr/bin/env bash

readonly SCRIPT_PATH="${BASH_SOURCE[0]}"
readonly DIR_PATH="${SCRIPT_PATH%/*}"

pushd "${DIR_PATH}"
docker build --rm -t gitolite .
popd
