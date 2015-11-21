# OS X Quickstart
Running `./bootstrap.sh` on a fresh install of OS X will result in the following end-state:

1. Homebrew installed
1. Python 2 installed
1. Ansible installed
1. An Ansible playbook will run which installs:
  - Virtualbox
  - Vagrant
  - Vagrant plugin hostsmanager

If some or all of the above tools are installed, a small effort is made to accommodate the situation and not stomp your existing setup.  However, we are only checking for the existence of a tool, not explicitly for a specific version.  If any version of a particular tool exists, we simply move on.  For each of the first three tools, if missing, the latest version available will get installed as this is the default behavior of the associated mechanisms used.  In the case of Vagrant or Virtualbox, if missing, predetermined versions (defined by the respective download url in the `vars` directory) will be downloaded and installed.
