# Bash Scripting 80/20 Quick Guide

This covers about 80% of what we need for Bash automation scripts.

## To run script

```bash
chmod +x ./script.sh
./script.sh
```

## Shebang & Basic Script

```bash
#!/bin/bash           # shebang line, always at top
echo "Hello World"    # print text
```

## Brace Expansion

```bash
echo {1..7}     # 1 2 3 ... 7
echo {a..h}     # a b c ... h
echo {5..50..5}  # 5 10 15 ... 50
echo {x,y}.txt   # x.txt y.txt
```

## Variables

```bash
name="Salman"
echo "$name"                  # access variable
readonly LAST_NAME="Waheed"   # constant, immutable: "assign-new-value=no", "unset-variable=no", "in-place-update=yes"
unset name                    # remove variable
echo "NAME: ${name}"          # returns only NAME:

LAST_NAME="hello"             # error
echo "${LAST_NAME/Wa/w}"      # prints "wheed"
echo "$LAST_NAME"             # still "Waheed"
```

## Operators

* Arithmetic: `+ - * / % **`
* Regex: `=~`
* Comparison: `== != > < >= <=` or `-eq  -ne  -gt  -ge  -lt  -le`
* Logical: `! && ||`
* Assignment: `=, +=, -=, *=, /=`
* File Test: `-e -f -d `
* Check if a key exists: `-v dict[key]`

## Reading Input

```bash
read -p "Enter name: " user
echo "Hello $user"
```

## Conditionals

* Use `[ ... ]` if you want portable (POSIX) shell scripts.
* Use `[[ ... ]]` if you are writing Bash scripts and want `regex`, `OR/AND`, or `safer comparisons`.

```bash
user="Salman"
if [[ "$user" =~ ^(Salman|Sara)$ ]]; then
  echo "Welcome!"
elif [[ "$user" == "Guest" || "$user" == "Visitor" ]]; then
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
arr=(11 22 33 44 55)
for i in ${!arr[@]}; do
  echo index=$i value=${arr[i]}
done

# For loop with dict
declare -A dict=([k1]=11 [k2]=22 [k3]=33 [k4]=44 [k5]=55)
for k in ${!dict[@]}; do
  echo key=$k value=${dict[$k]}
done

# For loop with brace expansion
for i in {1..5}; do
  echo $i
done

# For loop with regex
for file in $(ls -1 *.txt | grep -v file.txt); do
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

name=""
[ -z "${name}" ] && echo "cannot be empty!" || echo "Hi, ${name}!"

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

echo ${my_var:-"default val"}
echo ${my_var:?"any msg"}

# title case
for w in "${str[@]}"; do
  echo -n "${w^} "
done
```

## Arrays

```bash
arr=(10 "salman" true "waheed")

echo ${#arr{@}}           # length
echo ${arr[@]}            # all values
echo ${!arr[@]}           # all indexes
echo ${arr[0]}            # first element

arr+=("--HELLO--")        # append/insert
arr[1]="--SALMAN--"       # update
unset arr[0]              # remove / unset
```

## Dictionary

Must use bash v4.0 or above version or use zsh.

```bash
declare -A d=( [k1]=10 [k2]="salman" [k3]=true [k4]="waheed" )

echo ${#dict{@}}           # length
echo ${dict[@]}            # all values
echo ${!dict[@]}           # all keys
echo ${dict["k2"]}         # get

dict[k5]="--HELLO--"       # add/insert
dict[k2]="--SALMAN--"      # update
unset dict[k1]             # remove / unset
```

## Exit & Error Handling

```bash
exit 0  # success
exit 1  # error

# Try to create folder (must fail if typo, like: "mkdi" not "mkdir")
mkdi $HOME/my-test 2>>errors.log || { echo "Failed to create folder!"; exit 1; }

echo "Folder created successfully!"
exit 0
```
