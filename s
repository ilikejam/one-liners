#!/bin/ksh

changed=false
if hostname | egrep '^(ams|up|liv|dun|chi)' > /dev/null
then
    printf '\033]11;darkred\007'
    printf '\033]10;white\007'
    changed=true
fi
if which sudo > /dev/null
then
    sudo su - root -c "PS1=\"root@$(hostname) # \"; export PS1; exec $(which bash)"
else
    su -
fi
if $changed
then
    printf '\033]11;black\007'
    printf '\033]10;gray\007'
fi
