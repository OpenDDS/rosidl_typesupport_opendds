#include "requester_parameters.h"
#include "requester.h"

#include "rmw/error_handling.h"

#include "dds/DCPS/Service_Participant.h"
#include "dds/DCPS/Marked_Default_Qos.h"
#include "dds/DdsDcpsC.h"

#include <string>

namespace rosidl_typesupport_opendds_cpp
{
  Requester::Requester() :
    requester_params(nullptr),
    request_datawriter(nullptr),
    reply_datareader(nullptr),
    dw_impl(nullptr),
    sequence_number(0)
  {
  }

  Requester::Requester(const RequesterParams& params) :
    request_datawriter(nullptr),
    reply_datareader(nullptr),
    dw_impl(nullptr),
    sequence_number(0)
  {
    requester_params = &params;

    DDS::DataWriter_var dw = requester_params->publisher()->create_datawriter(requester_params->request_topic_name(),
                                                                              DATAWRITER_QOS_DEFAULT,
                                                                              DDS::DataWriterListener::_nil(),
                                                                              OpenDDS::DCPS::DEFAULT_STATUS_MASK);

    if (CORBA::is_nil(dw.in())) {
      RMW_SET_ERROR_MSG("Request create_datawriter failed");
      return;
    }

    dw_impl = dynamic_cast<OpenDDS::DCPS::DataWriterImpl*>(dw);
    if (dw_impl == nullptr) {
      RMW_SET_ERROR_MSG("Requester failed to get DataWriterImpl");
      return;
    }
    pub_id = dwImpl->get_publication_id();

    request_datawriter = RequestDataWriter::_narrow(dw);

    DDS::DataReader_var dr = requester_params->subscriber()->create_datareader(requester_params->reply_topic_name(),
                                                                              DATAREADER_QOS_DEFAULT,
                                                                              DDS::DataReaderListener::_nil(),
                                                                              OpenDDS::DCPS::DEFAULT_STATUS_MASK);

    if (CORBA::is_nil(dr.in())) {
      RMW_SET_ERROR_MSG("Response create_datareader failed");
      return;
    }

    reply_datareader = RequestDataReader::_narrow(dr);
  }

  Requester::~Requester()
  {
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

    request.header().request_id().writer_guid(pub_id);
    request.header().request_id().sequence_number(++sequence_number);
    
    if (request_datawriter->write(request, DDS::HANDLE_NIL) != DDS::RETCODE_OK) {
      RMW_SET_ERROR_MSG("write() failed in send_request");
      return DDS::RETCODE_ERROR;
    }

    return DDS::RETCODE_OK;
  }

  DDS::ReturnCode_t Requester::take_reply(TReply& reply)
  {
    DDS::SampleInfo si;
    DDS::ReturnCode_t status = reply_datareader->take_next_sample(reply, si);

    if (status != DDS::RETCODE_OK) {
      RMW_SET_ERROR_MSG("requestor reader failed to read sample");
      return DDS::RETCODE_ERROR;
    }

    if (si.valid_data != 1) {
      RMW_SET_ERROR_MSG("invalid data in requester take_reply");
      return DDS::RETCODE_ERROR;
    }

    if (reply.header().remote_ex != REMOTE_EX_OK) {
      RMW_SET_ERROR_MSG("error code returned from the server");
      return DDS::RETCODE_ERROR;
    }

    return DDS::RETCODE_OK;
  }


  DDS::DataWriter* Requester::get_request_datawriter() const
  {
    return request_datawriter;
  }

  DDS::DataReader* Requester::get_reply_datareader() const
  {
    return reply_datareader;
  }

}
