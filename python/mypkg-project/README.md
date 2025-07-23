# 🧠 `mypkg`: Python Package Guide

A simple guide to create, install, use, and compile a Python package locally or from GitHub.

---

## Features

- Function: `hello(name)` returns "Hello, <name>".
- Usable in any Python project.
- Can be installed locally or from GitHub.
- Can be compiled to a binary using Nuitka.

---

## Project Structure

```
mypkg-project/
├── mypkg/
│   ├── __init__.py
│   └── core.py
├── setup.py
├── pyproject.toml
└── README.md
```

---

## Install and Use Locally

### A. Create virtual environment
```sh
cd mypkg-project
python3 -m venv .venv
source .venv/bin/activate
```

### B. Install the package
```sh
# Install from mypkg-project folder
pip install --user --editable .
# Or if system blocks pip:
# pip install --break-system-packages --user --editable .

# Install from GitHub (optional)
pip install git+https://github.com/salmanwaheed/mypkg.git
```

### C. Use it in an another project (`my-new-pkg/main.py`)
```sh
mkdir my-new-pkg
cd my-new-pkg
touch main.py
```

#### Add the following code to `main.py`.

```python
from mypkg.core import hello

print(hello(name="Salman"))
```

#### Run it:
```sh
python main.py
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
# If installing from mypkg-project folder
# export PYTHONPATH=/full/path/to/mypkg-project/mypkg
nuitka \
  --quiet \
  --standalone \
  --onefile \
  --include-plugin-directory=/full/path/to/mypkg-project/mypkg \
  --output-dir=./dist \
  --output-filename=my-new-pkg \
  main.py

# Once package is compiled, unset environment variable
# unset PYTHONPATH
```

### Run the binary
```sh
./dist/my-new-pkg # on Linux & MacOS
```

## To remove package
```sh
pip3 uninstall mypkg --break-system-packages
rm -rf ./dist
```
