#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_HPP_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_HPP_

#include "rmw/error_handling.h"

#include "dds/DCPS/Marked_Default_Qos.h"
#include "dds/DdsDcpsC.h"
#include "dds/DCPS/DataWriterImpl.h"
#include "dds/DCPS/SequenceNumber.h"

#include <string>

const size_t RPC_SAMPLE_IDENTITY_SIZE = 16;

namespace rosidl_typesupport_opendds_cpp
{

  template <typename TRequest, typename TReply>
  class Requester {
  public:
    typedef typename OpenDDS::DCPS::DDSTraits<TRequest>::DataWriterType RequestDataWriter;
    typedef typename OpenDDS::DCPS::DDSTraits<TReply>::DataReaderType ReplyDataReader;
    typedef typename RequestDataWriter::_var_type RequestDataWriter_var;
    typedef typename ReplyDataReader::_var_type ReplyDataReader_var;

    typedef RequesterParams Params;

    typedef TRequest RequestType;
    typedef TReply ReplyType;

    Requester() :
      sequence_number(0),
      request_datawriter(nullptr),
      reply_datareader(nullptr)
    {
    }


    explicit Requester(const RequesterParams& params) :
      sequence_number(0),
      request_datawriter(nullptr),
      reply_datareader(nullptr)
    {
      requester_params = params;

      DDS::DataWriter_var dw = requester_params.publisher()->create_datawriter(requester_params.request_topic(),
                                                                               DATAWRITER_QOS_DEFAULT,
                                                                               nullptr,
                                                                               OpenDDS::DCPS::DEFAULT_STATUS_MASK);

      if (dw == nullptr) {
        RMW_SET_ERROR_MSG("Request create_datawriter failed");
        return;
      }

      OpenDDS::DCPS::DataWriterImpl* dw_impl = dynamic_cast<OpenDDS::DCPS::DataWriterImpl*>(dw.in());
      if (dw_impl == nullptr) {
        RMW_SET_ERROR_MSG("Requester failed to get DataWriterImpl");
        return;
      }
      pub_id = dw_impl->get_repo_id();

      request_datawriter = RequestDataWriter::_narrow(dw);

      DDS::DataReader_var dr = requester_params.subscriber()->create_datareader(requester_params.reply_topic(),
                                                                                DATAREADER_QOS_DEFAULT,
                                                                                nullptr,
                                                                                OpenDDS::DCPS::DEFAULT_STATUS_MASK);

      if (!dr) {
        RMW_SET_ERROR_MSG("Response create_datareader failed");
        return;
      }

      reply_datareader = ReplyDataReader::_narrow(dr);
    }


    RequesterParams get_requester_params() const
    {
      return requester_params;
    }


    RequestDataWriter_var get_request_datawriter() const
    {
      return request_datawriter;
    }


    ReplyDataReader_var get_reply_datareader() const
    {
      return reply_datareader;
    }


    OpenDDS::DCPS::SequenceNumber get_sequence_number() const
    {
      return sequence_number;
    }


    DDS::ReturnCode_t send_request(TRequest& request)
    {
      if (request_datawriter == nullptr) {
        RMW_SET_ERROR_MSG("invalid request_datawriter found in send_request");
        return DDS::RETCODE_ERROR;
      }

      request.header().request_id().writer_guid(pub_id);

      ++sequence_number;

      request.header().request_id().sequence_number().high = sequence_number.getHigh();
      request.header().request_id().sequence_number().low = sequence_number.getLow();

      if (request_datawriter->write(request, DDS::HANDLE_NIL) != DDS::RETCODE_OK) {
        RMW_SET_ERROR_MSG("write() failed in send_request");
        return DDS::RETCODE_ERROR;
      }

      return DDS::RETCODE_OK;
    }


    DDS::ReturnCode_t take_reply(TReply& reply)
    {
      DDS::SampleInfo si;
      DDS::ReturnCode_t status = reply_datareader->take_next_sample(reply, si);

      if (status != DDS::RETCODE_OK) {
        RMW_SET_ERROR_MSG("requester reader failed to read sample");
        return status;
      }

      if (!si.valid_data) {
        return this->take_reply(reply);
      }

      if (reply.header().remote_ex() != ::typesupport_opendds_cpp_dds::rpc::RemoteExceptionCode_t::REMOTE_EX_OK) {
        RMW_SET_ERROR_MSG("error code returned from the server");
        return DDS::RETCODE_ERROR;
      }

      return DDS::RETCODE_OK;
    }


    virtual ~Requester()
    {
    }


  private:
    RequesterParams requester_params;

    OpenDDS::DCPS::SequenceNumber sequence_number;

    RequestDataWriter_var request_datawriter;

    ReplyDataReader_var reply_datareader;

    OpenDDS::DCPS::RepoId pub_id;

  };

}

#endif
