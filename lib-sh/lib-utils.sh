#!/usr/bin/env bash

source ./lib-sh/lib-echo.sh

function brew_install() {
    running "brew install $1 $2"
	brew install $1 $2
	ok
}

function brew_cask_install() {
    running "brew cask install $1"
	brew cask install $1
	ok
}
