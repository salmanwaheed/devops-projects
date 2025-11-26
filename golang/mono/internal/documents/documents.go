package documents

import (
	"fmt"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type New []map[string]any

func formatValue(v any) string {
	switch t := v.(type) {
		case nil:
			return ""
		case primitive.DateTime:
			return t.Time().Format("2006-01-02 15:04:05")
		default:
			return fmt.Sprintf("%v", v)
	}
}

// Convert "[]map" to "[][]any" for google sheets
func (docs New) ToRows(fields []string) [][]any {
	var rows [][]any

	for _, doc := range docs {
		row := make([]any, len(fields))
		for i, key := range fields {
			row[i] = formatValue(doc[key])
		}
		rows = append(rows, row)
	}

	return rows
}

// Convert "[]map" to "[][]string" for CSV
func (docs New) ToCSV(fields []string) [][]string {
	var rows [][]string

	for _, doc := range docs {
		row := make([]string, len(fields))
		for i, key := range fields {
			row[i] = formatValue(doc[key])
		}
		rows = append(rows, row)
	}

	return rows
}
