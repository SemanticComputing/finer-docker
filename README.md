## Finer

Run FiNER as a web service

# Build Docker image

docker build --squash -t finer:latest .

# Run Docker container

docker run --rm -p 19992:3000 -it finer:latest

# Test by running a GET request

http://localhost:19992/?text=...

