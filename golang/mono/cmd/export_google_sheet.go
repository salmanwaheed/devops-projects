package cmd

import (
	"fmt"
	"mono/internal/config"
	"mono/internal/database"
	"mono/internal/googlesheet"
	"time"

	"github.com/spf13/cobra"
)

var exportSheetId string
var exportSheetName string
var exportSheetCategory string

var exportSheetCmd = &cobra.Command{
	Use: "google-sheet",
	Short: "Export MongoDB data to Google Sheets",
	RunE: func (cmd *cobra.Command, args []string) error {
		fmt.Printf("Exporting to Google Sheet: %s (%s), category: %s\n", exportSheetId, exportSheetName, exportSheetCategory)


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

		query := database.Query{Fields: fields, Category: exportSheetCategory, DateCreated: time.Date(2025, 11, 24, 11, 0, 0, 0, time.UTC)}

		col := db.Collection("lead")
		rawDoc, err := col.Aggregate(query.Pipeline())
		if err != nil {
			return err
		}

		fmt.Println(rawDoc.ToRows(fields))

		gs, err := googlesheet.New(cfg.GoogleSheet.ServiceAccountFile)
		if err != nil {
			return err
		}

		return gs.InsertRows(exportSheetId, exportSheetName, rawDoc.ToRows(fields))

	},
}

func init() {
	exportSheetCmd.Flags().StringVar(&exportSheetId, "id", "", "Google Sheet ID")
	exportSheetCmd.Flags().StringVar(&exportSheetName, "name","Sheet1", "Google Sheet name")
	exportSheetCmd.Flags().StringVar(&exportSheetCategory, "category", "", "Category to export")
	exportSheetCmd.MarkFlagRequired("id")
	exportSheetCmd.MarkFlagRequired("category")

	exportCmd.AddCommand(exportSheetCmd)
}
