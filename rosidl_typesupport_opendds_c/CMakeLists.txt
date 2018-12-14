cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_opendds_c)

# Load required CMake packages.
find_package(ament_cmake REQUIRED)
find_package(ament_cmake_python REQUIRED)
find_package(opendds_cmake_module REQUIRED)
find_package(OpenDDS MODULE)

ament_export_dependencies(rmw)
ament_export_dependencies(rosidl_cmake)
ament_export_dependencies(rosidl_generator_c)
ament_export_dependencies(rosidl_generator_dds_idl_
ament_export_dependencies(rosidl_typesupport_opendds_cpp)
ament_export_include_directories(include)

ament_python_install_package(${PROJECT_NAME})

add_library(${PROJECT_NAME} SHARED src/identifier.cpp)
if(WIN32)
  target_compile_definitions(${PROJECT_NAME}
    PRIVATE "ROSIDL_TYPESUPPORT_OPENDDS_C_BUILDING_DLL")
endif()
target_include_directories(${PROJECT_NAME} PUBLIC include)
ament_target_dependencies(${PROJECT_NAME} "rosidl_typesupport_opendds_cpp")
ament_export_libraries(${PROJECT_NAME})

ament_index_register_resource("rosidl_typesupport_c")

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package(
  CONFIG_EXTRAS "rosidl_typesupport_opendds_c-extras.cmake.in"
)

install(
  PROGRAMS bin/rosidl_typesupport_opendds_c
  DESTINATION lib/rosidl_typesupport_opendds_c
)

install(
  DIRECTORY cmake
  DESTINATION share/${PROJECT_NAME}
)

install(
  DIRECTORY include/
  DESTINATION include
)

install(
  DIRECTORY cmake resource
  DESTINATION share/${PROJECT_NAME}
)
