# A Hello Dart Docker service and Kubernetes

### A simple example HTTP with Docker and Kubernetes:  
- HTTP server using dart shelf lib listening on defaul port 5000 (overridable with args and env variable)  
- Docker configuration with dart AOT compilation (generates a tiny eficient executable)  
- Kubernetes configuration  

### To run this application localy:
> dart app/lib/main.dart   

### To run in Docker:
> docker build -f docker/Dockerfile -t hello-dart:latest .  
> docker run --name hello-dart --rm -p 5000:5000 hello-dart:latest  

### To stop in Docker launch:
> docker kill --signal=SIGINT hello-dart   

### To run in Kubernetes after building the docker image:
> kubectl apply -f kubernetes/deployment.yaml   

### On docker image update kubernetes roll out updates:
> kubectl rollout restart deployment hello-dart  