# Python Scripting 80/20 Quick Guide

This covers about 80% of what we need for Python automation scripts.

## To run script

```bash
chmod +x ./script.py
./script.py

# OR, if no "shebang line" or" python3 interpreter" is defined
python3 ./script.py
```

## Shebang & Basic Script

```py
#!/usr/bin/env python3        # shebang line, always at top
print("Hello World")          # print text
```

## Operators

* Arithmetic: `+ - * / // % **`
* Comparison: `== != > < >= <=`
* Logical: `and or not`
* Assignment: `=, +=, -=, *=, /=`

## Variables

```py
name="Salman"
print(f"Hello, {name}!")                  # access variable
print("Hello, {key}!".format(key=name))   # access variable with key
print("Hello, {}!".format(name))          # access variable without key

# old style
print("Hello, %s!" % name)
```

## Conditionals

```py
name = input("Your name: ").lower()

if name == "salman":
  print(f"Hello, {name.title()}!")
elif name == "guest":
  print("Hello, Guest!")
else:
  print("who are you?")
```

## Loops

```py
for i in range(1, 5):
  print(i, end=" ")

for i in [1, 2, 4, 5]:
  print(i, end=" ")

for i,v in enumerate([1, 2, 4, 5]):
  print(f"{i}={v}", end=" ")

for k,v in {"k1": "v1", "k2": "v2"}.items():
  print(f"{k}={v}")
```

## Functions

```py
def greet(name):
  print(f"Hi, {name}!")

greet(name="Salman") # prints "Hi, Salman!"
```

## Strings

```py
s="HellO World, HellO World, world world"

print(len(s)) # length
print(s[1:3]) # substring

print(s.replace("HellO", "hi")) # replace all matches

print(s.lower()) # lowercase
print(s.upper()) # uppercase
print(s.title()) # titlecase
```

## List - unordered - mutable

```py
l = [10, "salman", True, "waheed"]

print(len(l))   # length
print(l)        # all elements
print(l[0])     # first element

l.append("--HELLO--")   # append/insert
l[1] = "--SALMAN--"     # update
l.pop(2)                # remove/unset # OR: del l[2]
```

## Dict

```py
d = {"k1": 10, "k2": "salman", "k3": True, "k4": "waheed"}

print(len(d))                   # length
print(d)                        # all key/value pairs
print(d.get("k2", "default"))   # get value from key # OR: d["k2"]

print(d.keys())    # all keys
print(d.values())  # all values

d.update({"k2": "--SALMAN---"})     # add/update key/value # OR: d["k2"] = "--SALMAN--"
d.pop("k3")                         # remove/unset # OR: del d["k3"]
```

## Tuple - ordered - immutable

```py
t = (10, "salman", True, "waheed")

print(len(t))   # length
print(t)        # all elements
print(t[0])     # first element
```

## Set

```py
s1 = {1, 2, 3}

print(len(s1))  # length
print(s1)       # all elements

s1.add(10)      # append/insert
s1.discard(2)   # remove/unset

s2 = {3, 4, 5}

print(s1 | s2) # union
print(s1 & s2) # intersection
print(s1 ^ s2) # symmetric difference
```

## Comprehensions (short & powerful)

```py
l = [x*2 for x in range(5)]     # list
s = {x for x in range(5)}       # set
d = {x:x*2 for x in range(5)}   # dict
```

## Error Handling

```py
try:
  name = "Salman"
  print(nam)
except Exception as e:
  print("[ERROR]:", e)
finally:
  print("Always run...")
```

## pathlib

```py
# https://docs.python.org/3/library/pathlib.html
from pathlib import Path

file = Path("file.txt")

print(file.name)
print(file.parent)
print(file.exists())
print(file.is_file())
print(Path(".").is_dir())

print(file.resolve())
print(Path("~/").expanduser())

print(list(Path(".").glob("*.txt")))

Path("./new_dir").mkdir(parents=True, exist_ok=True)

file.write_text("Hello World\n")    # Write whole file (overwrites)
print( file.read_text() )           # Read whole file

# Append
with file.open("a") as f:
  f.write("hello world\n")

# Read line by line
with file.open("r", encoding="utf-8") as f:
  for line in f:
    print(line.strip())
```

## sys

```py
# https://docs.python.org/3/library/sys.html
import sys

sys.version     # Python version
sys.argv        # cli args
sys.path        # List of module search paths
sys.exit(1)     # Exit with error code 1

# Example: python script.py arg1 arg2
```

## subprocess

```py
# https://docs.python.org/3/library/subprocess.html
import subprocess

# Run a command
subprocess.run(["echo", "Hello World"])

# Capture output
result = subprocess.run(["ls", "-l"], capture_output=True, text=True)
print(result.stdout)

# Check for errors
result = subprocess.run(["ls", "non-existent"], capture_output=True, text=True)
print(result.returncode) # 0 if success, >0 if error
```

## YAML / JSON / jmespath

```py
# https://pyyaml.org/wiki/PyYAMLDocumentation
# needs PyYAML installed
import yaml, json

data = {
  "users": [
    {"name": "Salman", "role": "admin"},
    {"name": "Sara", "role": "user"},
  ]
}

# YAML
yaml_str = yaml.dump(data)                      # Convert dict → YAML string
print(yaml_str)
print(yaml.safe_load(yaml_str))                 # Convert YAML string → dict

yaml.dump(data, open("data.yml", "w"))          # Write dict → YAML file
print(yaml.safe_load(open("data.yml", "r")))    # Read YAML file → dict

# JSON
# https://docs.python.org/3/library/json.html
json_str = json.dumps(data)                     # Convert dict → JSON string
print(json_str)
print(json.loads(json_str))                     # Convert JSON string → dict

json.dump(data, open("data.json", "w"))         # Write dict → JSON file
print(json.load(open("data.json", "r")))        # Read JSON file → dict

# JEMS PATH / like SQL for JSON
# - rows        → []
# - WHERE       → ?condition
# - SELECT      → {}
# - pipeline    → |
#
# Example: → aws ec2 describe-instances --query "Reservations[].Instances[?State.Name=='running'].InstanceId"

# https://jmespath.org
jmespath.search("users[?role=='admin'].name", data)
# Output: ["Salman"]
```

## requests

```py
# https://requests.readthedocs.io/en/latest
# pip install requests
import requests

headers = {"x-api-key": "<YOUR_API_KEY>"} # {"Authorization": "Bearer <YOUR_API_KEY>"}
url = "https://api.example.com/data"
payload = {'k1':'v1','k2':'v2'}

r = requests.post(url, headers=headers, [json|data]=payload)
print(r)

r = requests.get(url, headers=headers, timeout=10)
print(r.status_code, r.json())

```

## logging

```py
# https://docs.python.org/3/library/logging.html
import logging

# Save logs to a file
logging.basicConfig(
  filename="my-app.log",                              # log file name
  filemode="a",                                       # append mode ('w' to overwrite)
  level=logging.INFO,                                 # minimum log level
  format="%(asctime)s - %(levelname)s - %(message)s"  # log format
)

logging.info("Starting script...")
logging.warning("This is a warning")
logging.error("This is an error")
```

## datetime

```py
# https://docs.python.org/3/library/datetime.html
from datetime import datetime, timezone

now         = datetime.now(timezone.utc)
today_at_11 = datetime(2026, 1, 5, 11, 0, 0, 0, timezone.utc)
```
