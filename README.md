<div align="center">

# Validador e Avaliador Léxico-Sintático de Expressões Matemáticas

![Haskell](https://img.shields.io/badge/Language-Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
![Paradigm](https://img.shields.io/badge/Paradigm-Functional-orange?style=for-the-badge)
![UFCG](https://img.shields.io/badge/Institution-UFCG-009639?style=for-the-badge)

<p align="center"> <b>Projeto desenvolvido para a disciplina de Paradigmas de Linguagens de Programação.</b> </p> </div>
<p align="center">
  <a href="docs/readme_us.md">Read in English</a>
</p>

</div>

---

## 1. Visão Geral

Este projeto implementa um analisador capaz de validar e avaliar expressões matemáticas sob as perspectivas léxica e sintática, utilizando Prolog como linguagem de implementação.

A proposta do trabalho é modelar formalmente uma Gramática Livre de Contexto (GLC) e implementá-la por meio de regras declarativas, explorando os fundamentos do paradigma de Programação em Lógica. O sistema recebe uma expressão como entrada, verifica se ela pertence à linguagem definida e, sendo válida, realiza sua avaliação respeitando precedência e associatividade dos operadores.

A abordagem adotada aproveita a natureza declarativa do Prolog, onde a própria estrutura das regras representa diretamente a gramática da linguagem.
---

## 2. Especificação Técnica

O processo de validação ocorre em duas etapas bem definidas: análise léxica e análise sintática, ambas modeladas de forma declarativa.

### 2.1. Análise Léxica (Scanning)

AA entrada é processada como uma sequência de caracteres que é convertida em uma lista de tokens válidos. Espaços em branco são ignorados e qualquer símbolo que não pertença ao alfabeto definido resulta em falha na validação.

**Tokens reconhecidos:**

- **Literais:**  
  `TokInt` (inteiros), `TokReal` (números de ponto flutuante)

- **Operadores:**  
  `TokPlus` (+), `TokMinus` (-), `TokStar` (*), `TokSlash` (/), `TokCaret` (^)

- **Delimitadores:**  
  `TokLParen` (`(`) e `TokRParen` (`)`)

---

### 2.2. Análise Sintática (Parsing)

A análise sintática é implementada por meio de regras recursivas em Prolog, que representam diretamente as produções da gramática. A precedência de operadores é controlada pela própria hierarquia das regras.

**Gramática Livre de Contexto (BNF):**

```text
Exp     -> Sum EOF
Sum     -> Mul Sum'
Sum'    -> + Mul Sum' | - Mul Sum' | ε
Mul     -> Pow Mul'
Mul'    -> * Pow Mul' | / Pow Mul' | ε
Pow     -> Unary Pow'
Pow'    -> ^ Pow | ε
Unary   -> + Primary | - Primary | Primary
Primary -> INT | REAL | '(' Sum ')'
```

---

## 3. Matriz de Testes

A tabela a seguir apresenta alguns dos casos de teste utilizados para validar a robustez do analisador. Note que o parser suporta operadores unários repetidos (como ++ ou --), interpretando-os corretamente de acordo com a semântica matemática.

| Expressão de Entrada | Resultado  | Justificativa Técnica                                  |
| -------------------- | ---------- | ------------------------------------------------------ |
| `1 + 2 * 3`          | Aceito     | Respeita a precedência: `*` é avaliado antes de `+`.   |
| `(3 + 2) * 7`        | Aceito     | Uso correto de parênteses para agrupamento.            |
| `12.3 + 4.56`        | Aceito     | Reconhecimento correto de literais reais.              |
| `5 ^ -2`             | Aceito     | Operador unário aplicado corretamente ao expoente.     |
| `5 ++ 5`             | **Aceito** | Interpretado como soma de valor positivo (`5 + (+5)`). |
| `(5 * 2`             | Rejeitado  | Erro sintático: parênteses não balanceados.            |
| `1 + @`              | Rejeitado  | Erro léxico: símbolo fora do alfabeto válido.          |

---

## 4. Instruções de Execução

O projeto foi desenvolvido utilizando um interpretador Prolog padrão, como o SWI-Prolog.

### Pré-requisitos

Antes de iniciar, certifique-se de possuir:

- **SWI-Prolog instalado**
- **Git:** Para clonar o repositório.

### Instalação

1. Abra o terminal e clone o repositório:

```bash
git clone https://github.com/Mapalmeira/ExprCheck-prolog
```

2. Acesse o diretório do projeto:

```bash
cd ExprCheck
```

### Utilização

O projeto oferece dois modos de execução:

Abra o interpretador Prolog:

```bash
swipl
```

Carregue o arquivo principal do projeto:

```bash
?- consult('main.pl').
```

Execute a validação de uma expressão:

```bash
?- validar("1 + 2 * 3", Resultado).
```

---

## 5. Autores

- [Andrey Kaua Aragao Feitosa](https://github.com/Andrey-Kaua)
- [Erik Alves Almeida](https://github.com/ErikAlvesAlmeida)
- [Isadora Beatriz Lucena de Medeiros](https://github.com/isadoralucena)
- [João Henrique Silva Lima](https://github.com/limajoaohs)
- [Matheus Palmeira Leite Rocha](https://github.com/Mapalmeira)
