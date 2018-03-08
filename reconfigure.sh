#!/bin/bash
set -e
########################################

cabal2nix . > "nix/rank2.nix"

./provision.sh

########################################
#
# SHELL_FILE=shell-rank2.nix
# cabal2nix . --shell > "$SHELL_FILE"
#
# if [ ! -f "$SHELL_FILE" ]; then 
#   # don't overwrite if it already exists
#   cabal2nix . --shell > "$SHELL_FILE" 
# fi
#

