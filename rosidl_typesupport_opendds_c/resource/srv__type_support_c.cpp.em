@# Included from rosidl_typesupport_opendds_c/resource/idl__dds_opendds__type_support_c.cpp.em
@{
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
include_parts = [package_name] + list(interface_path.parents[0].parts)
include_base = '/'.join(include_parts)
cpp_include_prefix = interface_path.stem

c_include_prefix = convert_camel_case_to_lower_case_underscore(cpp_include_prefix)

header_files = [
    include_base + '/' + c_include_prefix + '__rosidl_typesupport_opendds_c.h',
    'rosidl_typesupport_opendds_cpp/service_type_support.h',
    'rosidl_typesupport_opendds_cpp/message_type_support.h',
    'rmw/rmw.h',
    'rosidl_typesupport_cpp/service_type_support.hpp',
    'rosidl_typesupport_opendds_c/identifier.h',
    package_name + '/msg/rosidl_typesupport_opendds_c__visibility_control.h',
    include_base + '/' + c_include_prefix + '.h',
    'rosidl_typesupport_opendds_cpp/requester_parameters.h',
    'rosidl_typesupport_opendds_cpp/replier_parameters.h',
    'rosidl_typesupport_opendds_cpp/requester.hpp',
    'rosidl_typesupport_opendds_cpp/replier.hpp',
# Re-use most of the functions from C++ typesupport
    include_base + '/' + c_include_prefix + '__rosidl_typesupport_opendds_cpp.hpp',
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
    'msg__type_support_c.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.request_message,
    include_directives=include_directives
)
}@

@{
TEMPLATE(
    'msg__type_support_c.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.response_message,
    include_directives=include_directives
)
}@

class DDSDomainParticipant;
class DDSDataReader;
struct DDS_SampleIdentity_t;

#if defined(__cplusplus)
extern "C"
{
#endif

@{
__ros_srv_pkg_prefix = '::'.join(service.namespaced_type.namespaces)
__ros_request_msg_type = __ros_srv_pkg_prefix + '::' + service.request_message.structure.namespaced_type.name
__ros_response_msg_type = __ros_srv_pkg_prefix + '::' + service.response_message.structure.namespaced_type.name
__dds_request_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.request_message.structure.namespaced_type.name + '_'
__dds_response_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.response_message.structure.namespaced_type.name + '_'
__dds_request_wrapper_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.namespaced_type.name + 'RequestWrapper'
__dds_response_wrapper_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.namespaced_type.name + 'ResponseWrapper'
__dds_msg_typesupport_type = __ros_srv_pkg_prefix + '::dds_::' + service.namespaced_type.name
__dds_header_prefix = __ros_srv_pkg_prefix + '::dds_::'
__rpc_header_prefix = '::typesupport_opendds_cpp_dds::rpc::'
}@
static void * create_requester__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator,
    deallocator_t deallocator)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::create_requester__@(service.namespaced_type.name)(
    dds_participant,
    request_topic_str,
    response_topic_str,
    dds_publisher,
    dds_subscriber,
    allocator,
    deallocator);
}
static const char * destroy_requester__@(service.namespaced_type.name)(
  void * untyped_requester,
  deallocator_t deallocator)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::destroy_requester__@(service.namespaced_type.name)(
    untyped_requester, deallocator);
}

static int64_t send_request__@(service.namespaced_type.name)(
  void * untyped_requester,
  const void * untyped_ros_request)
{
  using DDSRequestType = @(__dds_request_msg_type);
  using RequesterType = rosidl_typesupport_opendds_cpp::Requester<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;

  DDSRequestType dds_request;

  const rosidl_message_type_support_t * ts =
    ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_opendds_c,
    @(', '.join(service.request_message.structure.namespaced_type.namespaces)),
    @(service.request_message.structure.namespaced_type.name))();
  const message_type_support_callbacks_t * callbacks =
    static_cast<const message_type_support_callbacks_t *>(ts->data);

  if (!callbacks->convert_ros_to_dds(untyped_ros_request, &dds_request)) {
      fprintf(stderr, "failed to convert ROS request to DDS\n");
      return -1;
  }

  @(__dds_msg_typesupport_type)RequestWrapper request_wrapper;
  request_wrapper.request(dds_request);

  RequesterType * requester = static_cast<RequesterType *>(untyped_requester);
  if (DDS::RETCODE_OK != requester->send_request(request_wrapper)) {
    fprintf(stderr, "send_request failed\n");
    return -1;
  }

  return requester->get_sequence_number().getValue();
}

static void * create_replier__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator,
    deallocator_t deallocator)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::create_replier__@(service.namespaced_type.name)(
    dds_participant,
    request_topic_str,
    response_topic_str,
    dds_publisher,
    dds_subscriber,
    allocator,
    deallocator);
}

static const char * destroy_replier__@(service.namespaced_type.name)(
  void * untyped_replier,
  deallocator_t deallocator)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::destroy_replier__@(service.namespaced_type.name)(
    untyped_replier, deallocator);
}

