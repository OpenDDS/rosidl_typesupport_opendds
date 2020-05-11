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
    include_base + '/dds_opendds/' + cpp_include_prefix + '_TypeSupportImpl.h',
    include_base + '/' + c_include_prefix + '.h',
# Re-use most of the functions from C++ typesupport
    include_base + '/' + c_include_prefix + '__rosidl_typesupport_opendds_cpp.hpp',
]

dds_specific_header_files = [
    include_base + '/dds_opendds/' + cpp_include_prefix + '_C.h',
    include_base + '/dds_opendds/' + cpp_include_prefix + '_TypeSupportImpl.h'
    include_base + '/dds_opendds/' + cpp_include_prefix + '__RequestResponseC.h',
    include_base + '/dds_opendds/' + cpp_include_prefix + '__RequestResponseTypeSupportImpl.h',
]
}@
#ifdef OpenDDS_GLIBCXX_USE_CXX11_ABI_ZERO
#define _GLIBCXX_USE_CXX11_ABI 0
#endif

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
}@
static void * create_requester__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator)
{
  return NULL;
}
static const char * destroy_requester__@(service.namespaced_type.name)(
  void * untyped_requester,
  deallocator_t deallocator)
{
@# TODO: Implement
  return NULL;
}

static int64_t send_request__@(service.namespaced_type.name)(
  void * untyped_requester,
  const void * untyped_ros_request)
{
@# TODO: Implement
  return 1;
}

static void * create_replier__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return NULL;
}

static const char * destroy_replier__@(service.namespaced_type.name)(
  void * untyped_replier,
  deallocator_t deallocator)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return NULL;
}

static bool take_request__@(service.namespaced_type.name)(
  void * untyped_replier,
  rmw_request_id_t * request_header,
  void * untyped_ros_request)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return true;
}

static bool take_response__@(service.namespaced_type.name)(
  void * untyped_requester,
  rmw_request_id_t * request_header,
  void * untyped_ros_response)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return true;
}

bool send_response__@(service.namespaced_type.name)(
  void * untyped_replier,
  const rmw_request_id_t * request_header,
  const void * untyped_ros_response)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return true;
}

static void *
get_request_datawriter__@(service.namespaced_type.name)(void * untyped_requester)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return NULL;
}

static void *
get_reply_datareader__@(service.namespaced_type.name)(void * untyped_requester)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return NULL;
}

static void *
get_request_datareader__@(service.namespaced_type.name)(void * untyped_replier)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return NULL;
}

static void *
get_reply_datawriter__@(service.namespaced_type.name)(void * untyped_replier)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return NULL;
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
