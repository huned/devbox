#!/bin/bash
podman run \
  --tz=local \
  --network host \
  --hostname devbox.local \
  --name devbox \
  --userns keep-id \
  --volume ~/Downloads:/home/ubuntu/data:z \
  --volume ~/.ssh:/home/ubuntu/.ssh:ro \
  --volume ~/.ollama:/home/ubuntu/.ollama:z \
  --volume ~/work:/home/ubuntu/work:z \
  --volume ~/Downloads:/home/ubuntu/Downloads:z \
  --volume ~/.env.secrets:/home/ubuntu/.env.secrets \
  --interactive --tty --detach \
  --replace \
  devbox /bin/bash
