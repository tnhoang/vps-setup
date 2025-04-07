#!/bin/sh

# Basic git commands
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias gm='git merge'
alias gl='git log'
alias glo='git log --oneline --graph'
alias gd='git diff'
alias grh='git reset --hard'
alias grb='git rebase'

# Git functions
# Checkout branch with fuzzy finding
gcob() {
  git checkout $(git branch | grep $1 | sed 's/^[ *]*//')
}

# Delete all local branches except main/master
gclean() {
  git branch | grep -v "main\|master" | xargs git branch -D
}

# Stash with optional message
gst() {
  if [ -z "$1" ]; then
    git stash
  else
    git stash push -m "$1"
  fi
}

# Pop specific stash or last one
gstp() {
  if [ -z "$1" ]; then
    git stash pop
  else
    git stash pop stash@{$1}
  fi
} 