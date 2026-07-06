# Golang Scripting 80/20 Quick Guide

This covers about 80% of what we need for Golang automation scripts.

## Run & Build
```sh
# run
go run main.go

# build
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-w -s" -o binary_name-linux-amd64 .

go mod download
go mod init <name>
go mod tidy
```

## Hello World

```go
package main

import "fmt"

func main() {
  fmt.Println("Hello World!")
}
```

## Variables & Constants

```go
package main

import "fmt"

const Country = "UAE"
var f float64 = 3.33

func main() {
  // or preferred
  s := "Salman"
  i := 123
  b := true

  fmt.Println(Country, f, s, i, b)
}
```

## Conditionals

```go
package main

import "fmt"

func main() {
  name := "salman"

  // if / else
  if name == "salman" {
    fmt.Println("Hello")
  } else if name == "guest" {
    fmt.Println("Guest")
  } else {
    fmt.Println("Unknown")
  }

  // switch with different values
  switch name {
  case "salman", "sara":
    fmt.Printf("Hello, %s\n", name)
  case "guest":
    fmt.Println("Guest")
  default:
    fmt.Println("Unknown")
  }

  // switch with conditions
  age := 16
  switch {
  case age < 13:
    fmt.Println("Child")
  case age >= 13 && age < 20:
    fmt.Println("Teenager")
  default:
    fmt.Println("Adult")
  }
}
```

## Loops

```go
package main

import "fmt"

func main() {
  // with maps
  maps := map[string]any{"k1": 10, "k2": "salman", "k3": true, "k4": "waheed"}
  for k, v := range maps {
    fmt.Println(k, "=", v)
  }

  // with slices
  slices := []any{10, "salman", true, "waheed"}
  for i, v := range slices {
    fmt.Println(i, "=", v)
  }

  // with number
  for n := range 5 {
    fmt.Println(n)
  }

  // with index
  for i := 1; i < 5; i++ {
    fmt.Println(i)
  }
}
```

## Error Handling & Exit

```go
// Handle error
if err != nil {
  fmt.Println(err)
  return // inside a function
}

// Exit program
os.Exit(0) // success
os.Exit(1) // error
```

## Functions

```go
package main

import (
  "errors"
  "fmt"
)

func greet(name string) (string, error) {
  if name == "" {
    return "", errors.New("name is required")
  }

  return "Hello, " + name, nil
}

func main() {
  name, err := greet("Salman")
  if err != nil {
    fmt.Println(err)
    return
  }

  fmt.Println(name)
}
```

## Strings

```go
package main

import (
  "fmt"
  "strings"
)

func main() {
  s := "HellO World, HellO World, world world"

  fmt.Println(len(s)) // length
  fmt.Println(s[1:3]) // substring

  fmt.Println(strings.ReplaceAll(s, "HellO", "hi")) // replace all matches

  fmt.Println(strings.ToLower(s)) // lowercase
  fmt.Println(strings.ToUpper(s)) // uppercase

  fmt.Println(strings.TrimSpace(s)) // remove left/right spaces

  parts := strings.Split(s, ", ") // string to slice
  fmt.Println(parts)

  fmt.Println(strings.Join(parts, ",")) // slice to string

  fmt.Println(strings.HasPrefix(s, "HellO")) //
  fmt.Println(strings.HasSuffix(s, "world")) //
  fmt.Println(strings.Contains(s, "salman")) //
}
```

## Arrays

array is fixed-size, but its elements are mutable.

- You can update elements.
- You cannot add or remove elements.
- You cannot change its size.

```go
package main

import "fmt"

func main() {
  arr := [4]any{10, "salman", true, "waheed"}

  fmt.Println(len(arr)) // length
  fmt.Println(arr)      // all elements
  fmt.Println(arr[0])   // first element

  arr[1] = "--SALMAN--" // update

  fmt.Println(arr)
}
```

## Slices

A slice is a dynamic array. It can grow and shrink.

```go
package main

import "fmt"

func main() {
  slice := []any{10, "salman", true, "waheed"}

  fmt.Println(len(slice)) // length
  fmt.Println(slice)      // all elements
  fmt.Println(slice[0])   // first element

  slice[1] = "--SALMAN--"                   // update
  slice = append(slice, "--HELLO--")        // append/insert
  slice = append(slice[:2], slice[2+1:]...) // remove/unset

  fmt.Println(slice)
}
```

## Maps

Maps store key → value pairs.

```go
package main

import "fmt"

func main() {
  maps := map[string]any{"k1": 10, "k2": "salman", "k3": true, "k4": "waheed"}

  fmt.Println(len(maps))  // length
  fmt.Println(maps)       // all key/value pairs
  fmt.Println(maps["k1"]) // get value

  maps["k2"] = "--SALMAN--" // update
  maps["k5"] = "--HELLO--"  // add
  delete(maps, "k3")        // remove

  fmt.Println(maps)
}
```

## Environment Variables

```go
package main

import (
  "fmt"
  "os"
)

func main() {
  // export API_KEY=my-api-key

  fmt.Println(os.LookupEnv("API_KEY"))
  fmt.Println(os.Getenv("API_KEY"))
}
```

## Structs

A custom data type (like a simple object).

```go
package main

import "fmt"

type User struct {
  Name string
  City string
}

// Method
func (u *User) Greet() string {
  return fmt.Sprintf("Hello %s\n", u.Name)
}

func main() {
  u := &User{
    Name: "Salman",
    City: "Dubai",
  }

  fmt.Printf("%+v\n", u)
  fmt.Println(u.Greet())
}
```

<!-- - Pointers (only basics) -->
<!-- - YAML/JSON -->
<!-- - Files -->
<!-- - HTTP -->
<!-- - CLI Arguments -->
<!-- - Log -->
<!-- - Time -->
<!-- - Packages -->
<!-- - Modules -->
<!-- - Interfaces (basic) -->
<!-- - Concurrency (goroutine + channel only basics) -->
