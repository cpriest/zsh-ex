#!/bin/zsh

# PHP Related Aliases
alias phps="php -ddisplay_startup_errors=1 -ddisplay_errors=1"
alias phpi='php -v; php -ddisplay_startup_errors=1 -ddisplay_errors=1 -a';
alias zphpi='zts-php -v; zts-php -ddisplay_startup_errors=1 -ddisplay_errors=1 -a';
alias phpl='php -ddisplay_startup_errors=1 -ddisplay_errors=1 -l'
alias zphpl='zts-php -ddisplay_startup_errors=1 -ddisplay_errors=1 -l'
alias phpd='php -ddisplay_startup_errors=1 -ddisplay_errors=1 -dextension=dbg-php.so'
alias zphpd='zts-php -ddisplay_startup_errors=1 -ddisplay_errors=1 -dextension=dbg-php.so'
alias phpx='php -ddisplay_startup_errors=1 -ddisplay_errors=1 -dzend_extension=xdebug.so'
alias zphpx='zts-php -ddisplay_startup_errors=1 -ddisplay_errors=1 -dzend_extension=xdebug.so'
alias phplint='find . -name "*.php" -print0 | xargs -0 -n1 -P8 php -l'
