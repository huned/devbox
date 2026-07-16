## Overview

A development environment in a podman container. Heavily adapted from
[jonaslind/devenv](https://github.com/jonaslind/devenv).

## Usage

On the host machine:

    # build container
    podman build --tag devbox --format docker .

    # run container, which starts an interactive bash session from the container
    podman run \
      --network host \
      --hostname devbox.local \
      --name devbox \
      --userns keep-id \
      --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
      --volume /home/$USER/work:/home/ubuntu/work:ro \
      --volume /home/$USER/Downloads:/home/ubuntu/Downloads:ro \
      --interactive --tty \
      devbox /bin/bash

Once you see the container's shell:

    tmux -2u

Then, get to work.

To detach from the container (while leaving it running): `<ctrl>+p, <ctrl>+q`

Later, re-attach with `podman attach -l` to resume working.

## TODO

- [ ] bug: why does `--userns keep-id` take forever on run?
- [ ] docs for running X/Wayland programs
  - [ ] install jetbrains mono nerd font
