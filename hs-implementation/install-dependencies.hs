#!/bin/bash

# Adding stack 
sudo wget -qO- https://get.haskellstack.org/ | sh

stack upgrade 
stack setup
stack install ghc-mod
stack install cabal-install
stack install hlint
stack install pandoc
stack install purescript
stack install wreq
stack install lens
stack install ihaskell        
stack install projectile
stack install use-package
stack install which-key
stack install apply-refact
stack install codex
stack install hasktags    

# Installing specific dependencies
cabal install random
cabal install MonadRandom
cabal install random-shuffle
