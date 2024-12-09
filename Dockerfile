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
  net-tools \
  netcat-openbsd \
  openssh-server \
  podman \
  python3 \
  python3-pip \
  silversearcher-ag \
  software-properties-common \
  sudo \
  tmux \
  unzip \
  vim \
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

#ARG USERID
#ARG GROUPID
#ARG USERNAME

# Create the user
#RUN \
#  groupadd -g $GROUPID $USERNAME && \
#  useradd -u $USERID -g $GROUPID --create-home --home-dir /home/$USERNAME -s /bin/bash $USERNAME && \
#  chown -R $USERNAME:$USERNAME /home/$USERNAME

RUN \
  echo "ubuntu:ubuntu" | chpasswd

#USER $USERNAME
USER ubuntu

# Suppress sudo warning when starting terminal
RUN \
  touch ~/.sudo_as_admin_successful

# Beautiful default monospace font and no menubar in the terminal
RUN \
  dbus-launch gsettings set org.gnome.desktop.interface monospace-font-name "'DejaVu Sans Mono 14'" && \
  dbus-launch gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

# Solarized color theme
#
# I'm checking out a specific gitsha of the gnome-terminal-colors-solarized repo to protect against supply chain
# attacks. Likewise, I'm downloading a specific gitsha of dircolors-solarized to be sure what I'm getting.
#
RUN \
  cd /tmp && \
  git clone https://github.com/aruhier/gnome-terminal-colors-solarized.git && \
  cd gnome-terminal-colors-solarized && \
  git reset --hard 9651c41df0f89e87feee0c798779abba0f9395e0 && \
  dbus-launch ./install.sh --skip-dircolors -s light -p $(gsettings get org.gnome.Terminal.ProfilesList list | sed "s/.*'\([^']\{1,\}\)'.*/\1/") && \
  cd /tmp && \
  rm -rf /tmp/gnome-terminal-colors-solarized && \
  mkdir ~/.dir_colors && \
  chmod 700 ~/.dir_colors && \
  mkdir dircolors-solarized && \
  cd dircolors-solarized && \
  curl -L https://raw.github.com/seebi/dircolors-solarized/664dd4e91ff9600a8e8640ef59bc45dd7c86f18f/dircolors.ansi-light >> ~/.dir_colors/dircolors && \
  cd /tmp && \
  rm -rf dircolors-solarized

# Make podman connect to the podman running on the host by default
#RUN \
#  podman system connection add host unix:///run/user/1000/podman/podman.sock

# Mount points
RUN \
  mkdir ~/Downloads && \
  chmod 755 ~/Downloads && \
  mkdir ~/work && \
  chmod 755 ~/work

# Install various dotfiles and configurations
RUN \
  cd ~/.config && \
  git clone https://github.com/huned/dotfiles.git && cd dotfiles && \
  git reset --hard c5f35364a7cd27bca81138b9409bbe350725c444 && \
  git submodule init && git submodule update && \
  mkdir -p ~/.config/nvim && ln -sr .config/nvim/init.vim ~/.config/nvim/init.vim && \
  mkdir -p ~/.local/share/nvim/site/pack/$USER && ln -sr .local/share/nvim/site/pack/huned ~/.local/share/nvim/site/pack/$USER && \
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

# Prevent gnome-terminal from looking for accessibility tools
ENV NO_AT_BRIDGE=1

CMD ["gnome-terminal", "--disable-factory", "--working-directory=~"]
