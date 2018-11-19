cmake_minimum_required (VERSION 3.7.2)
project (repository CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/build/cmake/")
set(PROTOBUF_IMPORT_DIRS "${CMAKE_SOURCE_DIR}/")

add_definitions(-DNDEBUG)

find_package (Protobuf REQUIRED)
find_package (GRPC REQUIRED)
PROTOBUF_GENERATE_CPP(PROTO_SRCS PROTO_HDRS calculator_service.proto)
PROTOBUF_GENERATE_GRPC_CPP(GRPC_SRCS GRPC_HDRS calculator_service.proto)

include_directories(${PROTOBUF_INCLUDE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(calculator
    calculator_service.cpp
    calculator_service.hpp
    calculator_service.pb.cc
    calculator_service.pb.h
    calculator_service.grpc.pb.cc
    calculator_service.grpc.pb.h
    main.cpp
    )

set_property(TARGET calculator PROPERTY CXX_STANDARD 14)
target_link_libraries(calculator ${PROTOBUF_LIBRARIES} ${GRPC_LIBRARIES})
