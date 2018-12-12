# Finer Docker

Run FiNER as a web service in a Docker container.

FiNER (finnish-nertag) by FIN-CLARIN is available as part of [finnish-tagtools](https://korp.csc.fi/download/finnish-tagtools/).

Available also in Docker Hub: [secoresearch/finer](https://hub.docker.com/r/secoresearch/finer/).

## Build

`docker build -t secoresearch/finer .`

## Run

`docker run --rm -it -p 19992:3000 --name finer secoresearch/finer`

The same command can be used to pull and run the container from Docker Hub (no need to build the image first).

## Usage

Make a HTTP GET request:

http://localhost:19992/?text=...
