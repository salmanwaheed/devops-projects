package cmd

import "github.com/spf13/cobra"

var exportCmd = &cobra.Command{
	Use: "export",
	Short: "Export data to different targets (CSV, Google Sheets, etc.)",
}

func init() {
	rootCmd.AddCommand(exportCmd)
}
