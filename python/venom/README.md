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

## Note
The development, build, and compile instructions are the same across all projects, differing only by project or package name and respective documentation.

Please follow the detailed guide here:
> https://github.com/salmanwaheed/devops-projects/blob/release/python/mypkg-project/README.md


## Documentation

```python
import logging
from venom.cli import VenomCLI

cli = VenomCLI(name="my-new-pkg", desc="my-new-pkg tool")
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
