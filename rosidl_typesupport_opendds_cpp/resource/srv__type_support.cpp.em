@# Included from rosidl_typesupport_opendds_cpp/resource/idl__dds_opendds__type_support.cpp.em
@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
include_parts = [package_name] + list(interface_path.parents[0].parts)
include_base = '/'.join(include_parts)
cpp_include_prefix = interface_path.stem

c_include_prefix = convert_camel_case_to_lower_case_underscore(cpp_include_prefix)

header_files = [
    include_base + '/' + c_include_prefix + '__rosidl_typesupport_opendds_cpp.hpp',
    'rmw/error_handling.h',
    'rosidl_typesupport_opendds_cpp/identifier.hpp',
    'rosidl_typesupport_opendds_cpp/service_type_support.h',
    'rosidl_typesupport_opendds_cpp/service_type_support_decl.hpp',
    'rosidl_typesupport_opendds_cpp/requester_parameters.h',
    'rosidl_typesupport_opendds_cpp/replier_parameters.h',
    'rosidl_typesupport_opendds_cpp/requester.hpp',
    include_base + '/' + c_include_prefix + '__struct.hpp',
]

dds_specific_header_files = [
    include_base + '/dds_opendds/' + cpp_include_prefix + '_C.h',
    include_base + '/dds_opendds/' + cpp_include_prefix + '_TypeSupportImpl.h',
    include_base + '/dds_opendds/' + cpp_include_prefix + '__RequestResponseC.h',
    include_base + '/dds_opendds/' + cpp_include_prefix + '__RequestResponseTypeSupportImpl.h',
]
}@
#ifdef OpenDDS_GLIBCXX_USE_CXX11_ABI_ZERO
#define _GLIBCXX_USE_CXX11_ABI 0
#endif

#include <dds/DCPS/Marked_Default_Qos.h>

#ifndef _WIN32
# pragma GCC diagnostic push
# pragma GCC diagnostic ignored "-Wunused-parameter"
# ifdef __clang__
#  pragma clang diagnostic ignored "-Wdeprecated-register"
#  pragma clang diagnostic ignored "-Wreturn-type-c-linkage"
# endif
#endif

@[for header_file in dds_specific_header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include <@(header_file)>
@[end for]@

#ifndef _WIN32
# pragma GCC diagnostic pop
#endif

@[for header_file in header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include "@(header_file)"
@[end for]@

@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.request_message,
    include_directives=include_directives
)
}@

@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.response_message,
    include_directives=include_directives
)
}@

@[for ns in service.namespaced_type.namespaces]@

namespace @(ns)
{
@[end for]@
namespace typesupport_opendds_cpp
{
@#__dds_response_msg_typesupport_type = __ros_srv_pkg_prefix + '::dds_::' +  service.namespaced_type.name + 'ResponseWrapperTypeSupport'
@{
__ros_srv_pkg_prefix = '::'.join(service.namespaced_type.namespaces)
__ros_srv_type = __ros_srv_pkg_prefix + '::' + service.namespaced_type.name
__ros_request_msg_type = __ros_srv_pkg_prefix + '::' + service.request_message.structure.namespaced_type.name
__ros_response_msg_type = __ros_srv_pkg_prefix + '::' + service.response_message.structure.namespaced_type.name
__dds_request_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.request_message.structure.namespaced_type.name + '_'
__dds_response_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.response_message.structure.namespaced_type.name + '_'
__dds_request_wrapper_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.namespaced_type.name + 'RequestWrapper'
__dds_response_wrapper_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.namespaced_type.name + 'ResponseWrapper'
__dds_msg_typesupport_type = __ros_srv_pkg_prefix + '::dds_::' + service.namespaced_type.name
__dds_header_prefix = __ros_srv_pkg_prefix + '::dds_::'
__rpc_header_prefix = '::typesupport_opendds_cpp::rpc::'
}@

void * create_requester__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator)
{
  @# TODO: remove next line when ready
  return nullptr;

  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_request_wrapper_msg_type),
    @(__dds_response_wrapper_msg_type)
  >;

  @# Register TypeSupports
  @(__dds_msg_typesupport_type)RequestWrapperTypeSupport_var tsRequest =
    new @(__dds_msg_typesupport_type)RequestWrapperTypeSupportImpl;

