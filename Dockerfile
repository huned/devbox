FROM ubuntu:latest

# Use bash instead of sh to be able to use process substitution in RUN commands.
SHELL ["/bin/bash", "-c"]

# Change ubuntu user's password
RUN \
  echo "ubuntu:ubuntu" | chpasswd

# Install software
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
  manpages \
  manpages-dev \
  ncurses-term \
  net-tools \
  netcat-openbsd \
  nodejs \
  npm \
  openssh-client \
  openssh-server \
  podman \
  poppler-utils \
  python3 \
  python3-pip \
  ripgrep \
  software-properties-common \
  sqlite3 \
  sudo \
  tealdeer \
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

# Switch to ubuntu user and their home dir
USER ubuntu
WORKDIR /home/ubuntu

# Suppress sudo warning when starting terminal
RUN \
  touch ~/.sudo_as_admin_successful

# Install dotfiles
# NOTE: Dotfiles come before installing other stuff because those other things
# might try to write to ~/.bashrc or something which we don't want to clobber
# later.
RUN \
  mkdir -p ~/.config && cd ~/.config && \
  git clone https://github.com/huned/dotfiles.git && cd dotfiles && \
  # Protect against supply chain attack by specifying a known good hash
  git reset --hard 0f4b2d1 && \
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

# opencode and codegraph
RUN \
  curl -fsSL https://opencode.ai/install | bash && \
  npm install -g @colbymchenry/codegraph

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

# Generate ssh keypair for github
# IMPORTANT: add the public key to your github account
RUN \
  mkdir -p ~/.ssh && chmod 700 ~/.ssh && \
  ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519_github -C "devbox+github@devbox.local" && \
  echo -e "Host github.com\n\tHostName github.com\n\tUser git\n\tIdentityFile ~/.ssh/id_ed25519_github\n\tIdentitiesOnly yes" > ~/.ssh/config && \
  chmod 600 ~/.ssh/config

CMD ["/bin/bash"]
