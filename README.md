## Overview

A development environment in a podman container. Heavily adapted from
[jonaslind/devenv](https://github.com/jonaslind/devenv).

## Usage

On the host machine:

    # build container
    podman build \
      --tag devbox \
      --format docker \
      --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
      --build-arg USERID="$(id -u)" \
      --build-arg GROUPID="$(id -g)" \
      .

    # allow local connections to host's X server
    xhost +local:

    # run container, which starts a gnome-terminal from the container
    podman run \
      --replace \
      --network host \
      --hostname devbox.local \
      --name devbox \
      --userns keep-id \
      --env DISPLAY=:0 \
      --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
      --volume /home/$USER/work:/home/ubuntu/work:z \
      --volume /home/$USER/Downloads:/home/ubuntu/Downloads:ro \
      devbox

Once you see the gnome-terminal for the container:

    cd && tmux

Then, get to work.

## TODOs

- map ports to host (ie, podman run --publish 3000-8999:3000-8999 ...)
