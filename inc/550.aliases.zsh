#!/usr/bin/zsh

# PHP Related Aliases
alias pa='php ./artisan';

alias  php='php -ddisplay_startup_errors=1 -ddisplay_errors=1';
alias zphp='zts-php -ddisplay_startup_errors=1 -ddisplay_errors=1';

alias  phpd='php -dextension=dbg-php.so';
alias zphpd='zts-php -dextension=dbg-php.so';
alias  phpi='\php -v;     php -a';
alias zphpi='\zts-php -v; zts-php -a';
alias  phpl='php -l';
alias zphpl='zts-php -l';
alias  phpv='php -v';
alias zphpv='zts-php -v';
alias  phpx='php -dzend_extension=xdebug.so';
alias zphpx='zts-php -dzend_extension=xdebug.so';

alias phplint='find . -type d -name vendor -prune -or -name "*.php" -print0 | xargs -0 -n1 -P32 -I{} sh -c "php -derror_log= -ddisplay_startup_errors=1 -ddisplay_errors=1 -l {} || true"';
