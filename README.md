development environment in a podman container

    # build container
    podman build \
      --tag devbox \
      --format docker \
      --build-arg USERID="$(id -u)" \
      --build-arg GROUPID="$(id -g)" \
      --build-arg USERNAME="$USER" \
      .

    # allow local connections to host's X server
    xhost +local:

    # run container, which starts a gnome-terminal from the container
    podman run \
      --replace \
      --network host \
      --hostname devbox.local \
      --name devbox \
      --userns keep-id \
      --env DISPLAY=:0 \
      --volume /home/$USER/.ssh:/home/ubuntu/.ssh:ro \
      --volume /home/$USER/work:/home/ubuntu/work:z \
      --volume /home/$USER/Downloads:/home/ubuntu/Downloads:ro \
      devbox

heavily adapted from [jonaslind/devenv](https://github.com/jonaslind/devenv).

TODOs

- my dotfiles and configs
- default command should be a useful tmux session
