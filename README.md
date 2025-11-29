# TerminalSpreadsheet 🧮

A lightweight, terminal-based spreadsheet tool written in Python.  
TerminalSpreadsheet allows you to view, edit, and manipulate tabular data (CSV or custom delimited) right from the command line — perfect for quick edits, automation scripts, or remote environments without a GUI.

## Table of Contents

- [Features](#features)  
- [Why TerminalSpreadsheet?](#why-terminals­preadsheet)  
- [Requirements](#requirements)  
- [Installation](#installation)  
- [Usage](#usage)  
  - [Run from file](#run-from-file)  
  - [Interactive mode (REPL)](#interactive-mode-repl)  
- [Keybindings & Commands](#keybindings--commands)  
- [Example Session](#example-session)  
- [Contributing](#contributing)  
- [License](#license)  
- [Authors & Acknowledgments](#authors--acknowledgments)

---

## Features

- ✅ Open and edit CSV or delimited text data in the terminal  
- ✅ Move around cells, rows, columns  
- ✅ Add / remove rows or columns  
- ✅ Save modified data back to disk  
- ✅ Simple editing: change cells, insert values, delete data  
- ✅ Works on any system with Python — no GUI required  
- ✅ Keyboard-driven: minimal dependencies, fast interaction  

---

## Why TerminalSpreadsheet?

Sometimes you don’t need or don’t have access to a full GUI spreadsheet (Excel, LibreOffice, Google Sheets).  

- Remote servers, SSH sessions, or containers may lack a GUI.  
- Quick tweaks to CSV files — especially when automating workflows.  
- Light memory footprint, no heavy dependencies.  
- Terminal-first design — integrates nicely into existing command-line workflows.  

TerminalSpreadsheet fills that niche by giving you spreadsheet-like editing within a terminal UI.

---

## Requirements

- Ruby  
- (Optional) `pip install --user curses` / `windows-curses` if you’re on Windows and using the curses-based interface  

---

## Installation

```bash
git clone https://github.com/Stevedorm/TerminalSpreadsheet.git
cd TerminalSpreadsheet
# Optionally, create a virtual environment:
python3 -m venv venv
source venv/bin/activate     # on macOS / Linux
venv\Scripts\activate        # on Windows (PowerShell/CMD)
pip install --upgrade pip

