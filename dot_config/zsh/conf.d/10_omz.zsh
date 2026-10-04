# ==========================================
# 10_omz.zsh - Oh My Zsh & Plugins
# ==========================================

ZSH_THEME=""

plugins=(
  git
  web-search
  colored-man-pages
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh framework
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi
