FROM ubuntu:14.04
MAINTAINER Philipp Schrader <philipp.schrader@gmail.com>

RUN apt-get update
RUN apt-get -y install openssh-server
RUN apt-get -y install git

RUN adduser --system --group --shell /bin/sh git
ADD id_rsa.pub /home/git/admin.pub

RUN su - git -c "mkdir bin"
RUN su - git -c "git clone git://github.com/sitaramc/gitolite"
RUN su - git -c "./gitolite/install -ln"
RUN su - git -c "./bin/gitolite setup -pk admin.pub"

RUN rm /home/git/admin.pub

RUN mkdir /var/run/sshd
ADD sshd_config /etc/ssh/sshd_config

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
EXPOSE 22
