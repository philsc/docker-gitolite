#!/usr/bin/env bash

readonly PORT=46000
readonly KEY_DIR="$(mktemp -d)"
readonly CLONE_DIR="$(mktemp -d)"

git clone ssh://git@localhost:$PORT/gitolite-admin.git "${CLONE_DIR}"

pushd "${CLONE_DIR}"

for ii in {1..10}; do
    echo "Generating public key $ii."
    ssh-keygen -t rsa -N '' -f "${WORK_DIR}"/id_rsa_"${ii}".pub

    cp "${WORK_DIR}"/id_rsa_"${ii}".pub ./keydir/john_"${ii}".pub

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

# Clean up
rm -rf "${KEY_DIR}" "${CLONE_DIR}"
