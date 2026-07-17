## Overview

A development environment in a podman container. Heavily adapted from
[jonaslind/devenv](https://github.com/jonaslind/devenv).

## Usage

On the host machine:

    # build container
    podman build --tag devbox --format docker .

    # edit ./devbox-run.sh to add/update --volume flags
    # the container (see the `--volume` flag).

    # run container, which starts an interactive bash session from the container
    ./devbox-run.sh

    # attach to the container
    podman attach -l

Once you see the container's shell:

    tmux -2u

Then, get to work.

To detach from the container (while leaving it running): `<ctrl>+p, <ctrl>+q`

Later, re-attach with `podman attach -l` to resume working.

## IMPORTANT NOTES

- During build, the container generates a new keypair for use with github. You
  must add the container's `~/.ssh/id_ed25519_github.pub` to your github account
  to use it.

## TODO

- [ ] bug: why does `--userns keep-id` take forever on run?
- [ ] later: docs for running X/Wayland programs
  - [ ] install jetbrains mono nerd font
