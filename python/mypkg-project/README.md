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
├── requirements.txt
└── README.md
```

---

## Install and Use Locally

```sh
# Create virtual environment
cd mypkg-project
python3 -m venv .venv
source .venv/bin/activate

# Install package and dependencies
pip install --editable .
pip install -r requirements.txt

# Run the script
python3 main.py
# Output: Hello, Salman
```

## Use this library in an another project (`my-new-pkg`)

```sh
mkdir my-new-pkg
cd my-new-pkg

# Create virtual environment
# Install package and dependencies

cat <<'EOF' > main.py
from mypkg.core import hello

print(hello(name="Salman"))
EOF

# Run the script
python main.py
# Output: Hello, Salman
```

---

## Make a Binary file

```sh
# Build and compile a binary
docker build -f Dockerfile.deb -t deb .

# Copy binary file from Docker image to local machine
docker create --name tmp deb
docker cp tmp:/app/dist/mypkg ./mypkg-cli
docker rm -f tmp

# Run binary on local Debian-based OS
./mypkg-cli
```
