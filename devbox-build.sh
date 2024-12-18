#!/bin/bash
podman build \
  --tag devbox \
  --format docker \
  --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
  .
