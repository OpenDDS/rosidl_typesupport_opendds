#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_H_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_H_

#include <string>
#include "dds/DCPS/Service_Participant.h"
#include "dds/DCPS/Marked_Default_Qos.h"
#include "dds/DdsDcpsC.h"

#include "requester_parameters.h"

namespace rosidl_typesupport_opendds_cpp
{

  template <typename TReq, typename TRep>
  class Requester {
  public:
    typedef TReq RequestType;

    typedef TRep ReplyType;

    //typedef typename dds::dds_type_traits<TReq>::DataWriter RequestDataWriter;

    //typedef typename dds::dds_type_traits<TRep>::DataReader ReplyDataReader;

    typedef RequesterParams Params;

    //typedef typename details::vendor_dependent<Requester<TReq, TRep>>::type VendorDependent;

    Requester();

    explicit Requester(const RequesterParams& params);

    //Requester(const Requester&);

    //void swap(Requester& other);

    //Requester& operator = (const Requester&);

    RequesterParams get_requester_params() const;

    //RequestDataWriter get_request_datawriter() const;

    //ReplyDataReader get_reply_datareader() const;

    OpenDDS::RTPS::SequenceNumber_t get_sequence_number() const;

    DDS::ReturnCode_t send_request(const TReq&);

    virtual ~Requester();

  private:
    RequesterParams* requester_params;

    OpenDDS::RTPS::SequenceNumber_t sequence_number;

    //RequestDataWriter* request_datawriter;

    //ReplyDataReader* reply_datareader;

  };

}

#endif
