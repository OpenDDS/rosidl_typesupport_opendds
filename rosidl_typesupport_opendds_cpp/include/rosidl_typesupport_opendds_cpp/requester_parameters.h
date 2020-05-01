#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_PARAMETERS_H_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REQUESTER_PARAMETERS_H_

#include <string>
#include "dds/DCPS/Service_Participant.h"
#include "dds/DCPS/Marked_Default_Qos.h"

  struct RequesterParams {

    RequesterParams(DDS::DomainParticipant* participant) {
      participant_ = participant;
      // TODO: Create a RequesterParams with the parameters a Requester always needs
    };


    DDS::DomainParticipant* participant_;
    DDS::DataWriterQos dw_qos_;
    DDS::DataReaderQos dr_qos_;
    std::string service_name_;
    std::string request_topic_name_;
    std::string reply_topic_name_;
    DDS::Publisher_var dds_publisher_;
    DDS::Subscriber_var dds_subscriber_;
  };



#endif
