# Copyright 2016-2018 Proyectos y Sistemas de Mantenimiento SL (eProsima).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
#
# CMake module for finding OpenDDS.
#
# Output variables:
#
# - OpenDDS_FOUND: flag indicating if the package was found
# - OpenDDS_INCLUDE_DIR: Paths to the header files
#
# Example usage:
#
#   find_package(opendds_cmake_module REQUIRED)
#   find_package(OpenDDS MODULE)
#
###############################################################################

# lint_cmake: -convention/filename, -package/stdargs

set(OpenDDS_FOUND FALSE)

find_path(OpenDDS_INCLUDE_DIR
  NAMES opendds/)

find_package(opendds REQUIRED CONFIG)

string(REGEX MATCH "^[0-9]+\\.[0-9]+" opendds_MAJOR_MINOR_VERSION "${opendds_VERSION}")

find_library(OpenDDS_LIBRARY_RELEASE
  NAMES opendds-${opendds_MAJOR_MINOR_VERSION} opendds)

find_library(OpenDDS_LIBRARY_DEBUG
  NAMES openddsd-${opendds_MAJOR_MINOR_VERSION})

if(OpenDDS_LIBRARY_RELEASE AND OpenDDS_LIBRARY_DEBUG)
  set(OpenDDS_LIBRARIES
    optimized ${OpenDDS_LIBRARY_RELEASE}
    debug ${OpenDDS_LIBRARY_DEBUG}
  )
elseif(OpenDDS_LIBRARY_RELEASE)
  set(OpenDDS_LIBRARIES
    ${OpenDDS_LIBRARY_RELEASE}
  )
elseif(OpenDDS_LIBRARY_DEBUG)
  set(OpenDDS_LIBRARIES
    ${OpenDDS_LIBRARY_DEBUG}
  )
else()
  set(OpenDDS_LIBRARIES "")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OpenDDS
  FOUND_VAR OpenDDS_FOUND
  REQUIRED_VARS
    OpenDDS_INCLUDE_DIR
    OpenDDS_LIBRARIES
)
