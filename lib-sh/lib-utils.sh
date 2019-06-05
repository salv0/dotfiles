#!/usr/bin/env bash

source ./lib-sh/lib-echo.sh

function brew_install() {
    action "brew install $1 $2"
	brew install $1 $2
	ok
}

function brew_cask_install() {
    action "brew cask install $1"
	brew cask install $1
	ok
}
