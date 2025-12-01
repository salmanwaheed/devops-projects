# Python Scripting 80/20 Quick Guide

This is everything we need for 80% of the Python Scripting tasks.

## To run script

```bash
chmod +x ./script.py
./script.py

# OR, if no "shebang line" or" python3 interpreter" is defined
python3 ./script.py
```

## Shebang & Basic Script

```py
#!/bin/python3                # shebang line, always at top
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

for k,v in {"k1": "v1", "k2": "v2"}:
  print(f"{k}={v}")
```

## Functions

```py
def greet(name):
  print(f"Hi, {name}!")

greet(name="Salman") # prints "Hi, Salman!"
```

## File I/O

```py
# read, write and append
with open("file.txt", "a+") as f:
  f.write("hello world\n")

# read only
with open("file.txt", "r") as f:
  data = f.read()

print(data)
```

## Data Structure

### Strings

```py
str="HellO World, HellO World, world world"

print(len(str)) # length
print(str[1:3]) # substring

print(str.replace("HellO", "hi")) # replace all matches

print(str.lower()) # lowercase
print(str.upper()) # uppercase
print(str.title()) # titlecase
```

### List - unordered - mutable

```py
l = [10, "salman", True, "waheed"]

print(len(l))   # length
print(l)        # all elements
print(l[0])     # first element

l.append("--HELLO--")   # append/insert
l[1] = "--SALMAN--"     # update
l.pop(2)                # remove/unset # OR: del l[2]
```

### Dict

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


### Tuple - ordered - immutable

```py
t = (10, "salman", True, "waheed")

print(len(t))   # length
print(t)        # all elements
print(t[0])     # first element
```

### Set

```py
s = {10, "salman", True, "waheed"}

print(len(s)) # length
print(s)      # all elements
print(s[0])   # first element

s.add("--HELLO--") # append/insert
s.discard(2)       # remove/unset

s1 = {1, 2, 3}
s2 = {3, 4, 5}

print(s1 | s2) # union
print(s1 & s2) # intersection
print(s1 ^ s2) # symmetric difference
```

### Comprehensions (short & powerful)

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
