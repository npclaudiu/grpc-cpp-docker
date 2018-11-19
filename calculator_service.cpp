#include "calculator_service.hpp"
#include <grpcpp/grpcpp.h>
#include <cmath>

namespace calculator {

using namespace ::calculator::proto;

Status CalculatorService::Compute(ServerContext* context, const ComputeRequest* request, ComputeResponse* reply)
{
    switch(request->operator_()) {
        case ADD:
            reply->set_result(request->lhs() + request->rhs());
            break;

        case SUB:
            reply->set_result(request->lhs() - request->rhs());
            break;

        case MUL:
            reply->set_result(request->lhs() * request->rhs());
            break;

        case DIV:
            reply->set_result(request->lhs() / request->rhs());
            break;

        case POW:
            reply->set_result(std::pow(request->lhs(), request->rhs()));
            break;

        default:
            return Status{grpc::INVALID_ARGUMENT, "Unknown operator."};
    }

    return Status::OK;
}

} // ~namespace calculator
