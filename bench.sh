#!/bin/sh
nix-shell  --arg doBenchmark true  --run 'cabal new-bench'

