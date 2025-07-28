# 🧠 `Venom`: A CLI Framework

This project demonstrates a minimal but extensible implementation of a command-line interface (CLI) using the custom `VenomCLI` class from the `venom.cli` module.

## Features
- Root-level options.
- Subcommands with and without options.
- Basic logging integration.
- Usable in any Python project.
- Can be installed locally or from GitHub.
- Can be compiled to a binary using Nuitka.

---

## Project Structure

```
venom/
├── README.md
├── requirements.txt
├── main.py
└── venom
    ├── cli.py
    ├── formatter.py
    ├── __init__.py
    ├── logger.py
    └── utils.py
```

---

## Install and Use Locally

### A. Create virtual environment
```sh
cd venom
python3 -m venv .venv
source .venv/bin/activate
```

### B. Install the package
```sh
# Install from venom folder
pip install --user --editable . -r requirements.txt
# Or if system blocks pip:
# pip install --break-system-packages --user --editable . -r requirements.txt

# Install from GitHub (optional)
pip install git+https://github.com/salmanwaheed/venom.git
```

### C. Use it in an another project (`my-cli/main.py`)
```sh
mkdir my-cli
cd my-cli
touch main.py
```

#### Add the following code to `main.py`.

```python
from venom.cli import VenomCLI
import logging

cli = VenomCLI(name="you-cli", desc="your cli tool")
cli.verbose()
cli.version("0.1.0", command=True)

# root option without custom function, no subcommand
# cli.root_option("--help", action="help", help="show this help message and exit")

# root options with custom function, no subcommand
@cli.root_option("--src", help="src path")
@cli.root_option("--dest", help="dest path")
def my_file(src, dest):
  print("{} {} {}".format(my_file.__name__, src, dest))

# subcommand with options
@cli.command(name="just-print", help="just-print my name")
@cli.option('--first-name', help="Your first name")
@cli.option('--last-name', help="Your last name")
def print_my_name(first_name, last_name):
  print(f"Hello {first_name} {last_name}!")
  logging.debug("Debug message")
  logging.info("Info message")
  logging.info(f"{print_my_name.__name__}: {first_name} {last_name}")
  logging.warning("Warning message")
  logging.error("Error message")
  logging.critical("Critical message")
  logging.success("Critical message")

# subcommand without options
@cli.command(name="file-path", help="just-print version")
def my_file_path():
  print(f"{my_file_path.__name__}: logic is here")

cli.run()
```

#### Run it:
```sh
python3 main.py
python3 main.py just-print --first-name Salman --last-name Waheed
# output: Hello Salman Waheed!

python3 main.py version
# output: your-cli v0.1.0
```

---

## Compile with Nuitka (Optional)

### Install Nuitka:
```sh
pip install nuitka --user
# Or if system blocks pip:
# pip install nuitka --user --break-system-packages
```

### Compile:
```sh
# If installing from venom folder
# export PYTHONPATH=/full/path/to/venom/venom
nuitka \
  --quiet \
  --standalone \
  --onefile \
  --include-plugin-directory=/full/path/to/venom/venom \
  --output-dir=./dist \
  --output-filename=my-cli \
  main.py

# Once package is compiled, unset environment variable
# unset PYTHONPATH
```

### Run the binary
```sh
./dist/my-cli # on Linux & MacOS
```

## To remove package
```sh
pip3 uninstall venom --break-system-packages
rm -rf ./dist
```