static bool take_request__@(service.namespaced_type.name)(
  void * untyped_replier,
  rmw_service_info_t * request_header,
  void * untyped_ros_request)
{
  using ReplierType = rosidl_typesupport_opendds_cpp::Replier<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;
  if (!untyped_replier || !request_header || !untyped_ros_request) {
    return false;
  }
  
  ReplierType * replier = static_cast<ReplierType *>(untyped_replier);

  @(__dds_msg_typesupport_type)RequestWrapper dds_request_wrapper;

  if (DDS::RETCODE_OK != replier->take_request(dds_request_wrapper)) {
    fprintf(stderr, "take_request failed\n");
    return false;
  }

  OpenDDS::DCPS::SequenceNumber sn;
  sn.setValue(dds_request_wrapper.header().request_id().sequence_number().high, dds_request_wrapper.header().request_id().sequence_number().low);
  request_header->request_id.sequence_number = sn.getValue();

  OpenDDS::DCPS::GUID_t id = dds_request_wrapper.header().request_id().writer_guid();
  std::memcpy(&(request_header->request_id.writer_guid[0]), &id, RPC_SAMPLE_IDENTITY_SIZE);

  const rosidl_message_type_support_t * ts =
    ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_opendds_c,
    @(', '.join(service.request_message.structure.namespaced_type.namespaces)),
    @(service.request_message.structure.namespaced_type.name))();
  const message_type_support_callbacks_t * callbacks =
    static_cast<const message_type_support_callbacks_t *>(ts->data);
  return callbacks->convert_dds_to_ros(&(dds_request_wrapper.request()), untyped_ros_request);
}

static bool take_response__@(service.namespaced_type.name)(
  void * untyped_requester,
  rmw_service_info_t * request_header,
  void * untyped_ros_response)
{
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
    fprintf(stderr, "take_reply failed\n");
    return false;
  }

  OpenDDS::DCPS::SequenceNumber sn;
  sn.setValue(dds_response_wrapper.header().related_request_id().sequence_number().high, dds_response_wrapper.header().related_request_id().sequence_number().low);
  request_header->request_id.sequence_number = sn.getValue();

  const rosidl_message_type_support_t * ts =
    ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_opendds_c,
    @(', '.join(service.response_message.structure.namespaced_type.namespaces)),
    @(service.response_message.structure.namespaced_type.name))();
  const message_type_support_callbacks_t * callbacks =
    static_cast<const message_type_support_callbacks_t *>(ts->data);
  return callbacks->convert_dds_to_ros(&(dds_response_wrapper.response()), untyped_ros_response);
}

bool send_response__@(service.namespaced_type.name)(
  void * untyped_replier,
  const rmw_request_id_t * request_header,
  const void * untyped_ros_response)
{
  using DDSResponseType = @(__dds_response_msg_type);
  using ReplierType = rosidl_typesupport_opendds_cpp::Replier<
    @(__dds_msg_typesupport_type)RequestWrapper,
    @(__dds_msg_typesupport_type)ResponseWrapper
  >;
  if (!untyped_replier || !request_header || !untyped_ros_response) {
    return false;
  }

  DDSResponseType dds_response;

  const rosidl_message_type_support_t * ts =
    ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_opendds_c,
    @(', '.join(service.response_message.structure.namespaced_type.namespaces)),
    @(service.response_message.structure.namespaced_type.name))();
  const message_type_support_callbacks_t * callbacks =
    static_cast<const message_type_support_callbacks_t *>(ts->data);

  if (!callbacks->convert_ros_to_dds(untyped_ros_response, &dds_response)) {
   fprintf(stderr, "failed to convert ROS response to DDS\n");
   return false;
  }

  @(__dds_msg_typesupport_type)ResponseWrapper response_wrapper;
  response_wrapper.response(dds_response);

  @# Convert request_header to related_request_id
  @(__rpc_header_prefix)SampleIdentity related_request_id;
  OpenDDS::DCPS::RepoId id;
  std::memcpy(&id, &(request_header->writer_guid[0]), RPC_SAMPLE_IDENTITY_SIZE);
  related_request_id.writer_guid(id);

  OpenDDS::DCPS::SequenceNumber sn = request_header->sequence_number;
  related_request_id.sequence_number().high = sn.getHigh();
  related_request_id.sequence_number().low = sn.getLow();

  response_wrapper.header().related_request_id(related_request_id);
  response_wrapper.header().remote_ex(@(__rpc_header_prefix)RemoteExceptionCode_t::REMOTE_EX_OK);

  ReplierType * replier = static_cast<ReplierType *>(untyped_replier);
  if (DDS::RETCODE_OK != replier->send_reply(response_wrapper)) {
    fprintf(stderr, "send_reply failed\n");
    return false;
  }

  return true;
}

static void *
get_request_datawriter__@(service.namespaced_type.name)(void * untyped_requester)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::get_request_datawriter__@(service.namespaced_type.name)(
    untyped_requester);
}

static void *
get_reply_datareader__@(service.namespaced_type.name)(void * untyped_requester)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::get_reply_datareader__@(service.namespaced_type.name)(
    untyped_requester);
}

static void *
get_request_datareader__@(service.namespaced_type.name)(void * untyped_replier)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::get_request_datareader__@(service.namespaced_type.name)(
    untyped_replier);
}

static void *
get_reply_datawriter__@(service.namespaced_type.name)(void * untyped_replier)
{
  return @('::'.join(service.namespaced_type.namespaces))::typesupport_opendds_cpp::get_reply_datawriter__@(service.namespaced_type.name)(
    untyped_replier);
}

static service_type_support_callbacks_t _@(service.namespaced_type.name)__callbacks = {
  "@('::'.join([package_name] + list(interface_path.parents[0].parts)))",  // service_namespace
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
  &get_reply_datawriter__@(service.namespaced_type.name)
};

static rosidl_service_type_support_t _@(service.namespaced_type.name)__type_support = {
  rosidl_typesupport_opendds_c__identifier,
  &_@(service.namespaced_type.name)__callbacks,
  get_service_typesupport_handle_function,
};

const rosidl_service_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(
  rosidl_typesupport_opendds_c,
  @(', '.join([package_name] + list(interface_path.parents[0].parts))),
  @(service.namespaced_type.name))()
{
  return &_@(service.namespaced_type.name)__type_support;
}

#if defined(__cplusplus)
}
#endif
