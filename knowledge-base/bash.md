# Bash Scripting 80/20 Quick Guide

This is everything we need for 80% of the Bash Scripting tasks.

## To run script

```bash
chmod +x ./script.sh
./script.sh
```

## Shebang & Basic Script

```bash
#!/bin/bash           # shebang line, always at top
echo "Hello World"    # print text
echo {1..7}           # brace expansion, print 1 to 7 numbers: 1 2 3 4 ...
echo {a..h}           # brace expansion, print a to h letters: a b c d ...
```

## Variables

```bash
name="Salman"
echo "$name"                  # access variable
readonly LAST_NAME="Waheed"   # constant, immutable: "assign-new-value=no", "unset-variable=no", "in-place-update=yes"
unset name                    # remove variable

LAST_NAME="hello"             # error
echo "${LAST_NAME/Wa/w}"      # prints "wheed"
echo "$LAST_NAME"             # still "Waheed"
```

## Operators

* Arithmetic: `+ - * / % **`
* Comparison: `== != > < >= <=` or `-eq  -ne  -gt  -ge  -lt  -le`
* Logical: `! && ||`
* Assignment: `=, +=, -=, *=, /=`
* File Test: `-e -f -d `

## Reading Input

```bash
read -p "Enter name: " user
echo "Hello $user"
```

## Conditionals

```bash
user="Salman"
if [ "$user" == "Salman" ]; then
  echo "Welcome!"
elif [ "$user" == "Guest" ]; then
  echo "Hello Guest"
else
  echo "Who are you?"
fi

# shorthand
[ "$user" == "Salman" ] && echo "Hi Salman"
```

## Loops

- for loop → over a fixed list
- while loop → until some condition stops

```bash
# For loop with array
for i in 1 2 3 4 5; do
  echo $i
done

# For loop with brace expansion
for i in {1..5}; do
  echo $i
done

# For loop with regex
for file in *.txt; do
  echo $file
done

# For loop with increment (c++), decrement (c--)
for ((c=1; c<5; c++)); do
  echo $c
done

# While loop
count=1
while ((count<5)); do # OR: [ $count -le 3 ]
  echo $count
  # ((count--))   # decrement
  ((count++))   # increment
done

# Read lines from file
while read -r line; do
  echo "$line"
done < file.txt
```

## Functions

```bash
name="World" # global var
greet() {
  local name="$1" # local var
  echo "Hi, $name!"
}
greet "Salman"      # prints "Hi, Salman!"
echo "$name"        # prints "World"
```

## File Operations

```bash
# Check if file / dir exists
[ -f file.txt ] && echo "File exists!" || echo "File not found!"
[ -d dir ] && echo "Directory exists!" || echo "Directory not found!"

# Create / Delete
touch file.txt
rm file.txt
```

## Command Substitution

```bash
today=$(date)
echo "Today is $today"
```

## Strings

```bash
str="HellO World, HellO World, world world"

echo ${#str}            # length
echo ${str:1:3}         # substring

echo ${str/HellO/hi}    # replace first match, parameter expansion
echo ${str//HellO/hi}   # replace all matches, parameter expansion

echo ${str/Hel/}        # remove first match, parameter expansion
echo ${str//World/}     # remove all matches, parameter expansion

echo ${str,,}           # lowercase
echo ${str^^}           # uppercase
echo ${str^}            # first letter uppercase
echo ${str,}            # first letter lowercase
```

## Arrays

```bash
arr=(10 "salman" true "waheed")

echo ${#arr{@}}           # length
echo ${arr[@]}            # all elements
echo ${arr[0]}            # first element

arr+=("--HELLO--")        # append/insert
arr[1]="--SALMAN--"       # update
unset arr[1]              # remove / unset
```

## Exit & Error Handling

```bash
exit 0  # success
exit 1  # error

# Try to create folder (must fail if typo, like: "mkdi" not "mkdir")
mkdi $HOME/my-test || { echo "Failed to create folder!"; exit 1; }

echo "Folder created successfully!"
exit 0
```
