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
    // TODO: is this a 'correct' way to get the datawriter?
    DDS::DataWriter_var dw = requester_params->publisher()->lookup_datawriter(requester_params->request_topic_name());
    if (dw == nullptr) {
      return DDS::RETCODE_ERROR;
    }

    // Set GUID and sequence_number
    OpenDDS::DCPS::DataWriterImpl* dwImpl = dynamic_cast<OpenDDS::DCPS::DataWriterImpl*>(dw);
    if (!dwImpl) {
      return DDS::RETCODE_ERROR;
    }
    OpenDDS::DCPS::RepoId id = dwImpl->get_publication_id();
    request.header.request_id().writer_guid(id);
    request.header.request_id().sequence_number(++sequence_number);
    
    // narrow and send
    RequestDataWriter* request_writer = RequestDataWriter::_narrow(dw);
    DDS::ReturnCode_t return_code = request_writer->write(request, DDS::HANDLE_NIL);

    return return_code;
  }

  DDS::ReturnCode_t Requester::take_reply(TRep& reply,
    const typesupport_opendds_cpp::SampleIdentity& related_request_id)
  {
    DDS::DataReader_var dr = requester_params->subscriber()->lookup_dataraeder(requester_params->request_topic_name());
    if (dr == nullptr) {
      return DDS::RETCODE_ERROR;
    }

    RequestDataReader* reply_reader = RequestDataReader::_narrow(dr);

    DDS::SampleInfo si;
    DDS::ReturnCode_t status = reply_reader->take_next_sample(reply, si);

    // TODO: improve error handling / reporting ???
    if (status == DDS::RETCODE_OK && si.valid_data == 1) {
      return DDS::RETCODE_OK;
    }

    // TODO: improve error handling / reporting ???
    if (reply.header != related_request_id) {
      return DDS::RETCODE_OK;
    }

    return DDS::RETCODE_ERROR;

  }

}
