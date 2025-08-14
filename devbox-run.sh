#!/bin/bash
podman run \
  --tz=local \
  --network host \
  --hostname devbox.local \
  --name devbox \
  --userns keep-id \
  --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
  --volume /home/$USER/.ollama:/home/ubuntu/.ollama:z \
  --volume /home/$USER/work:/home/ubuntu/work:z \
  --volume /home/$USER/Downloads:/home/ubuntu/Downloads:z \
  --volume /home/$USER/.env.secrets:/home/ubuntu/.env.secrets \
  --interactive --tty --detach \
  devbox /bin/bash
