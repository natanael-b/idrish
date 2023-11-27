<p align="center">
  <a href="https://github.com/natanael-b/idris/fork">
    <img height=26 alt="Crie um fork no github" src="https://img.shields.io/badge/Fork--Me-H?style=social&logo=github">
  </a>
  <img  height=26 alt="GitHub Repo stars" src="https://img.shields.io/github/stars/natanael-b/idris?style=social">
</p>

Modelo de processamento de linguagem natural escrito em `Lua` que gera comandos de terminal com base na entrada do usuário. Ele compreende a entrada do usuário, identificar verbos, substantivos e outros elementos da linguagem e, em seguida, gerar comandos executáveis com base no banco de dados de comandos fornecido. Esse projeto não utiliza LLMs ou qualquer algoritmo de aprendizagem de máquina

# Como se usa?

Para usar este script, é simples, passe os parâmetros:

- `--lang=<idioma>` Que é o idioma a ser usado para o processamento de linguagem natural.
- `--database=<banco-de-dados>` O banco de dados ou modelo de linguagem a ser usado para o processamento.
- `--prefix=<prefixo>` Forneça um prefixo a ser adicionado ao texto de entrada, geralmente um verbo como "Pesquise" ou um comando inteiro seguido por `,` (opcional)

Exemplo de input:

```bash
lua5.4 idris.lua --lang=pt_BR --database=demonstration \
  'crie o arquivo teste.txt, coloque nele a frase Olá Mundo!, abra no kate e mova ele para /tmp'
```

Exemplo de saída:

```bash
echo -n > 'teste.txt'
echo -n 'Olá Mundo!' >> 'teste.txt'
'kate' 'teste.txt'
mv 'teste.txt' '/tmp'
```

# Funcionamento

A entrada é dividida em palavras individuais (nesse contexto , é considerada uma palavra), depois, palavra por palavra são identificados verbos, substantivos e outros elementos da linguagem e por fim, o `Idris` busca cria modelos de comando usando os verbos e substantivos identificados e substitui espaços reservados nos modelos por palavras correspondentes da entrada. Feito isso o comando é exibido

# Configuração

A configuração é feita através de bancos de dados na pastas `databases`, esses bancos de dados nada mais são que scripts `Lua` que definem uma tabela global chamada `DB` seguindo o padrão:

```lua
["verbo"] = {
  [0] = "Resposta para caso um substantivo conhecido não for especificado",
  ["substantivo"] = {
    [0] = "Resposta para caso a entrada tenha substantivo sem especificador",
    ["especificador"] = {
      [0] = "Resposta para caso a entrada tenha substantivo com especificador",
    }
  }
}
```

Use `\0{1}` para obter o valor após o verbo, `\0{1}` para o valor após o substantivo e `\0{3}` para o valor após o especificador

# Dependências

Este script depende apenas do interpretador padrão da linguagem `Lua`, na versão 5.4 ou posterior, versões anteriores podem funcionar mas não foram testadas:

# Licença
Este script é fornecido sob uma licença de código aberto. Você pode encontrar os detalhes da licença no arquivo LICENSE incluído neste projeto.

# Feedback e Contribuições
Sinta-se à vontade para fornecer feedback, relatar problemas ou contribuir para este projeto abrindo problemas ou solicitações de pull no GitHub. Suas contribuições são bem-vindas e apreciadas.

# TODO

- [x] Mais de 3 níveis de especificação
- [ ] Gerar bancos de dados a partir de listas de exemplo


