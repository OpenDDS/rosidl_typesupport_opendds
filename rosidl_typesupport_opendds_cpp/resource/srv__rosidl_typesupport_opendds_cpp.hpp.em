@# Included from rosidl_typesupport_opendds_cpp/resource/srv__rosidl_typesupport_opendds_cpp.hpp.em
@{
TEMPLATE(
    'msg__rosidl_typesupport_opendds_cpp.hpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.request_message,
    include_directives=include_directives
)
}@

@{
TEMPLATE(
    'msg__rosidl_typesupport_opendds_cpp.hpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.response_message,
    include_directives=include_directives
)
}@

@{
header_files = [
    'rmw/types.h',
    'rosidl_typesupport_cpp/service_type_support.hpp',
    'rosidl_typesupport_interface/macros.h',
    package_name + '/msg/rosidl_typesupport_opendds_cpp__visibility_control.h',
    'dds/DCPS/Service_Participant.h'
]
}@
@[for header_file in header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include "@(header_file)"
@[end for]@

typedef void* (*allocator_t)(size_t);
typedef void (*deallocator_t)(void*);

@[for ns in service.namespaced_type.namespaces]@
namespace @(ns)
{
@[end for]@
namespace typesupport_opendds_cpp
{

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
void *
create_requester__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator,
    deallocator_t deallocator);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
const char *
destroy_requester__@(service.namespaced_type.name)(
  void * untyped_requester,
  deallocator_t deallocator);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
int64_t
send_request__@(service.namespaced_type.name)(
  void * untyped_requester,
  const void * untyped_ros_request);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
void *
create_replier__@(service.namespaced_type.name)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator,
    deallocator_t deallocator);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
const char *
destroy_replier__@(service.namespaced_type.name)(
  void * untyped_replier,
  deallocator_t deallocator);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
bool
take_request__@(service.namespaced_type.name)(
  void * untyped_replier,
  rmw_service_info_t * request_header,
  void * untyped_ros_request);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
bool
take_response__@(service.namespaced_type.name)(
  void * untyped_requester,
  rmw_service_info_t * request_header,
  void * untyped_ros_response);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
bool
send_response__@(service.namespaced_type.name)(
  void * untyped_replier,
  const rmw_request_id_t * request_header,
  const void * untyped_ros_response);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
void *
get_request_datawriter__@(service.namespaced_type.name)(void * untyped_requester);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
void *
get_reply_datareader__@(service.namespaced_type.name)(void * untyped_requester);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
void *
get_request_datareader__@(service.namespaced_type.name)(void * untyped_replier);

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
void *
get_reply_datawriter__@(service.namespaced_type.name)(void * untyped_replier);

}  // namespace typesupport_opendds_cpp
@[for ns in reversed(service.namespaced_type.namespaces)]@
}  // namespace @(ns)
@[end for]@

#ifdef __cplusplus
extern "C"
{
#endif

ROSIDL_TYPESUPPORT_OPENDDS_CPP_PUBLIC_@(package_name)
const rosidl_service_type_support_t *
  ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(
  rosidl_typesupport_opendds_cpp,
  @(', '.join([package_name] + list(interface_path.parents[0].parts))),
  @(service.namespaced_type.name))();

#ifdef __cplusplus
}
#endif


