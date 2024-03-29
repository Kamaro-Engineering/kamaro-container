ARG BASE_IMAGE=ros:melodic-ros-base-bionic
FROM ${BASE_IMAGE}

# Based on:
# https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event/competition_environment/a_container/Dockerfile

#Competition dependencies
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  apt-get update && \
  apt-get -y install ros-melodic-desktop-full ros-melodic-pointgrey-camera-description && \
  apt-get -y install ros-melodic-robot-localization ros-melodic-twist-mux && \
  apt-get -y install ros-melodic-interactive-marker-twist-server ros-melodic-hector-gazebo-plugins && \
  apt-get -y install git screen python-pip python3-pip && \
  rm -rf /var/lib/apt/lists/*
RUN pip install -U pip && pip3 install -U pip
RUN pip install -U jinja2 rospkg
RUN pip3 install numpy jinja2 rospkg opencv-python matplotlib shapely

#Plain gazebo requirements
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  apt-get update && \
  apt-get -y install ros-melodic-gazebo-ros-pkgs && \
  apt-get -y install ros-melodic-gazebo-ros-control && \
  rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
  DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install ros-melodic-urdfdom-py

#Make the code required for the container and add it to the entrypoint
RUN mkdir -p /catkin/src && cd /catkin/src && git clone https://github.com/FieldRobotEvent/Virtual_Field_Robot_Event.git && rm -rf Virtual_Field_Robot_Event/example_robot
RUN bash -c "source /opt/ros/melodic/setup.bash && cd /catkin && catkin_make"
RUN sed -i 's|^\(source .*\)|\1 \&\& source /catkin/devel/setup.bash|g' /ros_entrypoint.sh

#Map volume location
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/map"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/Media"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/worlds"]
VOLUME ["/catkin/src/Virtual_Field_Robot_Event/virtual_maize_field/launch"]
VOLUME ["/catkin/src/my_robot"]
VOLUME ["/tmp/.X11-unix"]
VOLUME ["/tmp/.docker.xauth"]

EXPOSE 8080 11345

ENV XAUTHORITY=/tmp/.docker.xauth
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1

# Launch the simulation
# task 1 and 2
CMD sh -c "roslaunch virtual_maize_field jackal_simulation.launch paused:=true"
