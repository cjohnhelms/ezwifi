FROM ubuntu:latest
LABEL maintainer="Chris Helms <cjohnhelms@gmail.com>"

CMD ["tail", "-f", "/dev/null"]

RUN apt-get update && apt-get install -y sudo curl git python3 neofetch zsh wget vim
RUN useradd -ms /bin/bash cjohnhelms
USER cjohnhelms
WORKDIR /home/cjohnhelms

COPY dotfiles/vimrc /home/cjohnhelms/.vimrc
COPY dotfiles/gitconfig /home/cjohnhelms/.gitconfig
COPY dotfiles/bashrc /home/cjohnhelms/.bashrc

RUN ssh-keygen -q -N '' -f /home/cjohnhelms/.ssh/id_rsa

ENV TERM xterm
