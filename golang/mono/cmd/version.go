package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use: "version",
	Short: "Show the version",
	Args: func(cmd *cobra.Command, args []string) error {
		if len(args) > 0 {
			return fmt.Errorf("extra arguments: %v", args)
		}

		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("%s cli v%s (%s)\n", rootCmd.Name(), "1.0", "Salman Waheed")
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
