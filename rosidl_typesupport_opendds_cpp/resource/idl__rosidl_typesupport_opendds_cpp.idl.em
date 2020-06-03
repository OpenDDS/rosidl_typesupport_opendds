// generated from rosidl_typesupport_opendds_cpp/resource/idl__rosidl_typesupport_opendds_cpp.idl.em
// with input from @(package_name):@(interface_path)
// generated code does not contain a copyright notice

@{
#######################################################################
# EmPy template for generating <idl>__rosidl_typesupport_opendds_cpp.idl files
#
# Context:
#  - package_name (string)
#  - content (rosidl_parser.definition.IdlContent result of parsing IDL file)
#  - interface_path (Path relative to the directory named after the package)
#######################################################################
from rosidl_cmake import convert_camel_case_to_lower_case_underscore
include_parts = [package_name] + list(interface_path.parents[0].parts) + \
    [convert_camel_case_to_lower_case_underscore(interface_path.stem)]
header_guard_variable = '__'.join([x.upper() for x in include_parts]) + \
    '__ROSIDL_TYPESUPPORT_OPENDDS_CPP_HPP_'
include_directives = set()
}@

#ifndef @(header_guard_variable)
#define @(header_guard_variable)

#include "RPC.idl"

@{from rosidl_parser.definition import Service}
@[for service in content.get_elements_of_type(Service)]
#include "@(service.namespaced_type.name)_.idl"

module @(package_name) {

module srv {

module dds_ {

@@topic
struct @(service.namespaced_type.name)RequestWrapper {
  ::typesupport_opendds_cpp_dds::rpc::RequestHeader header;
  @(service.namespaced_type.name)_Request_ request;
};
@@topic
struct @(service.namespaced_type.name)ResponseWrapper {
  ::typesupport_opendds_cpp_dds::rpc::ResponseHeader header;
  @(service.namespaced_type.name)_Response_ response;
};

};  // module dds_

};  // module srv

};  // module @(package_name)

@[end for]

@{from rosidl_parser.definition import Action}
@[for action in content.get_elements_of_type(Action)]
#include "@(action.namespaced_type.name)_.idl"

module @(package_name) {

module action {

module dds_ {

@@topic
struct @(action.send_goal_service.namespaced_type.name)RequestWrapper {
  ::typesupport_opendds_cpp_dds::rpc::RequestHeader header;
  @(action.send_goal_service.namespaced_type.name)_Request_ request;
};
@@topic
struct @(action.send_goal_service.namespaced_type.name)ResponseWrapper {
  ::typesupport_opendds_cpp_dds::rpc::ResponseHeader header;
  @(action.send_goal_service.namespaced_type.name)_Response_ response;
};

@@topic
struct @(action.get_result_service.namespaced_type.name)RequestWrapper {
  ::typesupport_opendds_cpp_dds::rpc::RequestHeader header;
  @(action.get_result_service.namespaced_type.name)_Request_ request;
};
@@topic
struct @(action.get_result_service.namespaced_type.name)ResponseWrapper {
  ::typesupport_opendds_cpp_dds::rpc::ResponseHeader header;
  @(action.get_result_service.namespaced_type.name)_Response_ response;
};

};  // module dds_

};  // module action

};  // module @(package_name)

@[end for]

#endif  // @(header_guard_variable)
