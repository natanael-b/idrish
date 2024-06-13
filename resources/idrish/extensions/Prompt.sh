
function idrish_history_prefix() {
  tput setaf 93
  echo -n '       ◀'
  tput setab 93
  tput setaf 16
  echo -n ' > '
  tput sgr0
  echo -n ' '
}

function idrish_history_suffix() {
  tput sgr0
}

function idrish_prompt() {
  clear

  [ ! "${INPUT_HISTORY}" = "" ] && {
    tput setab 15
    tput setaf 16
    echo '                          '
    echo '  Histórico da sessão     '
    tput setab 15
    tput setaf 16
    echo -n '                          '
    tput sgr0
    tput setaf 15
    echo  '◣ '
    tput sgr0
    echo "${INPUT_HISTORY}"
  }


  tput setab 39
  tput setaf 16
  echo -n ' Digite seu comando  '
  tput sgr0
  tput setaf 39
  echo -n '▶ '
  tput sgr0
  echo -n ' '
}

