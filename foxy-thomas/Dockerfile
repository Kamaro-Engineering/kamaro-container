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

# up-to-date nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
# up-to-date nvim
RUN sudo add-apt-repository ppa:neovim-ppa/stable

# running nvim locally in docker
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive sudo apt-get install -qy \
    ctags \
    fd-find \
    nodejs \
    neovim \
    ripgrep

RUN mkdir -p ${home}/.local/bin \
  && ln -s $(which fdfind) ${home}/.local/bin/fd

COPY --chown=${uid}:${uid} bashrc_custom ".bashrc_custom"
COPY --chown=${uid}:${uid} rg_default_ignore "${home}/.config/rg_default_ignore"
COPY --chown=${uid}:${uid} inputrc ".inputrc"
RUN echo "source ~/.bashrc_custom" >> ".bashrc"
