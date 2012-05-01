# disable auto-logout
export TMOUT=0

# if not root
if [[ $UID -ne 0 ]]; then

  # set umask
  umask 0077

  # protect user
  alias cp="cp -i"
  alias mv="mv -i"
  alias rm="rm -i"

  # allow core dumps
  ulimit -c unlimited

fi

# set editor
export EDITOR=nano

# set locale
export LANG=C
