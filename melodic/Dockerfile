ARG BASE_IMAGE=ros:melodic-ros-base-bionic
FROM ${BASE_IMAGE}

#basic utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    bash-completion \
    curl \
    git \
    nano \
    ssh \
    sudo \
    tmux \
    neovim \
    wget

#install rest of ROS
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy ros-melodic-desktop-full

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    build-essential \
    python-catkin-tools \
    python-pip \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    python3-pip \
    python3-vcstool

ARG user
ARG uid
ARG home

# Clone user into docker image
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:/bin/bash" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}" && \
  mkdir -p "${home}" && chown "${user}:${user}" "${home}"

#basic config
COPY --chown=${uid}:${uid} bashrc "${home}/.bashrc"
COPY --chown=${uid}:${uid} bash_profile "${home}/.bash_profile"

#for getting dependencies run: rosdep install -s -r -i --from-paths src/

# dschubba dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    ffmpeg \
    python-pyside \
    python3-opencv \
    ros-melodic-joy \
    ros-melodic-sick-scan \
    ros-melodic-teleop-twist-joy \
    v4l-utils

RUN pip3 install -U \
    jinja2 \
    pygame \
    rospkg

# Switch to user
USER "${user}"
WORKDIR "${home}"

RUN mkdir -p "${home}/.config/nvim" && mkdir -p "${home}/.vim/tmp"
COPY --chown=${uid}:${uid} init.vim "${home}/.config/nvim/init.vim"

RUN rosdep update

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
