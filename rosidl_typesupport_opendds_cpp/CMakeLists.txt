cmake_minimum_required(VERSION 3.5)

project(rosidl_typesupport_opendds_cpp)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

# Load required CMake packages.
find_package(ament_cmake REQUIRED)
find_package(opendds_cmake_module REQUIRED)

find_package(OpenDDS QUIET MODULE)
if(OpenDDS_FOUND)
  find_package(OpenDDS MODULE)
endif()
if(NOT OpenDDS_FOUND OR OPENDDS_STATIC_DISABLE)
  ament_package()
  if(NOT OpenDDS_FOUND)
    message(WARNING "Could not find OpenDDS - skipping '${PROJECT_NAME}'")
  else()
    message(STATUS "OpenDDS static rmw implementation explicitly disabled - skipping '${PROJECT_NAME}'")
  endif()
  return()
endif()

find_package(ament_cmake_python REQUIRED)

ament_export_dependencies(rcutils)
ament_export_dependencies(rmw)
ament_export_dependencies(rosidl_cmake)
ament_export_dependencies(rosidl_generator_c)
ament_export_dependencies(rosidl_generator_cpp)
ament_export_dependencies(rosidl_generator_dds_idl)
ament_export_dependencies(rosidl_typesupport_interface)

ament_export_include_directories(include)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

# Make this package available to other ROS-2 packages.
ament_python_install_package(${PROJECT_NAME})

ament_export_include_directories(include)
add_library(${PROJECT_NAME} SHARED src/identifier.cpp)
if(WIN32)
  target_compile_definitions(${PROJECT_NAME}
    PRIVATE "ROSIDL_TYPESUPPORT_OPENDDS_CPP_BUILDING_DLL")
endif()
target_include_directories(${PROJECT_NAME}
  PUBLIC
  include
)
ament_export_libraries(${PROJECT_NAME})

ament_index_register_resource("rosidl_typesupport_cpp")

ament_package(
  CONFIG_EXTRAS "rosidl_typesupport_opendds_cpp-extras.cmake.in"
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

install(
  DIRECTORY cmake
  DESTINATION share/${PROJECT_NAME}
)

install(
  DIRECTORY include/
  DESTINATION include
)

install(
  TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)
