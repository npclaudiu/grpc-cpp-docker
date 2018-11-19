# Copyright 2018 gRPC authors.
# Copyright 2018 Claudiu Nedelcu.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.#
#
# Based on https://hub.docker.com/r/grpc/cxx.

FROM debian:stretch as build

RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  build-essential \
  cmake \
  curl \
  g++ \
  git \
  libtool \
  make \
  pkg-config \
  unzip \
  && apt-get clean

ENV GRPC_RELEASE_TAG v1.16.0
ENV CALCULATOR_BUILD_PATH /usr/local/calculator

RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc && \
    cd /var/local/git/grpc && \
    git submodule update --init --recursive

RUN echo "-- installing protobuf" && \
    cd /var/local/git/grpc/third_party/protobuf && \
    ./autogen.sh && ./configure --enable-shared && \
    make -j$(nproc) && make -j$(nproc) check && make install && make clean && ldconfig

RUN echo "-- installing grpc" && \
    cd /var/local/git/grpc && \
    make -j$(nproc) && make install && make clean && ldconfig

COPY . $CALCULATOR_BUILD_PATH/src/calculator/

RUN echo "-- building calculator" && \
    mkdir -p $CALCULATOR_BUILD_PATH/out/calculator && \
    cd $CALCULATOR_BUILD_PATH/out/calculator && \
    cmake -DCMAKE_BUILD_TYPE=Release $CALCULATOR_BUILD_PATH/src/calculator && \
    make && \
    mkdir -p bin && \
    ldd calculator | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' bin/ && \
    mv calculator bin/calculator && \
    echo "LD_LIBRARY_PATH=/opt/calculator/:\$LD_LIBRARY_PATH ./calculator" > bin/start.sh && \
    chmod +x bin/start.sh

WORKDIR $CALCULATOR_BUILD_PATH
ENTRYPOINT ["/bin/bash"]
CMD ["-s"]

FROM debian:stretch as runtime
COPY --from=build /usr/local/calculator/out/calculator/bin/ /opt/calculator/
EXPOSE 8080
WORKDIR /opt/calculator/
ENTRYPOINT ["/bin/bash", "start.sh"]
