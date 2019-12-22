#!/bin/bash

set -e

# Install homebrew if it's not already installed
type brew &>2 > /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Setting up a gnu-ish macOS environment, for those of us who work in
# Linux all day from a Mac and just can't stand zsh ...
brew install coreutils
brew install bash
brew install binutils
brew install diffutils
brew install ed
brew install findutils
brew install gawk
brew install gnu-indent
brew install gnu-sed
brew install gnu-tar
brew install gnu-which
brew install gnutls
brew install grep
brew install gzip
brew install screen
brew install watch
brew install wdiff
brew install wget
brew install python3

# Make sure we get all the PATH elements into ~/.bash_profile.
# You may still need to manually tweak things to your liking.
echo 'PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/binutils/bin:/usr/local/opt/gettext/bin:/usr/local/opt/gnu-getopt/bin:/usr/local/opt/ed/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/gnu-indent/libexec/gnubin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-tar/libexec/gnubin:/usr/local/opt/gnu-which/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:${HOME}/Library/Python/3.7/bin:$PATH"' >> ~/.bash_profile

# Add our shiny new shell to the list of approved shells in macOS
grep -q "/usr/local/bin/bash" /etc/shells || echo '/usr/local/bin/bash' | sudo tee -a /etc/shells

# Switch to our new shell permanently
chsh -s /usr/local/bin/bash

# I'm too good to constantly type my password ...
ME=$(whoami)
echo "$ME   ALL = (ALL) NOPASSWD:ALL" | sudo tee -a /private/etc/sudoers.d/$ME
sudo chmod 0400 /private/etc/sudoers.d/$ME

# Install non-free or open source  tools
brew cask install clamxav
brew cask install transmit
brew cask install google-chrome
set +e # The next command will probably fail the first time ...
brew cask install visual-studio-code
set -e
sudo spctl --add /Applications/Visual\ Studio\ Code.app
brew cask install visual-studio-code # Because it fails the first time, until you add the gatekeeper exception
brew cask install slack
set +e # The next command will probably fail the first time ...
brew cask install virtualbox
set -e
sudo spctl --add /Applications/VirtualBox.app
brew cask install virtualbox # Because it fails the first time, until you add the gatekeeper exception
brew cask install virtualbox-extension-pack
brew cask install vagrant
brew cask install docker

# Install my essential free & open source tools
brew install git
brew install bash-git-prompt
brew install bash-completion
brew install packer
brew install terraform
brew install consul
brew install vault
brew install nomad
brew install go
brew tap drone/drone && brew install drone
pip3 install awscli

# Add git bash-completion to shell profile
echo '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"' >> ~/.bash_profile

# Add fancy git bash prompt when in repos
cat <<GIT >> ~/.bash_profile
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
GIT

# Turn off scrollbars in Terminal.app
defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
