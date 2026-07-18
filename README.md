## Overview

A development environment in a podman container. Heavily adapted from
[jonaslind/devenv](https://github.com/jonaslind/devenv).

## Usage

On the host machine:

    # build image
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

- To avoid slow first-run startup, configure podman to use fuse-overlayfs by
  creating `~/.config/containers/storage.conf`:

      [storage]
      driver = "overlay"

      [storage.options.overlay]
      mount_program = "/usr/bin/fuse-overlayfs"

  Without this, `--userns=keep-id` triggers a slow recursive chown of the
  container image on first run.

## TODO

- [ ] check hashes of stuff I'm installing :(
- [ ] later: docs for running X/Wayland programs
  - [ ] install jetbrains mono nerd font
