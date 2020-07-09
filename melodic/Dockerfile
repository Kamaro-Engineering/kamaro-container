ARG BASE_IMAGE=ros:melodic-ros-base-bionic
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

RUN pip3 install -U \
      jupyter

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


#install up-to-date cmake from kitwares repos
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
      gpg --dearmor - > /etc/apt/trusted.gpg.d/kitware.gpg \
  && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
  && DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
  && cmake

# beteigeuze dependencies TODO
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qy \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    ros-melodic-rosserial-client
#RUN pip3 install -U \
#    ...

# Switch to user
USER "${user}"
WORKDIR "${home}"

RUN rosdep update

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

CMD ["/bin/bash", "-i"]
