find_package(opendds_cmake_module QUIET)
find_package(OpenDDS QUIET MODULE)
if(NOT OpenDDS_FOUND)
  message(STATUS
    "Could not find OpenDDS - skipping rosidl_typesupport_opendds_c")
else()
  find_package(ament_cmake_core QUIET REQUIRED)
  ament_register_extension(
      "rosidl_generate_interfaces"
      "rosidl_typesupport_opendds_c"
      "rosidl_typesupport_opendds_c_generate_interfaces.cmake")
endif()
