# Password Generator

A simple and secure password generator written in Go.
It uses `crypto/rand` for cryptographically secure random numbers.

---

## Project Structure
```text
.
├── go.mod # Go module file
├── main.go # Example usage of the password generator
└── passgen
    └── generator.go # The actual generator implementation
```

---

## Getting Started

- Both `-delimiter` and `-group` must be provided together

```sh
######## Development:
go mod init myapp # initialize a module
go run main.go -length 20 -upper -numbers -symbols # run the program

######## Production:
go build -ldflags="-w -s" -o ./bin/passgen main.go # build the program
./bin/passgen -length 20 -upper -numbers -delimiter "-" -group 6 # use anywhere
```
