#!/usr/bin/env zsh

set -e

echo "🚀 Starting Mac Dev Bootstrap"

#############################################
# Ensure script runs in zsh
#############################################

if [ -z "$ZSH_VERSION" ]; then
  echo "Restarting script using zsh..."
  exec zsh "$0" "$@"
fi

#############################################
# Install Xcode Command Line Tools
#############################################

if ! xcode-select -p &>/dev/null; then
  echo "📦 Installing Xcode Command Line Tools..."

  xcode-select --install

  echo "⏳ Waiting for installation..."

  until xcode-select -p &>/dev/null; do
    sleep 5
  done

  echo "✅ Xcode Command Line Tools installed"
else
  echo "✅ Xcode Command Line Tools already installed"
fi

#############################################
# Install Oh My Zsh
#############################################

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Installing Oh My Zsh..."

  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

else
  echo "✅ Oh My Zsh already installed"
fi

#############################################
# Install Homebrew
#############################################

if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed"
fi

brew update

#############################################
# Install Brew Packages
#############################################

echo "📦 Installing packages from Brewfile..."

brew bundle --file ./Brewfile

#############################################
# Setup NVM
#############################################

export NVM_DIR="$HOME/.nvm"

mkdir -p "$NVM_DIR"

if ! grep -q 'NVM_DIR' "$HOME/.zshrc"; then

cat << 'EOF' >> ~/.zshrc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

EOF

fi

source ~/.zshrc

#############################################
# Install Node LTS
#############################################

if command -v nvm &>/dev/null; then
  echo "📦 Installing Node LTS"
  nvm install --lts
  nvm use --lts
fi

#############################################
# fzf setup
#############################################

if [ -d "$(brew --prefix)/opt/fzf" ]; then
  "$(brew --prefix)/opt/fzf/install" --all
fi

echo ""
echo "🎉 Mac Dev Environment Ready!"
echo "Restart your terminal."