#include "requester.h"

namespace rosidl_typesupport_opendds_cpp
{
  Requester::Requester()
  : requester_params(nullptr)
  {
  }

  Requester::Requester(const RequesterParams& params)
  {
    requester_params = &params;
  }

  Requester::~Requester()
  {
  }

  RequesterParams Requester::get_requester_params() const
  {
    return *requester_params;
  }

}