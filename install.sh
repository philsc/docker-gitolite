#!/usr/bin/env bash

function install_upstart_conf()
{
    cat > /etc/init/gitolite.conf <<EOT
description "Gitolite container"
author "${USER}"
start on filesystem and started docker.io
stop on runlevel [!2345]
respawn
script
  /usr/bin/docker start -a gitolite
end script
EOT
}

function install_systemd_conf()
{
    cat > /usr/lib/systemd/system/gitolite.service <<EOT
[Unit]
Description=Gitolite container
Author=${USER}
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a gitolite
ExecStop=/usr/bin/docker stop -t 2 gitolite

[Install]
WantedBy=local.target
EOT
}

function main()
{
    case "$1" in
        upstart)
            install_upstart_conf
            ;;
        systemd)
            install_systemd_conf
            ;;
        *)
            echo "Please run with either 'upstart' or 'systemd' argument." >&2
            exit 1
            ;;
    esac
}

function check_permissions()
{
    if ((EUID != 0)); then
        echo "Please run this script with root permissions." >&2
        exit 1
    fi
}

check_permissions
main "$@"
