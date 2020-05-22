#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_HPP_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_HPP_

#include "rmw/error_handling.h"

#include "dds/DCPS/Marked_Default_Qos.h"
#include "dds/DdsDcpsC.h"
#include "dds/DCPS/DataWriterImpl.h"

#include <string>

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

    // TODO: remove unused commented out lines
    //typedef typename details::vendor_dependent<Requester<TRequest, TReply>>::type VendorDependent;

    //Requester(const Requester&);

    //void swap(Requester& other);

    //Requester& operator = (const Requester&);


    typedef TRequest RequestType;
    typedef TReply ReplyType;

    Requester() :
      request_datawriter(nullptr),
      reply_datareader(nullptr)
    {
      sequence_number = { 0, 0 };
    }


    explicit Requester(const RequesterParams& params) :
      request_datawriter(nullptr),
      reply_datareader(nullptr)
    {
      requester_params = params;
      sequence_number = { 0, 0 };

      DDS::DataWriter_var dw = requester_params.publisher()->create_datawriter(requester_params.request_topic(),
                                                                               DATAWRITER_QOS_DEFAULT,
                                                                               DDS::DataWriterListener::_nil(),
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
      pub_id = dw_impl->get_publication_id();

      request_datawriter = RequestDataWriter::_narrow(dw);

      DDS::DataReader_var dr = requester_params.subscriber()->create_datareader(requester_params.reply_topic(),
                                                                                DATAREADER_QOS_DEFAULT,
                                                                                DDS::DataReaderListener::_nil(),
                                                                                OpenDDS::DCPS::DEFAULT_STATUS_MASK);

      if (CORBA::is_nil(dr.in())) {
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


    OpenDDS::RTPS::SequenceNumber_t get_sequence_number() const
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

      if (sequence_number.low == ACE_UINT32_MAX) {
        if (sequence_number.high == ACE_INT32_MAX) {
          // this code is here, despite the RTPS spec statement:
          // "sequence numbers never wrap"
          sequence_number.high = 0;
          sequence_number.low = 1;
        }
        else {
          ++sequence_number.high;
          sequence_number.low = 0;
        }
      }
      else {
        ++sequence_number.low;
      }
      request.header().request_id().sequence_number(sequence_number);

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
        RMW_SET_ERROR_MSG("requestor reader failed to read sample");
        return DDS::RETCODE_ERROR;
      }

      if (!si.valid_data) {
        // add checking si.instance_state if need more details
        return DDS::RETCODE_ERROR;
      }

      if (reply.header().remote_ex() != ::typesupport_opendds_cpp::rpc::RemoteExceptionCode_t::REMOTE_EX_OK) {
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

    OpenDDS::RTPS::SequenceNumber_t sequence_number;

    RequestDataWriter_var request_datawriter;

    ReplyDataReader_var reply_datareader;

    OpenDDS::DCPS::RepoId pub_id;

  };

}

#endif
