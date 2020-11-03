#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REPLIER_HPP_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REPLIER_HPP_

#include "replier_parameters.h"
#include "replier.hpp"

#include "rmw/error_handling.h"

#include "dds/DCPS/Service_Participant.h"
#include "dds/DCPS/Marked_Default_Qos.h"
#include "dds/DdsDcpsC.h"

#include <string>

namespace rosidl_typesupport_opendds_cpp
{

  template <typename TRequest, typename TReply>
  class Replier {
  public:
    typedef typename OpenDDS::DCPS::DDSTraits<TRequest>::DataReaderType RequestDataReader;
    typedef typename OpenDDS::DCPS::DDSTraits<TReply>::DataWriterType ReplyDataWriter;
    typedef typename ReplyDataWriter::_var_type ReplyDataWriter_var;
    typedef typename RequestDataReader::_var_type RequestDataReader_var;

    typedef ReplierParams Params;

    typedef TRequest RequestType;
    typedef TReply ReplyType;

    Replier() :
      request_datareader(nullptr),
      reply_datawriter(nullptr)
    {
    }

    explicit Replier(const ReplierParams& params) :
      request_datareader(nullptr),
      reply_datawriter(nullptr)
    {
      replier_params = params;
      DDS::DataWriter_var dw = replier_params.publisher()->create_datawriter(replier_params.reply_topic(),
                                                                             DATAWRITER_QOS_DEFAULT,
                                                                             nullptr,
                                                                             OpenDDS::DCPS::DEFAULT_STATUS_MASK);

      if (dw == nullptr) {
        RMW_SET_ERROR_MSG("Reply create_datawriter failed");
        return;
      }

      OpenDDS::DCPS::DataWriterImpl* dw_impl = dynamic_cast<OpenDDS::DCPS::DataWriterImpl*>(dw.in());
      if (dw_impl == nullptr) {
        RMW_SET_ERROR_MSG("Replier failed to get DataWriterImpl");
        return;
      }
      pub_id = dw_impl->get_repo_id();

      reply_datawriter = ReplyDataWriter::_narrow(dw);

      DDS::DataReader_var dr = replier_params.subscriber()->create_datareader(replier_params.request_topic(),
                                                                              DATAREADER_QOS_DEFAULT,
                                                                              nullptr,
                                                                              OpenDDS::DCPS::DEFAULT_STATUS_MASK);

      if (dr == nullptr) {
        RMW_SET_ERROR_MSG("Request create_datareader failed");
        return;
      }

      request_datareader = RequestDataReader::_narrow(dr);
    }


    ReplierParams get_replier_params() const
    {
      return replier_params;
    }


    RequestDataReader_var get_request_datareader() const
    {
      return request_datareader;
    }


    ReplyDataWriter_var get_reply_datawriter() const
    {
      return reply_datawriter;
    }


    DDS::ReturnCode_t send_reply(const TReply& reply)
    {
      if (reply_datawriter == nullptr) {
        RMW_SET_ERROR_MSG("invalid reply_datawriter found in send_reply");
        return DDS::RETCODE_ERROR;
      }

      if (reply_datawriter->write(reply, DDS::HANDLE_NIL) != DDS::RETCODE_OK) {
        RMW_SET_ERROR_MSG("write() failed in send_reply");
        return DDS::RETCODE_ERROR;
      }

      return DDS::RETCODE_OK;
    }


    DDS::ReturnCode_t take_request(TRequest& request)
    {
      DDS::SampleInfo si;
      DDS::ReturnCode_t status = request_datareader->take_next_sample(request, si);

      if (status != DDS::RETCODE_OK) {
        RMW_SET_ERROR_MSG("replier reader failed to read sample");
        return status;
      }

      if (!si.valid_data) {
        return this->take_request(request);
      }

      return DDS::RETCODE_OK;
    }


    virtual ~Replier()
    {
    }


  private:
    ReplierParams replier_params;

    RequestDataReader_var request_datareader;

    ReplyDataWriter_var reply_datawriter;

    OpenDDS::DCPS::RepoId pub_id;

  };

}

#endif
