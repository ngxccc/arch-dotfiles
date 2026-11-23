# ==========================================
# 00_env.zsh - Core Environment & PATH
# ==========================================

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

export GHIDRA_INSTALL_DIR="/usr/lib/ghidra"
export REA_MCP_INPUT_SCHEMA_PROFILE=compact

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools/36.0.0"

# Ensure unique entries in PATH (ZSH typeset -U prevents duplicates)
typeset -U PATH path
path=(
  /home/ngxc/.local/share/nvim/mason/bin
  /home/ngxc/.bun/bin
  /home/ngxc/.local/bin
  $path
)
export PATH
