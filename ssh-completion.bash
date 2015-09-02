complete -W "$((cut -f 1 -d ' ' < ~/.ssh/known_hosts | sed -e s/,.*//g | uniq | grep -v "\["; grep '^Host' < ~/.ssh/config | awk '{print $2}' | grep -v '\*') | sort | uniq)" ssh
