# 📝 Idris - 1.2 [![CI](https://github.com/natanael-b/idrish/actions/workflows/blank.yml/badge.svg)](https://github.com/natanael-b/idrish/actions/workflows/blank.yml)

<p align=center>

![](resources/idrish/print.png)
Idris é uma ferramenta que transforma instruções em linguagem natural em comandos de terminal executáveis

</p>

## ✨ Recursos

- **Tolerante a erros**, O Idris tolera um alto grau de erros de digitação sem que isso afete o resultado, por exemplo "pequizar" ainda será entendido como "pesquisar"
- **Leveza**, Idris roda em condições extremas de recursos consumindo menos de 30 MB de RAM e funcionando em CPUs com 400 MHz
- **Offline**, Idris está sempre disponível não depende de conexões com servidores externos
- **Fácil de estender**, forneça um input e o comando que espera sair separado por tab no arquivo `database.tsv`
- **Gratuito**, Idris é completamente gratuito você _não precisa_ pagar para usar
- **Software Livre**, com uma licença permissiva (MIT) você pode modificar, estender e embutir o Idris sem se preocupar
- **Ilimitado**, Como é 100% offline Idris não sofre com limites de uso
- **Instantâneo**, mesmo com bases enormes Idris é capaz de fornecer os comandos instantaneamente

## 📥 Instalação
Clone o repositório:

```bash
git clone https://github.com/natanael-b/idris.git
cd idris
```

> Idris depende de Lua para funcionar

## 🚀 Uso

1. No menu de apps procure por Idrish
2. Digite os prompts e pressione Enter

![](resources/idrish/print.png)

#### 🖋️ Sintaxe avançada 

```bash
lua5.4 idris.lua --lang=<código do idioma> --database=<banco de dados com comandos> [--prefix=<prefixo>] [--shell-output] [--verbose] [--help] 'entrada 1' 'entrada 2' ...
```

#### ⚙️ Opções

**Idioma e banco de dados**
- `--lang=<código do idioma>`: Especifica o idioma a ser usado.
- `--database=<banco de dados>`: Define a fonte dos comandos.
- `--prefix=<prefixo>`: Adiciona um prefixo opcional aos comandos.

**Execução e saída**
- `--shell-output`: Formata a saída para uso em scripts de shell.
- `--verbose`, `-v`: Ativa a saída verbosa.
- `--debug`, `-d`: Mostra a origem de cada comando no banco.

**Modos especiais**
- `--interactive`: Modo interativo.
- `--learn`: Modo de aprendizado para inserir novos comandos.

**Compilação**
- `--compile`, `-c`: Gera `database.lua` a partir de `datasheet.tsv`.
- `--update-idris-shell`, `-u`: Atualiza o `idris-shell.lua` após compilar.

- `--help`, `-h`: Exibe esta mensagem de ajuda.


### 📌 Exemplos

#### Básico
```bash
lua5.4 idris.lua --lang=pt_BR 'crie um arquivo test.txt e insira a frase Hello World nele!'
```
A saída esperada é:

```sh
touch 'test.txt';
echo 'Hello World' >> 'test.txt';
```


#### Modo interativo

Para entrar no modo interativo, execute o comando nenhuma entrada:

```
lua5.4 idris.lua --lang=pt_BR --database=idris-shell
```

### 📌 Exemplos

#### Básico
```bash
lua5.4 idris.lua --lang=pt_BR 'crie um arquivo test.txt e insira a frase Hello World nele!'
```
A saída esperada é:

```sh
touch 'test.txt';
echo 'Hello World' >> 'test.txt';
```
### 🧩 Estendendo

Estender o Idrish envolve editar o arquivo `datasheet.tsv` ou o arquivo passado com `--datasheet=` num formato específico, compilar usando `--compile` e atualizando com `--update-idri-shell`, isso pode ser complexo
se você não tiver familiariade com a ferramenta, para facilitar use o comando a seguir para iniciar um editor simplificado que pergunta as informações e formata:

```bash
lua5.4 idris.lua --learn
```

E esse para compilar e atualizar:

```
lua5.4 idris.lua --lang=pt_BR --compile --update-idri-shell
```

# 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou um pull request.

# 📜 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo LICENSE para mais detalhes.
