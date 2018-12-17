# generated from
# rosidl_typesupport_opendds_cpp/rosidl_typesupport_opendds_cpp-extras.cmake

find_package(opendds_cmake_module QUIET)
find_package(ament_cmake REQUIRED)
if(NOT OpenDDS_FOUND)
  message(STATUS
    "Could not find OpenDDS - skipping rosidl_typesupport_opendds_cpp")
else()
  find_package(ament_cmake_core QUIET REQUIRED)
  ament_register_extension(
    "rosidl_generate_interfaces"
    "rosidl_typesupport_opendds_cpp"
    "rosidl_typesupport_opendds_cpp_generate_interfaces.cmake")

  set(rosidl_typesupport_opendds_cpp_BIN
    "${rosidl_typesupport_opendds_cpp_DIR}/../../../lib/rosidl_typesupport_opendds_cpp/rosidl_typesupport_opendds_cpp")
  normalize_path(rosidl_typesupport_opendds_cpp_BIN
    "${rosidl_typesupport_opendds_cpp_BIN}")
endif()
