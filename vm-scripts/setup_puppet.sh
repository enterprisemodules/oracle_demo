#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="${SCRIPT_DIR}/.."

if [[ -f /var/log/setup_puppet.done ]]; then
  echo "Puppet already setup"
else
  echo 'Installing required gems'
  /opt/puppetlabs/puppet/bin/gem install r10k  --no-document

  echo "Using released versions of modules..."
  PUPPETFILE="Puppetfile"
  /opt/puppetlabs/puppet/bin/r10k puppetfile install --puppetfile "${BASE_DIR}/${PUPPETFILE}" --force

  setup_directory() {
    local dirname="$1"
    [[ -d $dirname ]] && rm -rf "$dirname"
    ln -sf "${BASE_DIR}/$2" "$dirname"
  }

  echo 'Setting up hiera directories'
  setup_directory /etc/puppetlabs/code/environments/production/hieradata hieradata
  rm -f /etc/puppetlabs/code/environments/production/hiera.yaml
  ln -sf "${BASE_DIR}/hiera.yaml" /etc/puppetlabs/code/environments/production

  echo 'Setting up Puppet module directories'
  setup_directory /etc/puppetlabs/code/environments/production/modules modules

  echo 'Setting up Puppet manifest directories'
  setup_directory /etc/puppetlabs/code/environments/production/manifests manifests

  touch /var/log/setup_puppet.done
fi