package filerepository

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/parthivrmenon/moonpie/application"
)

type FileRepository struct {
	filePath string
}

func NewFileRepositor(filePath string) *FileRepository {
	return &FileRepository{filePath: filePath}
}

// Implementation of CreateApplication
func (r *FileRepository) CreateApplication(application *application.Application) error {

	// Marshal as JSON
	applicationData, err := json.Marshal(application)
	if err != nil {
		fmt.Println("Error marshaling JSON:", err)
		return err
	}

	// Write to file
	filePath := filepath.Join(r.filePath, application.Name)
	err = os.WriteFile(filePath, applicationData, 0644)
	return err
}

// Implementation of Delete Application
func (r *FileRepository) DeleteApplication(name string) error {
	filePath := filepath.Join(r.filePath, name)
	return os.Remove(filePath)
}

// Implementation of GetApplication
func (r *FileRepository) GetApplication(name string) (*application.Application, error) {
	filePath := filepath.Join(r.filePath, name)

	// read contents of file
	content, err := os.ReadFile(filePath)
	if err != nil {
		fmt.Println("Error reading file", filePath)
		return nil, err
	}

	var app application.Application
	err = json.Unmarshal(content, &app)
	if err != nil {
		fmt.Println("Error unmarshalling JSON")
		return nil, err
	}
	return &app, nil

}
