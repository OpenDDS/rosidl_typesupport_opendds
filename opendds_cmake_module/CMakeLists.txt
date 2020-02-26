cmake_minimum_required(VERSION 3.5)

project(opendds_cmake_module CXX)

find_package(ament_cmake REQUIRED)

# Discover OpenDDS.
find_package(OpenDDS QUIET)

# Configure Ament testing.
if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

# Make this package available to other ROS-2 packages.
ament_package()

# Install CMake utilities.
#install(DIRECTORY cmake DESTINATION share/${PROJECT_NAME})
install(PROGRAMS ${PROJECT_NAME}/${PROJECT_NAME} DESTINATION lib/${PROJECT_NAME})