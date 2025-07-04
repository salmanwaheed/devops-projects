# 🧠 `rome-cli`: A Modular, Dynamic Python CLI Framework

A lightweight and extensible Python CLI framework for building secure, configurable, and compiled command-line tools using `argparse`, `YAML` config, and dynamic subcommand discovery - ready for use with **Nuitka**.

---

## Features
- Modular structure: `main.py → cli.py → app.py or commands/*.py → other modules (e.g. gdrive.py, libs.py)`.
- Loads configuration from YAML: `/etc/rome-cli/config.yml` (or custom via `--config`).
- Full debug mode with `--debug`, silent by default.
- Disables `.pyc` / `__pycache__` clutter.
- Supports Nuitka compilation: `--onefile`, native binary.
- Dynamic subcommand discovery via `rome_cli/commands/` directory.
- Fallback support to default `app.py` if no subcommands.
- Can be reused in other CLI projects (e.g. `your-cli`) by installing as a Python package.

---

## Project Structure

```
rome-cli/
│
├── rome_cli/
│   ├── __init__.py
│   ├── app.py               # fallback/default command
│   ├── cli.py               # CLI logic
│   ├── config.py            # loads YAML config
│   ├── formatter.py         # SmartHelpFormatter
│   ├── logger.py            # logging setup
│   └── commands/            # dynamically loaded subcommands
│       ├── __init__.py
│       ├── sub_01.py
│       └── sub_02.py
│
├── config.yml               # default config file
├── main.py                  # CLI entry point
├── requirements.txt
├── install.sh               # install & build binary
├── uninstall.sh             # uninstall binary
├── test.sh                  # only for me 😂
└── README.md                # documentation
```

---

## Installation

### Production (Nuitka Binary)

```bash
git clone --no-checkout git@github.com:salmanwaheed/devops-projects.git ./rome-cli
cd ./rome-cli
git sparse-checkout init --cone
git sparse-checkout set python/rome-cli
git checkout
# mv ./python/rome-cli/* . && rm -rf python

./install.sh

# run as binary
rome-cli --help
rome-cli --debug --zoo where?
rome-cli --config ./path/to/config.yml
rome-cli sub-01 --foo bar
```

### Development

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

python3 -m main --help
python3 -m main sub-01 --foo bar --debug
```

---

## Creating New Subcommands

Each file inside `rome_cli/commands/` defines a subcommand. Each module **must define** these three functions:

```python
def add_args(parser): ...
def run_app(args, config): ...
def register_subparser(subparsers, add_sub): ...
```

### Example: `rome_cli/commands/sub_01.py`

```python
def add_args(parser):
  parser.add_argument("--foo", help="foo value")

def run_app(args, config):
  print(f"Running sub-01 with {args.foo}")
  # You can access shared YAML config here

def register_subparser(subparsers, add_sub):
  add_sub(subparsers, "sub-01", "Run sub-command 01", add_args, run_app)
```

---

## Fallback to `app.py`

If no valid subcommand is detected, the app falls back to `rome_cli/app.py`.
This file must define at least:

```python
def add_args(parser):
  parser.add_argument("--zoo", help="zoo value")

def run_app(args, config):
  print(f"Running default / fallback command with {args}")
  # You can access shared YAML config here
```

This lets `rome-cli` behave like a single-command CLI when no subcommands exist.

---

## Reusing `rome-cli` in Another Project (e.g. `your-cli`)

### Step 1: Package `rome-cli`

```bash
pip install -e /path/to/rome-cli
```

### Step 2: Use in Your Project

In `your-cli/main.py`, simply:

```python
from rome_cli.cli import main

if __name__ == "__main__":
  main()
```

Done - you now have `your-cli` reusing the whole `rome-cli` logic and structure.

---

## Useful Commands

```bash
# Run default logic
rome-cli

# Run subcommand
rome-cli sub-01 --foo bar

# Debug mode (shows errors, logs)
rome-cli sub-01 --debug --config ./config.yml

# Use custom config file
rome-cli --config ./config.yml

# generate sample /etc/rome-cli/config.yml file
rome-cli --init-config
```

---

## Nuitka Compilation Notes

If you're using dynamic loading via `pkgutil` / `importlib`, you **must include subcommand packages manually**:

```bash
nuitka \
  --quiet \
  --follow-imports \
  --onefile \
  --output-dir=./dist \
  --output-filename=rome-cli \
  --include-package=rome_cli.commands \
  ./main.py
```

This ensures subcommands aren't stripped from the final binary.

---

## TODO / Suggestions

- [ ] Add optional plugin system.
- [ ] Add test suite for CLI.
- [ ] Publish to PyPI for easier reuse.
