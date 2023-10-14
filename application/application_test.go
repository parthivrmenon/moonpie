package application

import "testing"

func TestNewApplicatio(t *testing.T) {
	myApp := NewApplication("TeamA", "NamespaceX", "MyApplicationName")

	if myApp.Team != "TeamA" {
		t.Errorf("Expected Team to be 'TeamA', got %s", myApp.Team)
	}

	if myApp.Namespace != "NamespaceX" {
		t.Errorf("Expected Namespace to be 'NamespaceX', got %s", myApp.Namespace)
	}

	if myApp.Name != "MyApplicationName" {
		t.Errorf("Expected Name to be 'MyApplicationName', got %s", myApp.Name)
	}
}
