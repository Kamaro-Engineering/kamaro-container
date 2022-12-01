ARG BASE_IMAGE=kamaro:foxy
FROM ${BASE_IMAGE}

ARG uid
ARG home

RUN \
  mkdir -p ".terminfo/x/" \
  && wget "https://github.com/kovidgoyal/kitty/raw/master/terminfo/x/xterm-kitty" -O ".terminfo/x/xterm-kitty"

RUN \
  git clone --depth 1 https://github.com/junegunn/fzf.git ".fzf" \
  && ".fzf/install" --all

# running nvim locally in docker
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive sudo apt-get install -qy \
    fd-find \
    nodejs \
    npm \
    ripgrep

RUN mkdir -p "${home}/.config/nvim"
COPY --chown=${uid}:${uid} init.vim "${home}/.config/nvim/init.vim"

COPY --chown=${uid}:${uid} bashrc_custom ".bashrc_custom"
COPY --chown=${uid}:${uid} inputrc ".inputrc"
RUN echo "source ~/.bashrc_custom" >> ".bashrc"
