#!/bin/bash
podman run \
  --network host \
  --hostname devbox.local \
  --name devbox \
  --userns keep-id \
  --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
  --volume /home/$USER/work:/home/ubuntu/work:z \
  --volume /home/$USER/Downloads:/home/ubuntu/Downloads:z \
  --volume /home/$USER/.env.secrets:/home/ubuntu/.env.secrets \
  --interactive --tty --detach \
  devbox /bin/bash
