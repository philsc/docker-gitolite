FROM debian:wheezy
MAINTAINER Philipp Schrader <philipp.schrader@gmail.com>

RUN echo LANG=C >> /etc/profile

RUN apt-get update
RUN apt-get -y install openssh-server
RUN apt-get -y install git

RUN mkdir -p /var/run/sshd
ADD sshd_config /etc/ssh/sshd_config

RUN adduser --system --group --shell /bin/sh git
ADD id_rsa.pub /home/git/admin.pub
VOLUME ["/home/git/repositories", "/home/git/.gitolite"]

RUN su - git -c "mkdir bin"
RUN su - git -c "git clone git://github.com/sitaramc/gitolite"
RUN su - git -c "./gitolite/install -ln"

ADD gitolite-run /usr/local/bin/gitolite-run
RUN chmod +x /usr/local/bin/gitolite-run

ENTRYPOINT ["/usr/local/bin/gitolite-run"]
EXPOSE 22
