docker-gitolite
===============
Docker container to run a gitolite instance.

1. Clone this repo

        git clone https://github.com/philsc/docker-gitolite.git

1. Copy the admin key into the directory

        cp ~/.ssh/id_rsa.pub ./docker-gitolite/

1. Build the docker container

        ./docker-gitolite/build.sh

1. Run the container to test

        sudo ./docker-gitolite/run.sh

1. Or install a startup script depending on your choice of init system.

        sudo ./docker-gitolite/install.sh upstart
        sudo ./docker-gitolite/install.sh systemd

