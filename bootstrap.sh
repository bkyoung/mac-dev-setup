#!/bin/bash

PROJECT_DIR=$(dirname $0)

install_brew(){
  echo "[Installing Homebrew] *********************************************************"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew tap caskroom/cask
}

install_python(){
  which brew || install_brew
  echo "[Installing Python 2] *********************************************************"
  brew install python
}

install_ansible(){
  which pip || install_python
  echo "[Installing Ansible] **********************************************************"
  pip install ansible
}

which ansible || install_ansible
echo "[RUNNING PLAYBOOKS] ***********************************************************"
ansible-playbook -i ${PROJECT_DIR}/ansible/inventory ${PROJECT_DIR}/ansible/site.yml
