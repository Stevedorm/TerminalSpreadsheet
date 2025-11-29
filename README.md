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
