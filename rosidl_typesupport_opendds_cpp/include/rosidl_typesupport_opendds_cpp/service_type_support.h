// Copyright 2014-2015 Open Source Robotics Foundation, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef ROSIDL_TYPESUPPORT_OPENDDS_CPP__SERVICE_TYPE_SUPPORT_H_
#define ROSIDL_TYPESUPPORT_OPENDDS_CPP__SERVICE_TYPE_SUPPORT_H_

#include <stdint.h>
#include <rmw/types.h>
#include "rosidl_runtime_c/service_type_support_struct.h"
#include "dds/DCPS/Service_Participant.h"

typedef void* (*allocator_t)(size_t);
typedef void (*deallocator_t)(void*);

typedef struct service_type_support_callbacks_t
{
  const char * service_namespace;
  const char * service_name;
  //! Function to create a requester
  /*!
  Default Reader / Writer QoS of the passed Publisher / Subscriber must be set to desired values prior to calling this function
  */
  void * (*create_requester)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator,
    deallocator_t deallocator);
  //! Function to destroy a requester
  const char * (*destroy_requester)(
    void * untyped_requester, deallocator_t deallocator);
  //! Function to create a replier
  /*!
  Default Reader / Writer QoS of the passed Publisher / Subscriber must be set to desired values prior to calling this function
  */
  void * (*create_replier)(
    DDS::DomainParticipant_var dds_participant,
    const char * request_topic_str,
    const char * response_topic_str,
    DDS::Publisher_var dds_publisher,
    DDS::Subscriber_var dds_subscriber,
    allocator_t allocator,
    deallocator_t deallocator);
  //! Function to destroy a replier
  const char * (*destroy_replier)(
    void * untyped_replier, deallocator_t deallocator);
  // Function to send ROS requests
  int64_t (* send_request)(void * requester, const void * ros_request);
  // Function to read a ROS request from the wire
  bool (* take_request)(void * replier, rmw_service_info_t * request_header, void * ros_request);
  // Function to send ROS responses
  bool (* send_response)(
    void * replier, const rmw_request_id_t * request_header,
    const void * ros_response);
  // Function to read a ROS response from the wire
  bool (* take_response)(void * requester, rmw_service_info_t * request_header, void * ros_response);
  // Function to get the type erased dds request datawriter for the requester
  void *
  (*get_request_datawriter)(void * untyped_requester);
  // Function to get the type erased dds reply datawriter for the requester
  void *
  (*get_reply_datareader)(void * untyped_requester);
  // Function to get the type erased dds request datawriter for the replier
  void *
  (*get_request_datareader)(void * untyped_replier);
  // Function to get the type erased dds reply datawriter for the replier
  void *
  (*get_reply_datawriter)(void * untyped_replier);
} service_type_support_callbacks_t;

#endif  // ROSIDL_TYPESUPPORT_OPENDDS_CPP__SERVICE_TYPE_SUPPORT_H_
