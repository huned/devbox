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
      --network host \
      --hostname devbox.local \
      --name devbox \
      --userns keep-id \
      --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
      --volume /home/$USER/work:/home/ubuntu/work:z \
      --volume /home/$USER/Downloads:/home/ubuntu/Downloads:ro \
      --interactive --tty \
      devbox /bin/bash

Once you see the container's shell:

    tmux -2u

Then, get to work.

To detach from the container (while leaving it running): `CTRL-P, CTRL-Q`

## TODO

- run `ollama pull qwen3:4b` in Dockerfile
