# Using Docker to build and deploy a C++ gRPC service

This sample demonstrates how to create a basic gRPC service in C++ and build it
it using GCC and CMake in a Docker container. It also shows how to create a
Docker image that contains only the service implementation, without the tools
needed to build it. It is based on the Dockerfile used to build the [official
gRPC CXX image](https://hub.docker.com/r/grpc/cxx/~/dockerfile/).

## Build and run the sample

```sh
git clone https://github.com/npclaudiu/grpc-cpp-docker.git
cd grpc-cpp-docker
docker build -t calculator .
docker run --rm -it calculator
```

To run the shell instead of starting the server hosting the calculator service you can use:

```sh
docker run --rm -it --entrypoint=bash calculator
```

First build will take some time, as it also clones, builds and installs *protobuf*
and *grpc*. You should end up with a Docker image tagged *calculator*, based on Debian and
containing the release build of the calculator service and all of its dependencies,
all under `/opt/calculator`. There is also an intermediary build image, where the project
is actually built. Please see the `Dockerfile` and the documentation for
[Docker multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)
for more.
