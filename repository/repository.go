package repository

import (
	"github.com/parthivrmenon/moonpie/application"
)

type Repository interface {
	CreateApplication(application *application.Application) error
	GetApplication(id int) (*application.Application, error)
	UpdateApplication(application *application.Application) error
	DeleteApplication(id int) error
}
