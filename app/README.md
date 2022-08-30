# A Hello Dart Docker service and Kubernetes

### A simple example HTTP with Docker and Kubernetes:  
- HTTP server using dart shelf lib listening on defaul port 5000 (overridable with args and env variable)  
- Docker configuration with dart AOT compilation (generates a tiny eficient executable)  
- Kubernetes configuration  

### To run this application localy (with optional port):
> dart app/lib/main.dart [--port=8080]

### Or run localy a compiled executable (with optional port):
> dart compile exe ./app/lib/main.dart -o ./app/bin/server.exe
> ./app/bin/server.exe [--port=8080]

### To run in Docker (with specific local port mapped to executable default port):
> docker build -f docker/Dockerfile -t hello-dart:latest .  
> docker run --name hello-dart --rm -p 5000:5000 hello-dart:latest  

### To stop in Docker launch:
> docker kill --signal=SIGINT hello-dart   

### To run in Kubernetes after building the docker image (using same mapping as docker run):
> kubectl apply -f kubernetes/deployment.yaml   

### On docker image update kubernetes roll out updates:
> kubectl rollout restart deployment hello-dart  