  if (tsRequest->register_type(dds_participant, "@(__dds_request_wrapper_msg_type)_") != DDS::RETCODE_OK) {
    RMW_SET_ERROR_MSG("request register_type for requester failed");
    return NULL;
  }

  @(__dds_msg_typesupport_type)ResponseWrapperTypeSupport_var tsResponse =
    new @(__dds_msg_typesupport_type)ResponseWrapperTypeSupportImpl;

  if (tsResponse->register_type(dds_participant, "@(__dds_response_wrapper_msg_type)_") != DDS::RETCODE_OK) {
    RMW_SET_ERROR_MSG("response register_type for requester failed");
    return NULL;
  }

  @# Create Topics
  CORBA::String_var type_name = tsRequest->get_type_name();
  DDS::Topic_var request_topic = dds_participant->create_topic(request_topic_str,
                                                      type_name,
                                                      TOPIC_QOS_DEFAULT,
                                                      nullptr,
                                                      OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  if (!request_topic) {
    RMW_SET_ERROR_MSG("Request create_topic failed");
    return nullptr;
  }

  type_name = tsResponse->get_type_name();
  DDS::Topic_var response_topic = dds_participant->create_topic(response_topic_str,
                                        type_name,
                                        TOPIC_QOS_DEFAULT,
                                        nullptr,
                                        OpenDDS::DCPS::DEFAULT_STATUS_MASK);

  if (!response_topic) {
    RMW_SET_ERROR_MSG("Response create_topic failed");
    return nullptr;
  }

  auto _allocator = allocator ? allocator : &malloc;
  rosidl_typesupport_opendds_cpp::RequesterParams requester_params(dds_participant);

  requester_params.publisher(dds_publisher);
  requester_params.subscriber(dds_subscriber);
  requester_params.request_topic_name(request_topic_str);
  requester_params.reply_topic_name(response_topic_str);
  requester_params.request_topic(request_topic);
  requester_params.reply_topic(response_topic);

  RequesterType * requester = static_cast<RequesterType *>(_allocator(sizeof(RequesterType)));
  try {
    new (requester) RequesterType(requester_params);
  } catch (...) {
    RMW_SET_ERROR_MSG("C++ exception during construction of Requester");
    return nullptr;
  }

  return requester;
}

const char * destroy_requester__@(service.namespaced_type.name)(
  void * untyped_requester,
  deallocator_t deallocator)
{
  @# TODO: remove next line when ready
  return nullptr;

  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_request_wrapper_msg_type),
    @(__dds_response_wrapper_msg_type)
  >;
  auto requester = static_cast<RequesterType *>(untyped_requester);

  requester->~RequesterType();
  auto _deallocator = deallocator ? deallocator : &free;
  _deallocator(requester);
  return nullptr;
}

int64_t send_request__@(service.namespaced_type.name)(
  void * untyped_requester,
  const void * untyped_ros_request)
{
  using ROSRequestType = @(__ros_request_msg_type);
  using DDSRequestType = @(__dds_request_msg_type);
  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;

  const ROSRequestType & ros_request = *(static_cast<const ROSRequestType *>(untyped_ros_request));
  DDSRequestType dds_request;

  if (!@(__ros_srv_pkg_prefix)::typesupport_opendds_cpp::convert_ros_message_to_dds(
    ros_request, dds_request)) {
      RMW_SET_ERROR_MSG("failed to convert ROS request to DDS");
      return -1;
    }

  @(__dds_msg_typesupport_type)RequestWrapper request_wrapper;
  request_wrapper.request(dds_request);

  RequesterType * requester = static_cast<RequesterType *>(untyped_requester);
  if (DDS::RETCODE_OK != requester->send_request(request_wrapper)) {
    RMW_SET_ERROR_MSG("send_request failed");
    return -1;
  }

  int64_t sequence_number = ((int64_t)requester->get_sequence_number().getHigh()) << 32 |
    requester->get_sequence_number().getLow();
  return sequence_number;
}

void * create_replier__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return nullptr;
}

const char * destroy_replier__@(service.namespaced_type.name)(
  void * untyped_replier,
  deallocator_t deallocator)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return nullptr;
}

bool take_request__@(service.namespaced_type.name)(
  void * untyped_replier,
  rmw_request_id_t * request_header,
  void * untyped_ros_request)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return true;
}

