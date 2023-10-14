# MoonPie
A micro (CLI-based) developer platform

## Testing
```bash
# to print coverage
go test -cover ./... 

# to generate coverage profile
go test -coverprofile=coverage.out ./...

# to view coverage report
go tool cover -func=coverage.out  

# to view html report
go tool cover -html=coverage.out -o coverage.html
```

