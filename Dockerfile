# syntax=docker/dockerfile:1

# Build the application from source
FROM golang:1.22.5-alpine AS build-stage

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o main

# Run the tests in the container
FROM build-stage AS run-test-stage
RUN go test -v ./...

# Deploy the application binary into a lean image
FROM debian:bookworm-slim AS build-release-stage

WORKDIR /

COPY --from=build-stage /app/main /main

CMD ["/main", ">>", "/var/log/myapp.log"]


EXPOSE 8080

# USER nonroot:nonroot

ENTRYPOINT ["/main"]