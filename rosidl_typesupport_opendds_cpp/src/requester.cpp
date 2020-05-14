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
    sequence_number = 0;
  }

  Requester::~Requester()
  {
    sequence_number = 0;
  }

  RequesterParams Requester::get_requester_params() const
  {
    return *requester_params;
  }

  OpenDDS::RTPS::SequenceNumber_t Requester::get_sequence_number() const
  {
    return sequence_number;
  }

  DDS::ReturnCode_t Requester::send_request(const TReq& request)
  {
    DDS::DataWriter_var dw = requester_params->publisher()->lookup_datawriter(requester_params->request_topic_name());
    if (dw == nullptr) {
      return DDS::RETCODE_ERROR;
    }
    DDS::ReturnCode_t return_code = requester_params->writer().write(request, DDS::HANDLE_NIL);

    if (return_code == DDS::RETCODE_OK) {
      ++sequence_number;
    }

    return return_code;
  }


}
