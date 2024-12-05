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
      --detach \
      --network host \
      --hostname devbox.local \
      --name devbox \
      --volume /home/$USER/.ssh:/home/ubuntu/.ssh:z
      --volume /home/$USER/work:/home/ubuntu/work:z
      --volume /home/$USER/Downloads:/home/ubuntu/Downloads:z
      devbox

heavily adapted from [jonaslind/devenv](https://github.com/jonaslind/devenv).

TODOs

- remove the ubuntu user and add my own user?
- my dotfiles and configs
- default command should be a useful tmux session
