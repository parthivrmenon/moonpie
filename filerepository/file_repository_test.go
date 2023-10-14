package filerepository

import (
	"os"
	"testing"

	"github.com/parthivrmenon/moonpie/application"
)

func TestNewFileRepository(t *testing.T) {
	myRepo := NewFileRepositor(".")
	if myRepo.filePath != "." {
		t.Errorf("Expected filePath to be '.' , got %s", myRepo.filePath)
	}
}

func TestCreateApplication(t *testing.T) {
	myRepo := NewFileRepositor(".")
	foo_app := application.NewApplication("foo", "test", "foo_app")
	err := myRepo.CreateApplication(foo_app)
	if err != nil {
		t.Errorf("Expected nil , got %s", err)
	}

	// Check if the file exists
	_, err = os.Stat("foo_app")
	if err != nil {
		t.Errorf("File does not exist: %v", err)
	}

	// Clean up: Delete the test file
	err = os.Remove("foo_app")
	if err != nil {
		t.Errorf("Error deleting file: %v", err)
	}
}

func TestDeleteApplication(t *testing.T) {
	myRepo := NewFileRepositor(".")

	// create test file
	os.WriteFile("test_app", []byte("Test file content"), 0644)

	// Delete
	err := myRepo.DeleteApplication("test_app")
	if err != nil {
		t.Errorf("Expected nil, got %s", err)
	}
}

func TestGetApplication(t *testing.T) {
	myRepo := NewFileRepositor(".")

	// create test file
	os.WriteFile("test_app", []byte(`{"Name":"test_app", "Team":"foo", "Namespace":"test"}`), 0644)

	app, err := myRepo.GetApplication("test_app")
	if err != nil {
		t.Errorf("Expected nil, got %s", err)
	}

	if app.Name != "test_app" {
		t.Errorf("Expected 'test_app', got %s", app.Name)
	}

	if app.Team != "foo" {
		t.Errorf("Expected 'foo', got %s", app.Team)
	}

	if app.Namespace != "test" {
		t.Errorf("Expected 'test', got %s", app.Namespace)
	}

}
