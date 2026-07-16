FROM ubuntu:latest

# Use bash instead of sh to be able to use process substitution in RUN commands.
SHELL ["/bin/bash", "-c"]

# Change ubuntu user's password
RUN \
  echo "ubuntu:ubuntu" | chpasswd

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
  btop \
  build-essential \
  bzip2 \
  caddy \
  curl \
  dconf-cli \
  #dbus-x11 \
  fastfetch \
  file \
  #fonts-noto \
  fzf \
  gettext \
  git \
  git-delta \
  git-lfs \
  gitk \
  #gnome-icon-theme \
  #gnome-terminal \
  gpg \
  jq \
  #libcanberra-gtk-module \
  #libcanberra-gtk3-module \
  libglib2.0-bin \
  ncurses-term \
  net-tools \
  netcat-openbsd \
  openssh-server \
  podman \
  poppler-utils \
  python3 \
  python3-pip \
  ripgrep \
  software-properties-common \
  sqlite3 \
  sudo \
  time \
  tmux \
  tree \
  unzip \
  vim \
  w3m \
  w3m-img \
  wget \
  #x11-apps \
  #xwayland-run \
  zlib1g-dev

# Install neovim from ppa:neovim/unstable
RUN apt-add-repository -y ppa:neovim-ppa/unstable && apt update && \
  apt install -y neovim

#USER $USERNAME
USER ubuntu

WORKDIR /home/ubuntu

# Suppress sudo warning when starting terminal
RUN \
  touch ~/.sudo_as_admin_successful

# Install various dotfiles and configurations
RUN \
  mkdir -p ~/.config && cd ~/.config && \
  git clone https://github.com/huned/dotfiles.git && cd dotfiles && \
  # Protect against supply chain attack by specifying a known good hash
  git reset --hard 2e775f8 && \
  ./install.sh

# deno
RUN \
  curl -fsSL https://deno.land/install.sh | sh && \
  echo "export PATH=~/.deno/bin:$PATH" >> ~/.bashrc

# rust
RUN \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  echo "export PATH=~/.cargo/bin:$PATH" >> ~/.bashrc && \
  echo "source ~/.cargo/env" >> ~/.bashrc

# uv
RUN \
  curl -LsSf https://astral.sh/uv/install.sh | sh && \
  echo "export PATH=~/.local/bin:$PATH" >> ~/.bashrc

# opencode
RUN \
  curl -fsSL https://opencode.ai/install | bash

# ollama
#RUN \
#  curl -fsSL https://ollama.com/install.sh | sh

# bitwarden
RUN \
  cd /tmp && \
  wget -q https://github.com/bitwarden/clients/releases/download/cli-v2026.6.0/bw-linux-2026.6.0.zip && \
  echo "392549496c712ab86bfbd6c27302df9fd2c431cfc7a47e26941ac3e3893f4d27 bw-linux-2026.6.0.zip" | sha256sum --check --status && \
  unzip -q bw-linux-2026.6.0.zip && \
  mv bw ~/.local/bin && \
  rm /tmp/bw-linux-2026.6.0.zip

CMD ["/bin/bash"]
