#!/bin/bash
podman run \
  --tz=local \
  --network host \
  --hostname devbox.local \
  --name devbox \
  --env TERM="$TERM" \
  --userns keep-id \
  --volume ~/.ssh:/home/ubuntu/.ssh:ro \
  --volume ~/work:/home/ubuntu/work:ro \
  --volume ~/Downloads:/home/ubuntu/Downloads:ro \
  --interactive --tty --detach \
  --replace \
  devbox:latest /bin/bash
