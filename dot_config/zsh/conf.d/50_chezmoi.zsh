# ==========================================
# 50_chezmoi.zsh - Chezmoi & Dotfiles Management
# ==========================================

# SYNOPSIS: View auto-generated help menu (Command Index)
alias dh='dot-help'

# SYNOPSIS: Synchronize and push dotfiles via Chezmoi
alias ds='dot-sync'

# SYNOPSIS: Backup installed system package lists
alias bpkg='backup_pkgs'

# SYNOPSIS: Export native and AUR packages to backup directory
function backup_pkgs() {
  local backup_dir="$HOME/backup-pkgs"
  mkdir -p "$backup_dir"
  pacman -Qqen >"$backup_dir/pkglist-repo.txt"
  pacman -Qqem >"$backup_dir/pkglist-aur.txt"
  print -P "%F{green}✔ Packages successfully dumped to %f%B$backup_dir%b"
}

# SYNOPSIS: Purge deleted/unmanaged target files from Chezmoi state
function cz-purge() {
  echo "[!] Scanning managed ecosystem (Files & Dirs)..."

  chezmoi managed --include=files,dirs | tac | while IFS= read -r f; do
    local target_path="$HOME/$f"

    # Check if target physically does not exist (-e) and is not a broken symlink (-L)
    if [ ! -e "$target_path" ] && [ ! -L "$target_path" ]; then
      echo "[D] Forgetting target: $target_path"
      chezmoi forget "$target_path"
    fi
  done

  echo "[v] System cleaned successfully!"
}

# SYNOPSIS: Auto-scan, synchronize, and commit/push dotfiles to GitHub
function dot-sync() {
  backup_pkgs

  echo -e "\e[36m🚀 Activating Chezmoi radar to scan system state...\e[0m"
  echo -e "\e[33m🔄 Comparing Target State with Source State...\e[0m"
  chezmoi re-add

  local git_status=$(chezmoi git -- status --porcelain)

  if [[ -z "$git_status" ]]; then
    echo -e "\e[90m⚡ Config is intact, no changes detected!\e[0m"
  else
    echo -e "\e[33m📦 Detected config changes! Staging...\e[0m"
    chezmoi git -- add .

    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    chezmoi git -- commit -m "chore: auto-sync dotfiles at $timestamp" >/dev/null 2>&1

    echo -e "\e[36m🚀 Pushing dotfiles to remote repository...\e[0m"
    chezmoi git -- push

    echo -e "\e[32m✅ Chezmoi sync completed successfully! Backed up to GitHub.\e[0m"
  fi
}

# SYNOPSIS: Auto-generated command cheat sheet / doc viewer
function dot-help() {
  clear
  echo -e "\e[36m🚀 COMMAND INDEX - AUTO-GENERATED CHEATSHEET 🚀\e[0m\n"

  # PERF: Fast AWK parser scanning all modular files under conf.d/*.zsh
  awk '
        # 1. Match synopsis metadata
        /^# SYNOPSIS:/ {
            desc = substr($0, 13)
            sub(/^[ \t]+/, "", desc)
            next
        }

        # 2. Match function or alias declaration
        /^(function [a-zA-Z0-9_-]+|[a-zA-Z0-9_-]+\(\)|alias [a-zA-Z0-9_-]+=)/ {
            if (desc != "") {
                if ($1 == "alias") {
                    cmd_name = $2
                    split(cmd_name, parts, "=")
                    cmd_name = parts[1]
                } else if ($1 == "function") {
                    cmd_name = $2
                } else {
                    cmd_name = $1
                }
                sub(/\(\)/, "", cmd_name)

                # Render UI
                printf "\033[32m%-25s\033[0m %s\n", cmd_name, desc
                desc = ""
            }
        }

        # 3. Reset synopsis state on non-matching lines
        /^[^# \t]/ { desc = "" }
    ' ~/.config/zsh/conf.d/*.zsh
}
