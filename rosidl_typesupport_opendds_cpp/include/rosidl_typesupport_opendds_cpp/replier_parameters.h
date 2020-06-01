#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__REPLIER_PARAMETERS_H_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__REPLIER_PARAMETERS_H_

namespace rosidl_typesupport_opendds_cpp
{
// TODO: may need to be templated, if it needs a listener: http://community.rti.com/rti-doc/510/ndds/doc/html/api_cpp/classconnext_1_1ReplierParams.html
class ReplierParams {
public:
  ReplierParams()
    : participant_(nullptr) {
  }

  explicit ReplierParams(DDS::DomainParticipant_var participant) {
    participant_ = participant;
    // TODO(?): Create a ReplierParams with the parameters a Replier always needs
  }

  /*
  SET
  */
  ReplierParams& domain_participant(DDS::DomainParticipant_var participant) {
    participant_ = participant;
    return *this;
  }

  ReplierParams& publisher(DDS::Publisher_var publisher) {
    dds_publisher_ = publisher;
    return *this;
  }

  ReplierParams& subscriber(DDS::Subscriber_var subscriber) {
    dds_subscriber_ = subscriber;
    return *this;
  }

  ReplierParams& datawriter_qos(DDS::DataWriterQos qos) {
    dw_qos_ = qos;
    return *this;
  }

  ReplierParams& datareader_qos(DDS::DataReaderQos qos) {
    dr_qos_ = qos;
    return *this;
  }

  ReplierParams& service_name(const std::string& name) {
    service_name_ = name;
    return *this;
  }

  ReplierParams& request_topic_name(const std::string& name) {
    request_topic_name_ = name;
    return *this;
  }

  ReplierParams& reply_topic_name(const std::string& name) {
    reply_topic_name_ = name;
    return *this;
  }

  ReplierParams& request_topic(const DDS::Topic_var& topic) {
    request_topic_ = topic;
    return *this;
  }

  ReplierParams& reply_topic(const DDS::Topic_var& topic) {
    reply_topic_ = topic;
    return *this;
  }



  /*
  GET
  */
  DDS::DomainParticipant_var domain_participant() const {
    return participant_;
  }

  DDS::Publisher_var publisher() const {
    return dds_publisher_;
  }

  DDS::Subscriber_var subscriber() const {
    return dds_subscriber_;
  }

  DDS::DataWriterQos datawriter_qos() const {
    return dw_qos_;
  }

  DDS::DataReaderQos datareader_qos() const {
    return dr_qos_;
  }

  std::string service_name() const {
    return service_name_;
  }

  std::string request_topic_name() const {
    return request_topic_name_;
  }

  std::string reply_topic_name() const {
    return reply_topic_name_;
  }

  DDS::Topic_var request_topic() const {
    return request_topic_;
  }

  DDS::Topic_var reply_topic() const {
    return reply_topic_;
  }


private:
  DDS::DomainParticipant_var participant_;
  DDS::Publisher_var dds_publisher_;
  DDS::Subscriber_var dds_subscriber_;
  DDS::DataWriterQos dw_qos_;
  DDS::DataReaderQos dr_qos_;
  std::string service_name_;
  std::string request_topic_name_;
  std::string reply_topic_name_;
  DDS::Topic_var request_topic_;
  DDS::Topic_var reply_topic_;
};

}



#endif
