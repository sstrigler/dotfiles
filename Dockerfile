FROM ubuntu:oracular

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y locales && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm

# Common packages
RUN apt-get install -y \
      build-essential \
      curl \
      docker.io \
      emacs-nox \
      git \
      iputils-ping \
      jq \
      net-tools \
      netcat-openbsd \
      software-properties-common \
      tmux \
      tzdata \
      w3m \
      wget \
      zsh

RUN ["useradd", "-m", "-s", "/bin/zsh", "zeank"]

COPY . /home/zeank
RUN chown -R zeank:zeank /home/zeank
USER zeank
WORKDIR /home/zeank

RUN ls -lah
# Colors and italics for tmux
RUN tic $HOME/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

RUN rm -r $HOME/.emacs.d $HOME/.oh-my-zsh
RUN git config --global advice.detachedHead false;
RUN git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sed -i 's/plugins=(git)/plugins=(asdf git docker docker-compose github node npm pip python emacs mix)/' .zshrc
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
RUN echo ". $HOME/.asdf/asdf.sh" >> .zshrc
RUN echo ". $HOME/.asdf/asdf.sh" >> .bashrc
RUN /usr/bin/emacs-nox --daemon

CMD /bin/bash -lc '/usr/bin/emacs-nox --daemon' && /bin/zsh
