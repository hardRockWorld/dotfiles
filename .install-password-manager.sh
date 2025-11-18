#!/bin/sh

# Exit immediately if pass is already in $PATH
type pass >/dev/null 2>&1 && exit

# OS detection and package installation
case "$(uname -s)" in
Linux)
  if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu
    sudo apt-get update && sudo apt-get install -y pass
  elif [ -f /etc/fedora-release ]; then
    # Fedora
    sudo dnf install -y pass
  elif [ -f /etc/arch-release ]; then
    # Arch Linux
    sudo pacman -Sy --noconfirm pass
  elif [ -f /etc/SuSE-release ] || [ -f /etc/SUSE-brand ]; then
    # openSUSE
    sudo zypper install -y pass
  else
    echo "Unsupported Linux distribution"
    exit 1
  fi
  ;;
Darwin)
  # macOS
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing Homebrew first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install pass
  ;;
*)
  echo "unsupported OS"
  exit 1
  ;;
esac

# init password store repository
git clone git@github.com:ThomasCode92/password-store.git .password-store
pass init $PASS_GPG_KEY
