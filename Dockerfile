# Use a Golang base image
FROM golang:1.22 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules files
COPY go.mod .
COPY go.sum .

# Download the dependencies
RUN go mod download
Run go test
# Copy the source code into the container
COPY . .

# Build the controller binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o controller .

# Create a minimal runtime image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/controller .

# Set the entry point for the container
ENTRYPOINT ["./controller"]
