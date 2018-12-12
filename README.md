# Finer Docker

Run FiNER as a web service in a Docker container.

FiNER (finnish-nertag) by FIN-CLARIN is available as part of [finnish-tagtools](https://korp.csc.fi/download/finnish-tagtools/).

## Build

`docker build -t finer .`

## Run

`docker run --rm -it -p 19992:3000 --name finer finer`

## Usage

Make a HTTP GET request:

http://localhost:19992/?text=...
