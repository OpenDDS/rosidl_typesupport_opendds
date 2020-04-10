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
    include_base + '/' + c_include_prefix + '__struct.hpp'
]

dds_specific_header_files = [
    include_base + '/dds_opendds/' + interface_path.stem + '_C.h',
    include_base + '/dds_opendds/' + interface_path.stem + '_TypeSupportImpl.h'
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

class DDSDomainParticipant;
class DDSDataReader;
struct DDS_SampleIdentity_t;

@[for ns in service.namespaced_type.namespaces]@

namespace @(ns)
{
@[end for]@
namespace typesupport_opendds_cpp
{
@{
__ros_srv_pkg_prefix = '::'.join(service.namespaced_type.namespaces)
__ros_srv_type = __ros_srv_pkg_prefix + '::' + service.namespaced_type.name
__ros_request_msg_type = __ros_srv_pkg_prefix + '::' + service.request_message.structure.namespaced_type.name
__ros_response_msg_type = __ros_srv_pkg_prefix + '::' + service.response_message.structure.namespaced_type.name
__dds_request_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.request_message.structure.namespaced_type.name + '_'
__dds_response_msg_type = __ros_srv_pkg_prefix + '::dds_::' + service.response_message.structure.namespaced_type.name + '_'
}@

void * create_requester__@(service.namespaced_type.name)(
  void * untyped_participant,
  const char * request_topic_str,
  const char * response_topic_str,
  const void * untyped_datareader_qos,
  const void * untyped_datawriter_qos,
  void ** untyped_reader,
  void ** untyped_writer,
  void * (*allocator)(size_t))
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return NULL;
}

const char * destroy_requester__@(service.namespaced_type.name)(
  void * untyped_requester,
  void (* deallocator)(void *))
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return nullptr;
}

int64_t send_request__@(service.namespaced_type.name)(
  void * untyped_requester,
  const void * untyped_ros_request)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
  return 1;
}

void * create_replier__@(service.namespaced_type.name)(
  void * untyped_participant,
  const char * request_topic_str,
  const char * response_topic_str,
  const void * untyped_datareader_qos,
  const void * untyped_datawriter_qos,
  void ** untyped_reader,
  void ** untyped_writer,
  void * (*allocator)(size_t))
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return NULL;
}

const char * destroy_replier__@(service.namespaced_type.name)(
  void * untyped_replier,
  void (* deallocator)(void *))
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

void *
get_request_datawriter__@(service.namespaced_type.name)(void * untyped_requester)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return NULL;
}

void *
get_reply_datareader__@(service.namespaced_type.name)(void * untyped_requester)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return NULL;
}

void *
get_request_datareader__@(service.namespaced_type.name)(void * untyped_replier)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return NULL;
}

void *
get_reply_datawriter__@(service.namespaced_type.name)(void * untyped_replier)
{
@# TODO: Implement, considering original code in ffe10f9 or earlier
    return NULL;
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