bool take_response__@(service.namespaced_type.name)(
  void * untyped_requester,
  rmw_request_id_t * request_header,
  void * untyped_ros_response)
{
  using ROSResponseType = @(__ros_response_msg_type);
  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;
  if (!untyped_requester || !request_header || !untyped_ros_response) {
    return false;
  }

  RequesterType * requester = static_cast<RequesterType *>(untyped_requester);
  @(__dds_msg_typesupport_type)ResponseWrapper dds_response_wrapper;

  if (DDS::RETCODE_OK != requester->take_reply(dds_response_wrapper)) {
    RMW_SET_ERROR_MSG("take_reply failed");
    return false;
  }

  int64_t sequence_number =
    (((int64_t)dds_response_wrapper.header().related_request_id().sequence_number().high) << 32) |
    dds_response_wrapper.header().related_request_id().sequence_number().low;
  request_header->sequence_number = sequence_number;

  ROSResponseType* ros_response = static_cast<ROSResponseType *>(untyped_ros_response);
  bool converted = @(__ros_srv_pkg_prefix)::typesupport_opendds_cpp::convert_dds_message_to_ros(
    dds_response_wrapper.response(), *ros_response);

  return converted;
}

bool send_response__@(service.namespaced_type.name)(
  void * untyped_replier,
  const rmw_request_id_t * request_header,
  const void * untyped_ros_response)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return true;
}

void *
get_request_datawriter__@(service.namespaced_type.name)(void * untyped_requester)
{
  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;
  RequesterType * requester = static_cast<RequesterType *>(untyped_requester);
  return requester->get_request_datawriter();
}

void *
get_reply_datareader__@(service.namespaced_type.name)(void * untyped_requester)
{
  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;
  RequesterType * requester = static_cast<RequesterType *>(untyped_requester);
  return requester->get_reply_datareader();
}

void *
get_request_datareader__@(service.namespaced_type.name)(void * untyped_replier)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return nullptr;
}

void *
get_reply_datawriter__@(service.namespaced_type.name)(void * untyped_replier)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return nullptr;
}

static service_type_support_callbacks_t _@(service.namespaced_type.name)__callbacks = {
  "@('::'.join([package_name] + list(interface_path.parents[0].parts)))",
  "@(service.namespaced_type.name)",
  &create_requester__@(service.namespaced_type.name),
  &destroy_requester__@(service.namespaced_type.name),
  &create_replier__@(service.namespaced_type.name),
  &destroy_replier__@(service.namespaced_type.name),
  &send_request__@(service.namespaced_type.name),
  &take_request__@(service.namespaced_type.name),
  &send_response__@(service.namespaced_type.name),
  &take_response__@(service.namespaced_type.name),
  &get_request_datawriter__@(service.namespaced_type.name),
  &get_reply_datareader__@(service.namespaced_type.name),
  &get_request_datareader__@(service.namespaced_type.name),
  &get_reply_datawriter__@(service.namespaced_type.name),
};

static rosidl_service_type_support_t _@(service.namespaced_type.name)__handle = {
  rosidl_typesupport_opendds_cpp::typesupport_identifier,
  &_@(service.namespaced_type.name)__callbacks,
  get_service_typesupport_handle_function,
};

}  // namespace typesupport_opendds_cpp

@[for ns in reversed(service.namespaced_type.namespaces)]@
}  // namespace @(ns)

@[end for]@

namespace rosidl_typesupport_opendds_cpp
{

template<>
ROSIDL_TYPESUPPORT_OPENDDS_CPP_EXPORT_@(package_name)
const rosidl_service_type_support_t *
get_service_type_support_handle<@(__ros_srv_type)>()
{
  return &@(__ros_srv_pkg_prefix)::typesupport_opendds_cpp::_@(service.namespaced_type.name)__handle;
}

}  // namespace rosidl_typesupport_opendds_cpp

#ifdef __cplusplus
extern "C"
{
#endif

const rosidl_service_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(
  rosidl_typesupport_opendds_cpp,
  @(', '.join([package_name] + list(interface_path.parents[0].parts))),
  @(service.namespaced_type.name))()
{
  return &@(__ros_srv_pkg_prefix)::typesupport_opendds_cpp::_@(service.namespaced_type.name)__handle;
}

#ifdef __cplusplus
}
#endif
