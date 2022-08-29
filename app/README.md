# A Hello Dart Docker service and Kubernetes

A simple example HTTP with Docker and Kubernetes:
- HTTP server using dart shelf lib listening on defaul port 5000 (may override with env variable PORT)
- Docker configuration with dart AOT compilation (generates a tiny eficient executable)
- Kubernetes configuration

To run this application localy (in app folder):
> dart lib/main.dart   

To run in Docker (in app folder):
> docker build -f ..\docker\Dockerfile -t hello-dart:latest .  
> docker run --name hello-dart --rm -p 5000:5000 hello-dart:latest  

To stop in Docker launch:
> docker kill --signal=SIGINT hello-dart

To run in Kubernetes after building the docker image (in app folder):
> kubectl apply -f ..\kubernetes\deployment.yaml
