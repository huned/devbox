development environment in a podman container

    # build container
    podman build \
      --tag devbox \
      --format docker \
      --build-arg USERID="$(id -u)" \
      --build-arg GROUPID="$(id -g)" \
      --build-arg USERNAME="$USER" \
      .

    # allow all connections to host's X/Wayland
    xhost +

    # run container, which starts a gnome-terminal from the container
    podman run \
      --detach \
      --network host \
      --hostname devbox.local \
      --name devbox \
      --volume /home/$USER/work:/home/ubuntu/work:z
      --volume /home/$USER/Downloads:/home/ubuntu/Downloads:z
      devbox

heavily adapted from [jonaslind/devenv](https://github.com/jonaslind/devenv).
