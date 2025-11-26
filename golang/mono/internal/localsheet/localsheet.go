package localsheet

import (
	"encoding/csv"
	"fmt"
	"os"
)

func SaveFile(name string, rows [][]string) error {
	file, err := os.Create(name)
	if err != nil {
		return fmt.Errorf("cannot create file: %w", err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	// if err := writer.Write(headers); err != nil {
	// 	return fmt.Errorf("cannot write headers: %w", err)
	// }

	if err := writer.WriteAll(rows); err != nil {
		return fmt.Errorf("cannot write rows: %w", err)
	}

	return nil
}
