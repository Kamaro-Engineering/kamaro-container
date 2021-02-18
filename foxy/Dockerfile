ARG BASE_IMAGE=kamaro:nvidia-fox-base
FROM ${BASE_IMAGE}

#basic utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    gdb \
    git \
    gnupg \
    nano \
    software-properties-common \
    ssh \
    sudo \
    tmux \
    neovim \
    wget

#install rest of ROS noetic
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy ros-noetic-desktop-full

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    build-essential \
    python3-catkin-tools \
    python3-osrf-pycommon \
    python3-pip \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-vcstool \
    python3-wstool

RUN rosdep init

ARG user
ARG uid
ARG home

# Clone user into docker image
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:/bin/bash" >> /etc/passwd && \
  echo "${user}:*:18572:0:99999:7:::" >> /etc/shadow && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}" && \
  mkdir -p "${home}" && chown "${user}:${user}" "${home}"

#basic config
COPY --chown=${uid}:${uid} bashrc "${home}/.bashrc"
COPY --chown=${uid}:${uid} bash_profile "${home}/.bash_profile"

#for getting dependencies run: rosdep install -s -r -i --from-paths src/
# virtualfre dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    libceres-dev \
    libgflags-dev \
    libgmock-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    ninja-build \
    python3-pygame \
    ros-noetic-amcl \
    ros-noetic-gmapping \
    ros-noetic-hector-gazebo-plugins \
    ros-noetic-hector-trajectory-server \
    ros-noetic-joy \
    ros-noetic-map-server \
    ros-noetic-move-base \
    ros-noetic-pcl-conversions \
    ros-noetic-pointgrey-camera-description \
    ros-noetic-robot-localization \
    ros-noetic-rosdoc-lite \
    ros-noetic-twist-mux \
    stow

# Switch to user
USER "${user}"
WORKDIR "${home}"

RUN rosdep update

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
