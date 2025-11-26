package cmd

import (
	"fmt"
	"time"

	"mono/internal/config"
	"mono/internal/database"
	"mono/internal/localsheet"

	"github.com/spf13/cobra"
)

var fileOutput string
var fileCategory string

var exportFileCmd = &cobra.Command{
	Use: "file",
	Short: "Export MongoDB data to local CSV file",
	RunE: func (cmd *cobra.Command, args []string) error {
		fmt.Printf("Exporting to CSV: %s, category: %s\n", fileOutput, fileCategory)

		fields := []string{"name", "email", "code", "telephone", "country", "nationality", "companyName", "salary", "category", "productTitle", "dateCreated", "lastUpdated"}

		cfgFile := "./config.yml"
		cfg, err := config.Load(cfgFile)
		if err != nil {
			return err
		}

		db := database.New(cfg.DatabaseUri)
		if err := db.Connect(); err != nil {
			return err
		}
		defer db.Disconnect()

		query := database.Query{Fields: fields, Category: fileCategory, DateCreated: time.Date(2025, 11, 24, 11, 0, 0, 0, time.UTC)}

		col := db.Collection("lead")
		rawDoc, err := col.Aggregate(query.Pipeline())
		if err != nil {
			return err
		}

		fmt.Println(rawDoc.ToRows(fields))

		return localsheet.SaveFile(fileOutput, rawDoc.ToCSV(fields))
	},
}

func init() {
	exportFileCmd.Flags().StringVar(&fileOutput, "output", "export.csv", "Output CSV file")
	exportFileCmd.Flags().StringVar(&fileCategory, "category", "", "Category to export")
	exportFileCmd.MarkFlagRequired("category")

	exportCmd.AddCommand(exportFileCmd)
}
