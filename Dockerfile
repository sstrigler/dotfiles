FROM sstrigler/shell

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm

USER root

RUN apt-get install -y \
    automake \
    libssl-dev \
    libncurses-dev \
    unzip

USER zeank
WORKDIR /home/zeank

SHELL ["/bin/bash", "-lc"]
RUN asdf plugin add erlang
RUN asdf plugin add rebar
RUN asdf plugin add elixir

RUN asdf install

RUN \
    # configure git to get rid of detached head warnings
    git config --global advice.detachedHead false; \
    git clone https://github.com/erlang-ls/erlang_ls.git; \
    cd erlang_ls; make && PREFIX=$HOME make install

CMD /bin/bash -lc '/usr/bin/emacs-nox --daemon' && /bin/zsh
