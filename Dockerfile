FROM ubuntu:noble

# Use bash instead of sh to be able to use process substitution in RUN commands.
SHELL ["/bin/bash", "-c"]

# Install software!
#
# We're basing this image on ubuntu and I'm trusting the default apt repos.
#
# Unfortunately we're getting a very old podman version this way.
#
RUN apt update && apt upgrade -y && \
  export DEBIAN_FRONTEND="noninteractive" && \
  export TZ="America/Chicago" && \
  apt install -y \
  bash-completion \
  bat \
  build-essential \
  bzip2 \
  curl \
  dconf-cli \
  dbus-x11 \
  file \
  fonts-noto \
  gettext \
  git \
  gitk \
  gnome-icon-theme \
  gnome-terminal \
  gpg \
  jq \
  libcanberra-gtk-module \
  libcanberra-gtk3-module \
  libglib2.0-bin \
  mosh \
  ncurses-term \
  net-tools \
  netcat-openbsd \
  openssh-server \
  podman \
  poppler-utils \
  python3 \
  python3-pip \
  silversearcher-ag \
  software-properties-common \
  sqlite3 \
  sudo \
  tmux \
  unzip \
  vim \
  w3m \
  w3m-img \
  wget \
  x11-apps \
  xwayland-run \
  zlib1g-dev

# Install neovim from ppa:neovim/unstable
RUN apt-add-repository -y ppa:neovim-ppa/unstable && apt update && \
  apt install -y neovim

# Install deno into /usr/local
RUN \
  curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh

# Install ollama into /usr/local
RUN \
  curl -fsSL https://ollama.com/install.sh | sh

RUN \
  echo "ubuntu:ubuntu" | chpasswd

RUN \
  echo "127.0.0.1 devbox devbox.local" >> /etc/hosts

#USER $USERNAME
USER ubuntu

WORKDIR /home/ubuntu

# Suppress sudo warning when starting terminal
RUN \
  touch ~/.sudo_as_admin_successful

# Mount points
RUN \
  mkdir ~/Downloads && \
  chmod 755 ~/Downloads && \
  mkdir ~/work && \
  chmod 755 ~/work

# Install various dotfiles and configurations
RUN \
  mkdir -p ~/.config && cd ~/.config && \
  git clone https://github.com/huned/dotfiles.git && cd dotfiles && \
  git reset --hard bd4f7ed451fdb39c316e9d411718ddc2507c3788 && \
  git submodule init && git submodule update && \
  ln -fsr .config/nvim ~/.config/nvim && \
  mkdir -p ~/.local/share && ln -fsr .local/share/nvim ~/.local/share/nvim && \
  ln -fsr .bashrc ~/.bashrc && \
  ln -sr .toprc ~/.toprc && \
  ln -sr .gitconfig ~/.gitconfig && \
  ln -sr .sqliterc ~/.sqliterc

# Install Oh my tmux!
RUN \
  cd ~ && git clone https://github.com/gpakosz/.tmux.git && cd .tmux && \
  git reset --hard 4cb811769abe8a2398c7c68c8e9f00e87bad4035 && \
  ln -fsr .tmux.conf ~/.tmux.conf && \
  cp .tmux.conf.local ~/.tmux.conf.local

RUN \
  echo "export TERM=xterm-256color" >> ~/.bashrc && \
  echo "export COLORTERM=truecolor" >> ~/.bashrc

CMD ["/bin/bash"]
