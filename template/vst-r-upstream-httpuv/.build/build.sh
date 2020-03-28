#!/usr/bin/env bash

## Purpose:
##
##   This script performs base and user-defined installations.
##
## Usage:
##
##   ./build.sh <ROOT-DIRECTORY>

## Stop on errors:
set -e

## Display commands in action:
set -v

###############
# DEFINITIONS #
###############

## Define the root directory:
_ROOT_DIR="${1}"

## Concatenate files (tolerates non-existing ones):
function _catolerate {
    for _f in "${@}"; do
	if [ -f "${_f}" ]; then
	    cat "${_f}"
	fi
    done
}

function _unique {
    sort | uniq
}

function _get_package_list {
    _catolerate "${@}" | _unique
}

function _get_package_list_apt {
    _get_package_list "${_ROOT_DIR}/packages.apt" "/home/docker/function/.build/packages.apt"
}

###########################################
# PROCEDURE: STEP 1. INSTALL APT PACKAGES #
###########################################

## Configure debconf:
echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections

## Update apt repositories:
apt-get update -qy

## Install APT packages:
_get_package_list_apt | sed 's|\r||' | xargs -d '\n' -- apt-get install -qy --no-install-recommends

## Clean APT stuff:
apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#################################################
## PROCEDURE: STEP 2. APPLY CUSTOM SETUP STEPS ##
#################################################

## Apply custom `bash` script for additional setup:
if [ -f "/home/docker/function/.build/setup.sh" ]; then
    cd /home/docker/function/.build/ && bash setup.sh && cd - || exit 1
fi

## Apply custom `R` script for additional setup:
if [ -f "/home/docker/function/.build/setup.R" ]; then
    cd /home/docker/function/.build/ && Rscript setup.R && cd - || exit 1
fi

##############################
# PROCEDURE: STEP 3. CLEANUP #
##############################

## Clean build stuff:
rm -rf /tmp/.build
rm -rf /home/docker/function/.build
