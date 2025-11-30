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

The parser uses a precedence ladder (see `Parser#level8` … `levelN`) so expressions like:

```box
5 + 2 * 3 ** 2
```
are parsed correctly as 5 + (2 * (3 ** 2))

### Blocks & Statements

A **block** is a sequence of statements evaluated top-to-bottom:
```box
block
x = 10
y = x * 2
end
```


- Returns the **value of the final statement**
- AST form: `VexAST::Block.new(statements_array)`

Assignments:
```box
x = 5 + 3
```

Variables:
```box
x
```

AST forms:

- Assignment → `VexAST::Assignment.new(name, value)`
- Variable → `VexAST::Variable.new(name)`
---

### Control Flow

#### If / Else / End
```box
if x > 10
x * 2
else
0
end
```

Behavior:

- Evaluates the condition  
- Executes the `then` branch or the `else` branch  
- Returns the branch value  

AST form:

`VexAST::Conditional.new(condition, then_node, else_node)`

#### For-Each Loop (Cell Window Iteration)

Iterates through a rectangular region of spreadsheet cells:
```box
for v in [1, 1]..[3, 3]
v + 1
end
```

Range operators:

- `..` → inclusive range  
- `...` → exclusive range  

Execution:

- Iterates each cell in the rectangle  
- Binds iterator variable (`v`) to each cell’s value  
- Evaluates the block once per cell  
- Returns the **last evaluation result**

AST form:

`VexAST::ForEach.new(iter_name, range_op, start_address, end_address, block)`
---

### Functions

#### Type Casts
```box
int(x)
float(x)
```

AST:

- `VexAST::FloatToInt`
- `VexAST::IntToFloat`

#### Range-Based Statistical Functions

Operate on two cell-address pairs:
```box
=sum([1,1], [3,3])
=min([1,1], [3,3])
=max([1,1], [3,3])
=mean([1,1], [3,3])
```

AST:

- `VexAST::Sum`
- `VexAST::Min`
- `VexAST::Max`
- `VexAST::Mean`

#### Cell Access

Get a cell’s value:

#[row, col]

→ `VexAST::CellRValue`

Get a cell address literal:

[row, col]

→ `VexAST::CellLValue`

## Architecture

## Milestone 1 – Model

Key files:
<ul>
<li>vex_ast.rb – node hierarchy (primitives, ops, statements, blocks, control flow, functions)</li>

<li>runtime.rb / variable_runtime.rb – runtime environment for variables and functions</li>
</ul>
Features:
<ul>
<li>Abstract syntax tree with a common visit method on each node</li>

<li>Visitor pattern used for serialization and evaluation</li>

<li>Runtime manages variable bindings and function definitions</li>
</ul>
## Milestone 2 – Interpreter

Key files:
<ul>
<li>grammar.txt – BNF grammar for the Box language (with precedence ladder)</li>

<li>token.rb – token abstraction (type, lexeme, source indices)</li>

<li>lexer.rb – converts source text into a flat list of tokens</li>

<li>parser.rb – recursive descent parser builds AST out of tokens</li>
</ul>
The parser has helper methods:
<ul>
<li>parse – entry point for a program</li>

<li>has(type) – check current token type</li>

<li>advance – move forward</li>
</ul>

Left-associative operators are implemented with loops, right-associative with recursion. Parsing errors raise exceptions that include source locations.

## Milestone 3 – Interface

Key files:
<ul>
<li>TUIClass.rb</li>

<li>drawing_utils.rb</li>

<li>grid.rb, cell.rb</li>

<li>runtui.rb</li>
</ul>

The interface uses a Curses-style TUI to show:
<ul>
<li>A box where the user writes code in the Box language</li>

<li>A table of test cases (parameters and expected vs actual return values)</li>

<li>A panel to display printed output or error messages</li>

<li>Controls to run the program and update the table</li>
</ul>

## Milestone 4 – Control Flow

Final milestone adds:
<ul>
<li>Conditional, while, and for-each loop node types</li>

<li>Function definition, call, and return nodes</li>

<li>Support in the lexer, parser, and evaluator</li>

<li>Extended runtime (function table + lexical scope for calls)</li>
</ul>

## Getting Started

## Requirements

Ruby (2.7+ works fine)

A Curses implementation for Ruby (On many systems you can just <strong>gem install curses</strong>)

## Installation

git clone https://github.com/Stevedorm/TerminalSpreadsheet.git
cd TerminalSpreadsheet

# Install curses if needed
gem install curses

## Running the TUI

ruby runTUI.rb  # launch the Box / spreadsheet TUI

## Running Tests / Examples

ruby milestonetests.rb      # milestone 1 model tests
ruby milestone2tests.rb     # lexer/parser/evaluator tests
ruby demonstrate_errors.rb  # shows error handling & messages


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
