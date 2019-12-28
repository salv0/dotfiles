#!/usr/bin/env bash

source ./lib-sh/lib-utils.sh

###############################################################################
# Install brew dependencies and other non brew tools                          #
###############################################################################
info "Ensuring build/install tools are available"
xcode-select --install 2>&1 > /dev/null
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer 2>&1 > /dev/null
sudo xcodebuild -license accept 2>&1 > /dev/null
ok

# Install homebrew
info "Checking if homebrew is already installed.."
if [[ $(command -v brew) == "" ]]; then
  running "Installing homebrew.."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	ok
else
	ok "Homebrew already installed"
fi

###############################################################################
# Install tools/apps/fonts using Homebrew.																	  #
###############################################################################

info "Updating homebrew and any already-installed formulae"
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade
ok

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

info "Installing brew utilities etc.."

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew_install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew_install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew_install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew_install gnu-sed --with-default-names
# Install a modern version of Bash.
brew_install bash
brew_install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install more recent versions of some macOS tools.
brew_install vim
brew_install grep
brew_install openssh
brew_install screen
brew_install php
brew_install gmp
brew_install wget

# Install asdf and general plugin dependencies
brew_install asdf
brew_install autoconf
brew_install automake
brew_install curl
brew_install libtool
brew_install libxslt
brew_install libyaml
brew_install openssl
brew_install readline
brew_install unixodbc
brew_install unzip

# Install other useful binaries.
brew_install git
brew_install git-lfs
brew_install httpie
brew_install lua
brew_install pigz
brew_install pv
brew_install rename
brew_install ssh-copy-id
brew_install tree

# Install csshx (Cluster ssh tool for Terminal.app)
brew_install csshx

# Install cask apps/fonts/tools
brew tap homebrew/cask-fonts

brew_cask_install cakebrew
brew_cask_install font-fira-code
brew_cask_install google-chrome
brew_cask_install slack
brew_cask_install visual-studio-code

# Remove outdated versions from the cellar.
brew cleanup

info "All done!"
