package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use: "monoctl",
	Short: "A Go based CLI to export MongoDB data",
	SilenceErrors: true, // avoid default error printing
	SilenceUsage: true, // avoid usage output
	CompletionOptions: cobra.CompletionOptions{
		DisableDefaultCmd: true,
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %s\n", err)
		os.Exit(1)
	}
}

func init() {
	// disable "monoctl help"
	rootCmd.SetHelpCommand(&cobra.Command{Hidden: true})

	// disable "monoctl [--help|-h]"
	// rootCmd.PersistentFlags().BoolP("help", "h", false, "Print usage")
	// rootCmd.PersistentFlags().MarkHidden("help")

	// custom help logic here
	// rootCmd.SetHelpFunc(func(cmd *cobra.Command, args []string) {
  //   fmt.Println("custom help logic here")
	// })

	// https://github.com/spf13/cobra/issues/1505#issuecomment-946463819
// 	rootCmd.SetHelpTemplate(`{{.Name}} - {{.Short}}

// Commands:
// {{range .Commands}}
// 	{{rpad .Name .NamePadding }} {{.Short}}
// {{end}}

// Options:
// {{.LocalFlags.FlagUsages | trimTrailingWhitespaces}}

// Global Options:
// {{.PersistentFlags.FlagUsages | trimTrailingWhitespaces}}

// Usage: {{.CommandPath}} [command] --help
// `)
}
