#!/usr/bin/bash

sudo apt install lua5.4 > /dev/null 2>&1

input='crie o arquivo teste.txt, coloque nele a frase Olá Mundo!, abra no kate e mova ele para /tmp'

hash="6f3cc0c9c147c2aad6f207dedae5a3b498256704c4f0d1fdc77316428b69075f"

hash_input=$(lua5.4 idris.lua --lang=pt_BR --database=demonstration "${input}" | sha256sum | cut -d' ' -f1)

[ "${hash}" = "${hash_input}" ] && {
  exit 0
}

echo "Error: The '${input}' has generated a different output"
exit 1
