package application

type Application struct {
	Team      string
	Namespace string
	Name      string
}

func NewApplication(team string, namespace string, name string) *Application {
	return &Application{
		Team:      team,
		Namespace: namespace,
		Name:      name,
	}
}
