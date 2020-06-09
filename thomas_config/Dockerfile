ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG uid

RUN \
  mkdir -p ".terminfo/x/" \
  && wget "https://github.com/kovidgoyal/kitty/raw/master/terminfo/x/xterm-kitty" -O ".terminfo/x/xterm-kitty"

RUN \
  git clone --depth 1 https://github.com/junegunn/fzf.git ".fzf" \
  && ".fzf/install" --all

#language servers
RUN sudo -H pip3 install -U python-language-server[pyflakes,yapf,rope]
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive sudo apt-get install -qy \
    clangd-9

COPY --chown=${uid}:${uid} bashrc_custom ".bashrc_custom"
COPY --chown=${uid}:${uid} inputrc ".inputrc"
RUN echo "source ~/.bashrc_custom" >> ".bashrc"
