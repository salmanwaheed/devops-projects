package passgen

import (
	"crypto/rand"
	"errors"
	"math/big"
	"strings"
)

const (
	lowercase = "abcdefghijklmnopqrstuvwxyz"
	uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	numbers   = "0123456789"
	symbols   = "!@#$%^&*()-_=+[]{}<>?/|"
	DefaultLength = 12
)

type Group struct {
	Delimiter string // - OR _
	Size int // minimum 6 or above
}

type Config struct {
	Length int
	IncludeUpper bool
	IncludeNumbers bool
	IncludeSymbols bool
	Group Group
}

func Generate(c *Config) (string, error) {
	if c.Length == 0 {
		c.Length = DefaultLength
	}

	if c.Length < 4 {
		return "", errors.New("ERROR: password length must be at least 4 characters")
	}

	charset := lowercase
	charset += map[bool]string{true: uppercase}[c.IncludeUpper]
	charset += map[bool]string{true: numbers}[c.IncludeNumbers]
	charset += map[bool]string{true: symbols}[c.IncludeSymbols]

	password := make([]byte, c.Length)
	for i := range password {
		n, err := rand.Int(rand.Reader, big.NewInt(int64(len(charset))))
		if err != nil {
			return "", err
		}
		password[i] = charset[n.Int64()]
	}

	if c.Group.Delimiter != "" && c.Group.Size > 0 && !c.IncludeSymbols {
		valid := c.Group.Delimiter == "-" || c.Group.Delimiter == "_"
		if !valid {
			return "", errors.New("invalid delimiter, must be '-' or '_'")
		}

		if c.Group.Size < 6 {
			return "", errors.New("group size must be at least 6")
		}

		var parts []string
		for i := 0; i < len(password); i+=c.Group.Size {
			end := i + c.Group.Size
			if end > len(password) {
				end = len(password)
			}
			parts = append(parts, string(password[i:end]))
		}

		return strings.Join(parts, c.Group.Delimiter), nil
	}

	return string(password), nil
}
