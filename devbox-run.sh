#!/bin/bash
podman run \
  --tz=local \
  --network host \
  --hostname devbox.local \
  --userns keep-id \
  --volume ~/.ssh:/home/ubuntu/.ssh:ro \
  --volume ~/work:/home/ubuntu/work:ro \
  --volume ~/Downloads:/home/ubuntu/Downloads:ro \
  --interactive --tty --detach \
  devbox:latest /bin/bash
