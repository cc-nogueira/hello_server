# A Hello Dart Docker service and Kubernetes

### A simple example HTTP with Docker and Kubernetes:  
- HTTP server using dart shelf lib listening on defaul port 5000 (overridable with args and env variable)  
- Docker configuration with dart AOT compilation (generates a tiny eficient executable)  
- Kubernetes configuration  

### To run this application localy (with optional port):
```shell
$ dart app/lib/main.dart [--port=8080]
```

### Or run localy a compiled executable (with optional port):
```shell
$ dart compile exe ./app/lib/main.dart -o ./app/bin/server.exe
$ ./app/bin/server.exe [--port=8080]
```

### Run in Docker (with specific local port mapped to executable default port):
```shell
$ docker build -f docker/Dockerfile -t hello-dart:latest .  
$ docker run --name hello-dart --rm -p 5000:5000 hello-dart:latest  
```

### Stop in Docker launch:
```shell
$ docker kill --signal=SIGINT hello-dart   
```

### Run in Kubernetes after building the docker image (using same mapping as docker run):
```shell
$ kubectl apply -f kubernetes/deployment.yaml   
```

### On docker image update kubernetes roll out updates:
```shell
$ kubectl rollout restart deployment hello-dart  
```

### References:  

- **Docker overview**  
  https://docs.docker.com/get-started/overview/  

- **Docker best practices**  
  https://docs.docker.com/develop/develop-images/dockerfile_best-practices/  

- **Docker CLI**  
  https://docs.docker.com/engine/reference/run/  

- **Functions Framework for Dart**  
  Good insigths on how to define the minimalistic docker image for AOT compiled DART  
  https://github.com/GoogleCloudPlatform/functions-framework-dart/tree/main/docs  
  https://github.com/GoogleCloudPlatform/functions-framework-dart/blob/main/examples/hello/Dockerfile  

- **Get started with Kubernetes (using Python)**  
  From 2019: Very clear step by step  
  https://kubernetes.io/blog/2019/07/23/get-started-with-kubernetes-using-python/  

- **What is Kubectl Rollout Restart**  
  Nice run about image updating, rollout and restart  
  https://linuxhint.com/kubectl-rollout-restart/
