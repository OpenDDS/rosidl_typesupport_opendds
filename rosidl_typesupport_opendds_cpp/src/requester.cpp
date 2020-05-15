#include <string>
#include "dds/DCPS/Service_Participant.h"
#include "dds/DCPS/Marked_Default_Qos.h"
#include "dds/DdsDcpsC.h"
#include "requester.h"
#include "rmw/error_handling.h"

namespace rosidl_typesupport_opendds_cpp
{
  Requester::Requester() :
    requester_params(nullptr),
    request_datawriter(nullptr),
    reply_datareader(nullptr),
    dw_impl(nullptr)
  {
  }

  Requester::Requester(const RequesterParams& params) :
    request_datawriter(nullptr),
    reply_datareader(nullptr),
    dw_impl(nullptr)
  {
    requester_params = &params;
    sequence_number = 0;

    // TODO: is this a 'correct' way to get the datawriter?
    DDS::DataWriter_var dw = requester_params->publisher()->lookup_datawriter(requester_params->request_topic_name());
    if (dw == nullptr) {
      RMW_SET_ERROR_MSG("Requester failed to get DataWriter_var");
      return;
    }

    dw_impl = dynamic_cast<OpenDDS::DCPS::DataWriterImpl*>(dw);
    if (dw_impl == nullptr) {
      RMW_SET_ERROR_MSG("Requester failed to get DataWriterImpl");
      return;
    }
    pub_id = dwImpl->get_publication_id();

    request_datawriter = RequestDataWriter::_narrow(dw);

    // TODO: is this a 'correct' way to get the datareader?
    DDS::DataReader_var dr = requester_params->subscriber()->lookup_datareader(requester_params->reply_topic_name());
    if (dr == nullptr) {
      RMW_SET_ERROR_MSG("Requester failed to get DataReader_var");
      return;
    }

    reply_datareader = RequestDataReader::_narrow(dr);
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

  DDS::ReturnCode_t Requester::send_request(const TRequest& request)
  {
    if (request_datawriter == nullptr) {
      RMW_SET_ERROR_MSG("invalid request_datawriter found in send_request");
      return DDS::RETCODE_ERROR;
    }

    request.header.request_id().writer_guid(pib_id);
    request.header.request_id().sequence_number(++sequence_number);
    
    if (request_datawriter->write(request, DDS::HANDLE_NIL) != DDS::RETCODE_OK) {
      RMW_SET_ERROR_MSG("write() failed in send_request");
      return DDS::RETCODE_ERROR;
    }

    return DDS::RETCODE_OK;
  }

  DDS::ReturnCode_t Requester::take_reply(TReply& reply,
    const typesupport_opendds_cpp::SampleIdentity& related_request_id)
  {
    DDS::SampleInfo si;
    DDS::ReturnCode_t status = reply_datareader->take_next_sample(reply, si);

    if (status != DDS::RETCODE_OK) {
      RMW_SET_ERROR_MSG("take_next_sample failed in take_reply");
      return DDS::RETCODE_ERROR;
    }

    if (si.valid_data != 1) {
      RMW_SET_ERROR_MSG("invalid received data in take_reply");
      return DDS::RETCODE_ERROR;
    }

    if (reply.header != related_request_id) {
      RMW_SET_ERROR_MSG("related_request_id mismatch in take_reply");
      return DDS::RETCODE_ERROR;
    }

    return DDS::RETCODE_OK;
  }


  DDS::DataWriter* Requester::get_request_datawriter() const
  {
    return requester_params->publisher()->lookup_datawriter(requester_params->request_topic_name());
  }

  DDS::DataReader* Requester::get_reply_datareader() const
  {
    return requester_params->subscriber()->lookup_dataraeder(requester_params->reply_topic_name());
  }

}
