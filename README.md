# A Hello Dart Docker service and Kubernetes


### A simple example HTTP with Docker and Kubernetes:  
- HTTP server using dart shelf lib listening on defaul port 8080 (overridable with args and env variable)  
- Docker configuration with dart AOT compilation (generates a tiny eficient executable)  
- Kubernetes configuration  


# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this (may use optional argument --port=8080):

```shell
$ dart run app/lib/server.dart
Server listening on port 8080
```


## Running with AOT compiled executable


Running with a compiled executable:
```shell
$ dart compile exe ./app/lib/server.dart -o ./bin/server # server.exe for windows
$ ./bin/server
Server listening on port 8080
```


## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```shell
$ docker build . -f docker/Dockerfile -t hello-server
$ docker run --name hello-server --rm -it -p 8080:8080 hello-server
Server listening on port 8080
```

To stop either hit Ctrl+C or from a second terminal:
```shell
$ docker kill --signal=SIGINT hello-server
```


## Run in Kubernetes
After building the docker image (using same mapping as docker run):
```shell
$ kubectl apply -f kubernetes/deployment.yaml   
```

To roll out an updated docker image:
```shell
$ kubectl rollout restart deployment hello-server  
```


## Testing

From a second terminal:
```shell
$ curl http://localhost:8080
Hello, World!
$ curl http://localhost:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:
```shell
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /echo/I_love_Dart
```


### References:  

- **Docker overview**  
  https://docs.docker.com/get-started/overview/  

- **Docker best practices**  
  https://docs.docker.com/develop/develop-images/dockerfile_best-practices/  

- **Docker CLI**  
  https://docs.docker.com/engine/reference/run/  

- **Get started with Kubernetes (using Python)**  
  From 2019: Very clear step by step  
  https://kubernetes.io/blog/2019/07/23/get-started-with-kubernetes-using-python/  

- **What is Kubectl Rollout Restart**  
  Nice run about image updating, rollout and restart  
  https://linuxhint.com/kubectl-rollout-restart/
