ARG BASE_IMAGE=osrf/ros:humble-desktop
FROM ${BASE_IMAGE}

#basic utilities
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy \
  build-essential \
  software-properties-common \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  wget \
  cmake \
  cppcheck \
  gdb \
  git \
  git-lfs \
  ripgrep \
  gnupg2 \
  ssh \
  sudo \
  tmux \
  nano \
  neovim \
  locales

# Set Locale for ROS2
RUN locale-gen en_US en_US.UTF-8 && \
  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
  export LANG=en_US.UTF-8

# install rest of ROS humble
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy ros-humble-desktop

# common ros tools
RUN DEBIAN_FRONTEND=noninteractive apt update -qy \
  && DEBIAN_FRONTEND=noninteractive apt install -qy \
  python3-osrf-pycommon \
  python3-pip \
  python3-numpy \
  python3-psutil \
  python3-venv \
  python3-empy \
  python3-dbg \
  python3-colcon-common-extensions \
  python3-vcstool \
  python3-wstool \
  python3-rosdep \
  python3-colcon-common-extensions \
  python3-colcon-mixin \
  ros-humble-ament-clang-format \
  ros-humble-rviz-visual-tools \
  ros-humble-ros-testing \
  ros-humble-ros2test

# add gazebo
RUN /bin/sh -c 'wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg' \
 && /bin/sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null' \
 && apt update -qy \
 && apt install -qy \
 ros-humble-xacro \
 gz-garden

ENV GZ_VERSION garden

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

# RUN sudo -H pip3 install -U onnxruntime onnx

# Switch to user
USER "${user}"
WORKDIR "${home}"

# Initialize rosdep
RUN rosdep update

# RUN rosdep install -r --from-paths ~/**/src -i -y --rosdistro humble

# Add colcon mixins
RUN colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && colcon mixin update default && rm -rf log

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
