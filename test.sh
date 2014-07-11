#!/usr/bin/env bash

set -x
set -e
set -u

readonly PORT=46000
readonly KEY_DIR="$(mktemp -d)"
readonly CLONE_DIR="$(mktemp -d)"

function kill_instances()
{
    local instance="$(docker ps | grep gitolite | awk '{print $1}')"
    [[ -n "$instance" ]] && docker kill "$instance" || :
}

# Kill the current gitolite container if it's running.
kill_instances

sudo ./run.sh

sleep 5

git clone ssh://git@localhost:$PORT/gitolite-admin.git "${CLONE_DIR}"

pushd "${CLONE_DIR}"

for ii in {1..10}; do
    echo "Generating public key $ii."
    ssh-keygen -t rsa -N '' -f "${KEY_DIR}"/id_rsa_"${ii}"
    chmod 400 "${KEY_DIR}"/id_rsa_"${ii}"*

    cp "${KEY_DIR}"/id_rsa_"${ii}".pub ./keydir/john_"${ii}".pub

    # Create a new test repo for each user as well.
    cat >> conf/gitolite.conf <<EOT

repo  testing_${ii}
    RW+ = admin john_${ii}
EOT
done

# Commit all the keys.
git add .
git commit -m "Setting up test repos."
git push origin master

popd

# Login as every one of those generated users.
for ii in {1..10}; do
    ssh -i "${KEY_DIR}"/id_rsa_"${ii}".pub -p ${PORT} git@localhost
done

# Clean up
rm -rf "${KEY_DIR}" "${CLONE_DIR}"

kill_instances
