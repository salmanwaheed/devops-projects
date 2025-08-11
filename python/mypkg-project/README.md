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
pip3 install -r requirements.txt

# Run the script
python3 main.py
```

## Build before using in different projects

```sh
./build.sh
```

## Use this library in another project (`my-new-pkg`)

```sh
mkdir my-new-pkg
cd my-new-pkg

# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install the wheel package (adjust path as needed)
pip3 install /path/to/dist/<NAME>-<VERSION>-py3-none-any.whl

# Install dependencies if any
pip3 install -r requirements.txt

cat <<'EOF' > main.py
# read respective documentation
EOF

# Run the script
python main.py
```

---

## Make a Binary file

```sh
# Build and compile a binary
docker build -f Dockerfile.deb -t <NAME> .

# Copy binary file from Docker image to local machine
docker create --name tmp deb
docker cp tmp:/app/dist/<NAME>.bin .
docker rm -f tmp

# Run binary on local Debian-based OS
./<NAME>.bin
```

# Documentation

```python
from mypkg.core import hello

print(hello(name="Salman"))
```
