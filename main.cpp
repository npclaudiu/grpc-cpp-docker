#include "calculator_service.hpp"
#include <grpcpp/grpcpp.h>
#include <iostream>
#include <string>
#include <memory>

int main(int argc, char* argv[])
{
    using namespace std;
    using namespace grpc;
    using namespace calculator;

    string server_address("0.0.0.0:8080");
    CalculatorService calculator_service;

    ServerBuilder builder;
    builder.AddListeningPort(server_address, InsecureServerCredentials());
    builder.RegisterService(&calculator_service);

    unique_ptr<Server> server(builder.BuildAndStart());
    cout << "Calculator server listening on " << server_address << endl;
    server->Wait();
    
    return 0;
}
