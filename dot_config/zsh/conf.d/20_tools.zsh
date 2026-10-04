# ==========================================
# 20_tools.zsh - External CLI Tools & Prompt
# ==========================================

# Oh My Posh Prompt
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/porsche.omp.json)"
fi

# Keychain (SSH/GPG)
if command -v keychain >/dev/null 2>&1; then
  eval "$(keychain --eval --quiet --noask ngxc)"
fi

# Fast Node Manager (fnm)
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Zoxide (Smart cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
