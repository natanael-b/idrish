#!/usr/bin/bash

which lua5.4 || sudo apt install lua5.4 > /dev/null 2>&1

lua5.4 idris.lua --lang=pt_BR -u

input="crie um arquivo test.txt e insira a frase Hello World nele!"

output=$(lua5.4 idris.lua  --lang=pt_BR "${input}" --shell-output | tr -d $'\n')

[ "${output}" = "touch 'test.txt';echo 'Hello World' >> 'test.txt';" ] && {
  exit 0
}

echo "Error: The '${input}' has generated a different output"
exit 1
