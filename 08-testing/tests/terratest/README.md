How to run this test?

download dependencies, then run the tests...
```
go mod download

# With progressbar
go get -v ./...

# Run tests
go test -v --timeout 10m
```

Clean up Go dependenciess
```
go clean -modcache -cache

# Only unused
go mod tidy

````
