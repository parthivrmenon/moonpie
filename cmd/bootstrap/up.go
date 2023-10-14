/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package bootstrap

import (
	"fmt"

	"github.com/spf13/cobra"
)

var (
	team      string
	namespace string
)

// upCmd represents the up command
var upCmd = &cobra.Command{
	Use:   "up",
	Short: "Create MoonPie",
	Long:  ``,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("up called with team", team)
	},
}

func init() {
	upCmd.Flags().StringVarP(&team, "team", "t", "", "team name that owns the cluster")
	upCmd.Flags().StringVarP(&namespace, "namespace", "n", "", "namespace for deployment")
	if err := upCmd.MarkFlagRequired("team"); err != nil {
		fmt.Println(err)
	}

	if err := upCmd.MarkFlagRequired("namespace"); err != nil {
		fmt.Println(err)
	}

	BootstrapCmd.AddCommand(upCmd)
	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// upCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// upCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
