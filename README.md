# Kamaro Container

Docker containers for an easy, distribution-independent, and reproducible ROS development
environment.


## Getting started

First, you need to install and start docker according to your distro.
([Official instructions](https://docs.docker.com/engine/install/#server), [Arch Wiki](https://wiki.archlinux.org/index.php/Docker#Installation))
If you want to use a NVIDIA graphics card you need at least version 19.03 or
otherwise you need to additionally install [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-docker).

Adding your user to the `docker` group is optional, but might make working with the
container a bit smoother. If you [prefer not to](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface), prepend the following commands with
`sudo`.

#### Building an image

Docker containers are always based on an image. `melodic/` contains build instructions for an
image based on bionic, which will contain ROS and dependencies for our robot.

To build that image, simply run:
```
./build-image.sh
```
For more options and info run:
```
./build-image.sh -h
```

You will only need to build an image once and after updating the image description, for
example when adding more dependencies. The first build might take a while, but subsequent
builds will make use of dockers build cache and be much faster.

#### Creating a container

First, you need to configure the location of your catkin workspace(s) in the
`./workspaces` file. To then create a container from the image `kamaro:melodic`, run:
```sh
./setup-container.sh kamaro:melodic
```
Again, for more options and info run:
```sh
./setup-container.sh -h
```

This will create a container with your configured workspaces bound to the same paths in
the container. Again, you will only need to create the container once for each image.
Unlike the usual use case for docker where there is a new container spun up for each
command, when developing with ROS it is more useful to keep using the same semi-persistent
container for multiple commands.

#### Running your container

Once you have created a container you can start it with:
```sh
docker start melodic
```
And then open a terminal in it with:
```sh
docker exec -it melodic bash
```

You can also use the provided helper script `./con` to quickly open a terminal in your
container regardless of whether it is running or not. Install it to your PATH (e.g.
`/usr/local/bin/`) and `./con-completion.sh` to `/etc/bash_completion.d/` for bash
completion. (Bash completion requires your user to be in the `docker` group though.)

To stop the container run:
```sh
docker stop melodic
```

#### Running ROS

With a terminal open in the container, you can now use ROS as usual. If you only defined a
single workspace previously, that workspace should be already sourced. Otherwise you can
choose your workspace with the `rob` function defined in the containers bashrc. If you
have configured a robot ip as well and are in the same network as the robot, you can also
use `rob-remote` to control the robot remotely.

If you have set up Dschubbas workspace and have built it, you can try out the simulation:
```sh
roslaunch  dschubba_launch simulation.launch
```

Currently, you cannot access usb devices or cameras from the container. We might consider
running the container in privileged mode at some point.
[More Info](https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device)


## Development environment

TODO

## Adding dependencies

TODO

