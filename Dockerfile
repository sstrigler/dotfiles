FROM sstrigler/shell:latest

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
ENV HOME=/home/zeank
# Add asdf to PATH, so it can be run in this Dockerfile
ENV PATH="$PATH:$HOME/.asdf/bin"

# Add asdf shims to PATH, so installed executables can be run in this Dockerfile
ENV PATH=$PATH:$HOME/.asdf/shims
RUN echo $PATH
RUN \
    asdf plugin add erlang; \
    asdf plugin add rebar; \
    asdf plugin add elixir; \
    asdf install

RUN \
    # configure git to get rid of detached head warnings
    git config --global advice.detachedHead false; \
    git clone https://github.com/erlang-ls/erlang_ls.git; \
    cd erlang_ls; make && PREFIX=$HOME make install

COPY --chown=zeank:zeank .spacemacs .spacemacs
COPY --chown=zeank:zeank .spacemacs.env .spacemacs.env

CMD PATH=$PATH:/home/zeank/bin:/home/zeank/.asdf/bin:/home/zeank/.asdf/shims /usr/bin/emacs-nox --daemon && /bin/zsh
