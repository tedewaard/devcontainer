FROM ubuntu:24.04

# Prevent interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Install core tools
# - neovim: your editor
# - git, curl, wget: basics for pulling repos and tools
# - ripgrep (rg), fd-find (fdfind): fast search tools neovim plugins love
# - unzip, tar, gzip: for plugin managers that download archives
# - build-essential, cmake: some neovim plugins (like treesitter parsers) need a C compiler
# - python3, python3-pip, python3-venv: for python-based tools and AI agents
# - nodejs, npm: many AI tools (Claude Code, copilot, etc.) need Node.js
# - openssh-client: for git over SSH
# - xclip: fallback clipboard tool (used if X11 forwarding is available)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ripgrep \
    fd-find \
    unzip \
    tar \
    gzip \
    build-essential \
    cmake \
    python3 \
    nodejs \
    npm \
    openssh-client \
    xclip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && rm -rf /opt/nvim-linux-x86_64 \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && rm nvim-linux-x86_64.tar.gz

ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Create a non-root user (some tools don't like running as root)
# -m = create home directory, -s = set default shell
ARG USERNAME=tedewaard
ARG USER_UID=1000
ARG USER_GID=1000
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupadd --gid $USER_GID $USERNAME 2>/dev/null || true \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

# Switch to the non-root user
USER $USERNAME
WORKDIR /home/$USERNAME

# Set up neovim clipboard to use OSC 52 (the magic that makes copy/paste work)
# This tells neovim: "use terminal escape sequences for clipboard"
# Your terminal emulator (Windows Terminal, Alacritty, Kitty, etc.) catches
# these sequences and puts the text on your real system clipboard.
#
# Neovim 0.10+ auto-detects OSC 52 support, but we set it explicitly
# to make sure it works even when $TERM isn't perfect inside the container.
RUN mkdir -p /home/$USERNAME/.config/nvim
COPY ./nvim/ /home/$USERNAME/.config/nvim

# Set environment so tools behave well inside a container
ENV TERM=xterm-256color
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# The workspace directory is where you'll mount your project directories
RUN mkdir -p /home/$USERNAME/workspace
WORKDIR /home/$USERNAME/workspace

# Default to bash (interactive shell)
CMD ["bash"]
