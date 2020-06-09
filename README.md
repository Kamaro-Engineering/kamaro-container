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
roslaunch dschubba_launch simulation.launch
```

Currently, you cannot access usb devices or cameras from the container. We might consider
running the container in privileged mode at some point.
[More Info](https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device)


## Development environment

Since the workspaces are just mapped into the container, you can of course still simply
program on your host machine using your favorite text editor and only use the container
for building and testing. However, if you want to use code-linting or a fully-fledged IDE,
those tools will at some point need to be aware of the build environment.

You have a few options for that:

#### Install your IDE inside the container

The probably easiest method is to just install your preferred IDE inside the container as
well as ROS. So you do not need to do this every time you rebuild your image/container
manually, you can define a custom image layer on top of the `kamaro:melodic`-image. To get
started, you can look at the build-configuration in `melodic-thomas/`.
That container could be created with the following:
```sh
./build-image.sh melodic-thomas/
./setup-container.sh -n melodic kamaro:melodic-thomas
```

It is important that you keep the same first two lines in your Dockerfile:
```
ARG BASE_IMAGE=kamaro:melodic
FROM ${BASE_IMAGE}
```
With that, `./build-image.sh` will automatically build the melodic image and your config on
top of it.

If your development setup is quite complex and has a lot of dependencies, installing it
inside the container might still not be really feasible. 

#### Using Visual Studio Codes Remote Development feature

If you use Microsofts VSCode, you can use its [Remote Development feature](https://code.visualstudio.com/remote-tutorials/containers/getting-started).
Be aware that that feature is only available in the proprietary version of vscode, and
not functional in the open source version.

#### Language Server

If your IDE is using/supports the language server protocol, another option is to only
install the language servers in the container, while still running the client IDE on the
host machine. Configuring this depends on your IDE/editor. The build-configuration in
`melodic-thomas/` for example installs the clangd and pyls language servers and contains
an `coc-settings.json` configuration for the [coc.nvim](https://github.com/neoclide/coc.nvim) VIM plugin.
Feel free to ask me (Thomas) for more info on this.


## Adding dependencies

While it is possible to install new dependencies directly in the container, those
dependencies will need to be manually reinstalled everytime when rebuilding the
image/container, or when someone else wants to install the container. Thats why new
dependencies should be added to the build-configuration as soon as possible. The
dependencies are currently configured in the `melodic/Dockerfile` in the accordingly
commented RUN command. It is considered good style to keep the packages to install
alphabetically ordered. Dependencies of different robots should be separated, as we
might want to create separate docker images for each robot in the future.

If the ros packages are configured correctly, you can use the rosdep. Run the following in
the workspace to get a list of required packages:
```sh
rosdep install -s -r -i --from-paths src/
```
If a package does still require more dependencies to run than rosdep shows, then, if
possible, fix its package.xml!
