#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_H_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_H_

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

    typedef TRequest RequestType;
    typedef TReply ReplyType;

    Requester();

    explicit Requester(const RequesterParams& params);

    //Requester(const Requester&);

    //void swap(Requester& other);

    //Requester& operator = (const Requester&);

    RequesterParams get_requester_params() const;

    RequestDataWriter_var get_request_datawriter() const;

    ReplyDataReader_var get_reply_datareader() const;

    OpenDDS::RTPS::SequenceNumber_t get_sequence_number() const;

    DDS::ReturnCode_t send_request(const TRequest&);

    DDS::ReturnCode_t take_reply(TReply& reply);

    virtual ~Requester();

  private:
    RequesterParams requester_params;

    OpenDDS::RTPS::SequenceNumber_t sequence_number;

    RequestDataWriter_var request_datawriter;

    ReplyDataReader_var reply_datareader;

    OpenDDS::DCPS::RepoId pub_id;

  };

}

#endif
