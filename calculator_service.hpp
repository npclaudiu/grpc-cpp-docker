#ifndef _CALCULATOR_SERVICE_HPP
#define _CALCULATOR_SERVICE_HPP

#include "calculator_service.grpc.pb.h"
#include <grpcpp/grpcpp.h>

namespace calculator {

using grpc::ServerContext;
using grpc::Status;
using ::calculator::proto::Calculator;
using ::calculator::proto::ComputeRequest;
using ::calculator::proto::ComputeResponse;

class CalculatorService final : public Calculator::Service {
    Status Compute(ServerContext*, const ComputeRequest*, ComputeResponse*) override;
};

} // ~namespace calculator

#endif // ~_CALCULATOR_SERVICE_HPP
