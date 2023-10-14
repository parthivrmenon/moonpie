/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package bootstrap

import (
	"fmt"

	"github.com/spf13/cobra"
)

// downCmd represents the down command
var downCmd = &cobra.Command{
	Use:   "down",
	Short: "Delete MoonPie",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("down called")
	},
}

func init() {
	BootstrapCmd.AddCommand(downCmd)
	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// downCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// downCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
