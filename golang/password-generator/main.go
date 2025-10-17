package main

import (
	"flag"
	"fmt"
	"log"
	"myapp/passgen"
	"os"
)

func main() {
	length := flag.Int("length", 12, "Length of the password")
	upper := flag.Bool("upper", false, "Include uppercase letters")
	numbers := flag.Bool("numbers", false, "Include numbers")
	symbols := flag.Bool("symbols", false, "Include symbols")
	delimiter := flag.String("delimiter", "", "Delimiter for grouping characters ('-' OR '_')")
	groupSize := flag.Int("group", 0, "Group size for delimiter (minimum 6)")

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, `PassGen - Simple Password Generator`)
		fmt.Printf("\n\nUsage:\n  passgen [options]\n\n")
		fmt.Println("Options:")
		flag.PrintDefaults()
	}

	flag.Parse()

	if (*delimiter != "" && *groupSize == 0) || (*delimiter == "" && *groupSize > 0) {
		log.Fatal("Both --delimiter and --group must be provided together")
	}

	cfg := passgen.Config{
		Length: *length,
		IncludeUpper: *upper,
		IncludeNumbers: *numbers,
		IncludeSymbols: *symbols,
		Group: passgen.Group{
			Delimiter: *delimiter,
			Size: *groupSize,
		},
	}

	pass, err := passgen.Generate(&cfg)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(pass)
}
