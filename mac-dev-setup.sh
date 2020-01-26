#!/bin/bash

set -e

# helper function for installing a package via brew
brew_pkg(){
    brew install $1
}

# helper function for installing a package via brew cask
brew_cask(){
    brew cask install $1
}

# helper function for installing a package via brew tap
brew_tap(){
    local TAP=$1
    local PKG=$2
    brew tap $TAP
    brew_pkg $PKG
}

# Temporarily disable gatekeeper to prevent installations from failing
sudo spctl --master-disable

# Install homebrew if it's not already installed
type brew &> /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install packages
BREW_PKGS=(
  coreutils
  bash
  bash-git-prompt
  bash-completion
  binutils
  diffutils
  ed
  findutils
  gawk
  gnu-indent
  gnu-sed
  gnu-tar
  gnu-which
  gnutls
  grep
  gzip
  screen
  watch
  wdiff
  wget
  go
  python3
  node
  git
  packer
  terraform
  consul
  vault
  nomad
  awscli
  jq
)
for pkg in "${BREW_PKGS[@]}";do brew_pkg $pkg;done

# Install casks
BREW_CASKS=(
  google-chrome
  visual-studio-code
  slack
  virtualbox
  virtualbox-extension-pack
  vagrant
  docker
)
for cask in "${BREW_CASKS[@]}";do brew_cask $cask;done

# Install taps
# FORMAT: <tap_url_or_github_repo>,<pkg_name>
BREW_TAPS=(
  drone/drone,drone
  aws/tap,aws-sam-cli
)
for tap in "${BREW_TAPS[@]}";do
  TAP=$(echo $tap | cut -d, -f1)
  PKG=$(echo $tap | cut -d, -f2)
  brew_tap $TAP $PKG
done

# Make sure you get all the PATH elements into ~/.bash_profile.
# You may still need to manually tweak things to your liking.
echo 'PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/binutils/bin:/usr/local/opt/gettext/bin:/usr/local/opt/gnu-getopt/bin:/usr/local/opt/ed/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/gnu-indent/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/gnu-which/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:${HOME}/Library/Python/3.7/bin:$PATH"' >> ~/.bash_profile_path_gnu

# Add our shiny new shell to the list of approved shells in macOS
grep -q "/usr/local/bin/bash" /etc/shells || echo '/usr/local/bin/bash' | sudo tee -a /etc/shells

# Switch to our new shell permanently
chsh -s /usr/local/bin/bash

# I'm too good to constantly type my password ...
ME=$(whoami)
echo "$ME   ALL = (ALL) NOPASSWD:ALL" | sudo tee -a /private/etc/sudoers.d/$ME
sudo chmod 0400 /private/etc/sudoers.d/$ME

# Re-enable gatekeeper
sudo spctl --master-enable
sudo spctl --add /Applications/Visual\ Studio\ Code.app
sudo spctl --add /Applications/VirtualBox.app

# Add git bash-completion to shell profile
echo '[[ -r "/usr/local/etc/bash_completion.d/git-completion.bash" ]] && . "/usr/local/etc/bash_completion.d/git-completion.bash"' >> ~/.bash_profile

# Add fancy bash prompt when in git repos
cat <<GIT >> ~/.bash_profile
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
GIT

# Turn off scrollbars in Terminal.app
defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
