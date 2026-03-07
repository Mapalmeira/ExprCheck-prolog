<div align="center">

# Lexical-Syntactic Validator and Evaluator of Mathematical Expressions

[Read in Portuguese](README.md)

![Language](https://img.shields.io/badge/Language-Prolog-f28c28?style=for-the-badge&logo=prolog)
![Paradigm](https://img.shields.io/badge/Paradigm-Logical-5a3ea1?style=for-the-badge)
![Institution](https://img.shields.io/badge/Institution-UFCG-009639?style=for-the-badge)

<p align="center"> <b>Project developed for the Programming Language Paradigms course.</b> </p> </div>

</div>

---

## 1. Overview

This project implements an analyzer capable of validating and evaluating mathematical expressions from the lexical and syntactic perspectives, using Prolog as the implementation language.

The purpose of this work is to formally model a Context-Free Grammar (CFG) and implement it through declarative rules, exploring the foundations of the Logic Programming paradigm. The system receives an expression as input, verifies whether it belongs to the defined language and, if valid, performs its evaluation while respecting operator precedence and associativity. The adopted approach takes advantage of the declarative nature of Prolog, where the structure of the rules themselves directly represents the grammar of the language.

---

## 2. Technical Specification

The validation process occurs in two well-defined stages: lexical analysis and syntactic analysis, both modeled in a declarative way.

### 2.1. Lexical Analysis (Scanning)

The input is processed as a sequence of characters that is converted into a list of valid tokens. Whitespace is ignored and any symbol that does not belong to the defined alphabet results in validation failure.

**Recognized Tokens:**

- **Literals:**  
  `TokInt` (integers), `TokReal` (floating-point numbers)

- **Operators:**  
  `TokPlus` (+), `TokMinus` (-), `TokStar` (*), `TokSlash` (/), `TokCaret` (^)

- **Delimiters:**  
  `TokLParen` (`(`) and `TokRParen` (`)`)

---

### 2.2. Syntactic Analysis (Parsing)

The syntactic analysis is implemented through recursive rules in Prolog, which directly represent the productions of the grammar. Operator precedence is controlled by the hierarchy of the rules themselves.

**Context-Free Grammar (BNF):**

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

## 3. Test Matrix

The table below presents some of the test cases used to validate the robustness of the analyzer. Note that the parser supports repeated unary operators (such as ++ or --), interpreting them correctly according to mathematical semantics.

| Input Expression | Result | Technical Justification |
|-----------------|--------|-------------------------|
| `1 + 2 * 3` | Accepted | Respects precedence: `*` is evaluated before `+`. |
| `(3 + 2) * 7` | Accepted | Correct use of parentheses for grouping. |
| `12.3 + 4.56` | Accepted | Correct recognition of real number literals. |
| `5 ^ -2` | Accepted | Unary operator correctly applied to the exponent. |
| `5 ++ 5` | **Accepted** | Interpreted as addition with a positive value (`5 + (+5)`). |
| `(5 * 2` | Rejected | Syntax error: unbalanced parentheses. |
| `1 + @` | Rejected | Lexical error: symbol outside the valid alphabet. |

---

## 4. Execution Instructions

The project was developed using a standard Prolog interpreter, such as SWI-Prolog.

### Prerequisites

Before starting, make sure you have:

- **SWI-Prolog installed**
- **Git:** To clone the repository.

### Installation

1. Open the terminal and clone the repository:

```bash
git clone https://github.com/Mapalmeira/ExprCheck-prolog
```

2. Access the project directory:

```bash
cd ExprCheck
```

### Usage

The system uses **SWI-Prolog**. For the modules to load correctly, execution must start from the `src` folder.

The project provides two execution modes:

**1. Interactive Mode (CLI)**  
Allows expressions to be validated manually through the interactive menu.

Load the main project file:

```bash
swipl main.pl
```

The interactive menu will start. Follow the prompts on the screen to validate the expressions:

```bash
Digite a expressão a validar: (1 + 2) * 3 ^ 2

Selecione o nível de verificação:
A) Léxico
B) Sintático
Escolha (A/B): B
```
**2. Test Mode**  
It is also possible to run the automated project tests, located in the test folder.

Run the parser tests with the command:

```bash
swipl -g "run_parser_tests, halt" test/parser_tests.pl
```

Run the lexer tests with the command:

```bash
swipl -g "run_parser_tests, halt" test/lexer_tests.pl
```

Run all tests with the command:

```bash
swipl -g "run_all_tests, halt" test/run_all_tests.pl
```

---

## 5. Authors

- [Andrey Kaua Aragao Feitosa](https://github.com/Andrey-Kaua)
- [Erik Alves Almeida](https://github.com/ErikAlvesAlmeida)
- [Isadora Beatriz Lucena de Medeiros](https://github.com/isadoralucena)
- [João Henrique Silva Lima](https://github.com/limajoaohs)
- [Matheus Palmeira Leite Rocha](https://github.com/Mapalmeira)