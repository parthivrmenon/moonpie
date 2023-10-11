/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package bootstrap

import (
	"github.com/spf13/cobra"
)

// bootstrapCmd represents the bootstrap command
var BootstrapCmd = &cobra.Command{
	Use:   "bootstrap",
	Short: "Commands to bootstrap the moonpie cluster",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		cmd.Help()
	},
}

func init() {

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// bootstrapCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// bootstrapCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
