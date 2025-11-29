# TerminalSpreadsheet (Box Project)

This repository contains my **Box** project: a terminal-based “spreadsheet-style” coding environment with its own tiny programming language, implemented in **Ruby**.

Under the hood, the project is a miniature interpreter:

* an **abstract syntax tree (AST)** model for expressions and statements  
* a **runtime environment** that stores variables and functions  
* a **lexer & parser** that turn source code into ASTs  
* a **curses-based terminal UI** that lets you edit and run code in a “box” in the terminal

The project was developed in four milestones:

1. **Model** – AST & runtime
2. **Interpreter** – lexer, parser, evaluator
3. **Interface** – curses TUI
4. **Control Flow** – conditionals, loops, and functions

---

## Table of Contents

- [Language Overview](#language-overview)
  - [Primitives](#primitives)
  - [Operators](#operators)
  - [Blocks & Statements](#blocks--statements)
  - [Control Flow](#control-flow)
  - [Functions](#functions)
- [Architecture](#architecture)
  - [Milestone 1 – Model](#milestone-1--model)
  - [Milestone 2 – Interpreter](#milestone-2--interpreter)
  - [Milestone 3 – Interface](#milestone-3--interface)
  - [Milestone 4 – Control Flow](#milestone-4--control-flow)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Running the TUI](#running-the-tui)
  - [Running Tests / Examples](#running-tests--examples)
- [Project Files](#project-files)
- [Acknowledgments](#acknowledgments)

---

## Language Overview

Box is a small, dynamically-typed language designed for coding-challenge style problems, backed by an AST and visitor pattern.

### Primitives

The evaluator works with five primitive node types:

- `int` – integer values
- `float` – floating-point values
- `bool` – `true` / `false`
- `string` – text
- `null` – absence of value

All evaluation returns one of these model primitives (never raw Ruby types from the outside world).

### Operators

**Arithmetic**

- `+  -  *  /  %` – addition, subtraction, multiplication, division, modulo
- `**` – exponentiation
- unary `-` – numeric negation

**Logical**

- `&&` – logical and
- `||` – logical or
- `!` – logical not

**Bitwise**

- `&  |  ^` – bitwise and, or, xor
- `~` – bitwise not
- `<<  >>` – left and right shift

**Relational**

- `==  !=  <  <=  >  >=`

**Casts**

- `int(x)` – cast to integer
- `float(x)` – cast to float

The parser uses a precedence ladder with at least five levels so expressions like:

```box
5 + 2 * 3 ** 2
```

## Project Files

```text
.
├── README.md                # Project overview and usage instructions

├── vex_ast.rb               # AST node hierarchy (expressions, statements, control flow, functions)
├── runtime.rb               # Core runtime environment (variables, state)
├── variable_runtime.rb      # Variable / environment management helpers
├── evaluate.rb              # Evaluator visitor: walks AST and produces primitive values
├── serialize.rb             # Serializer / pretty-printer visitor for ASTs

├── token.rb                 # Token abstraction (type, lexeme, source locations)
├── lexer.rb                 # Lexer: source text → list of tokens
├── parser.rb                # Recursive-descent parser: tokens → AST
├── grammar.txt              # Box language grammar in BNF form

├── grid.rb                  # Spreadsheet-style grid model
├── cell.rb                  # Individual cell representation and behavior

├── TUIClass.rb              # Main curses-based TUI components
├── drawing_utils.rb         # Helpers for drawing windows, boxes, and UI elements
├── runtui.rb                # Entry point for launching the terminal UI

├── main.rb                  # Simple CLI entry point / demo runner
├── demonstrate_errors.rb    # Script to showcase error handling and messages

├── milestonetests.rb        # Milestone 1 tests (model / evaluation)
└── milestone2tests.rb       # Milestone 2 tests (lexer, parser, interpreter)
```
## Acknowledgments

This was a partner project, where <a href='https://github.com/jryder-nvr'>John Ryder</a> and I worked together to complete this project.
