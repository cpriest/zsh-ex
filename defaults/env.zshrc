#!/bin/zsh

# This export sets a script to pre-process any files opened by less, comment out to disable
LESSOPEN="|$ZEX_DIR/scripts/lesspipe.sh %s'
