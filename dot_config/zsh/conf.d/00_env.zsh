# ==========================================
# 00_env.zsh - Core Environment & PATH
# ==========================================

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

# Ensure unique entries in PATH (ZSH typeset -U prevents duplicates)
typeset -U PATH path
path=(
  /home/ngxc/.local/share/nvim/mason/bin
  /home/ngxc/.bun/bin
  /home/ngxc/.local/bin
  $path
)
export PATH
