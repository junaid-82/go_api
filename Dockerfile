# syntax=docker/dockerfile:1

# Use Alpine as the base image for both building and running the app
FROM golang:1.22.5-alpine

WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY *.go ./

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main

# Expose the port the app runs on
EXPOSE 8080

# Run the binary
ENTRYPOINT ["/app/main"]