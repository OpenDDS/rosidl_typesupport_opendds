if(DEFINED OpenDDS_FOUND)
  return()
endif()

set(OpenDDS_FOUND FALSE)

if(NOT DEFINED ENV{DDS_ROOT})
  message(FATAL_ERROR "DDS_ROOT must be set. Have you sourced $DDS_ROOT/setenv.sh?")
endif()
if(NOT DEFINED ENV{ACE_ROOT})
  message(FATAL_ERROR "ACE_ROOT must be set. Have you sourced $DDS_ROOT/setenv.sh?")
endif()
if(NOT DEFINED ENV{TAO_ROOT})
  message(FATAL_ERROR "TAO_ROOT must be set. Have you sourced $DDS_ROOT/setenv.sh?")
endif()

if(DEFINED ENV{DDS_ROOT})
  # Configure OpenDDS/ACE/TAO root variable.
  normalize_path(DDS_ROOT $ENV{DDS_ROOT})
  normalize_path(ACE_ROOT $ENV{ACE_ROOT})
  normalize_path(TAO_ROOT $ENV{TAO_ROOT})
  if(DDS_ROOT STREQUAL CMAKE_INSTALL_PREFIX)
    set(DDS_ROOT "$AMENT_CURRENT_PREFIX")
  endif()

  # Ensure existence of tao_idl compiler.
  find_program(TAO_IDL tao_idl $ENV{ACE_ROOT}/bin NO_DEFAULT_PATH)
  if(NOT TAO_IDL)
    message(FATAL_ERROR "tao_idl compiler not found. Is $ACE_ROOT configured correctly?")
  else()
    set(OpenDDS_TaoIdlProcessor ${TAO_IDL})
  endif()

  # Ensure existence of opendds_idl compiler.
  find_program(OPENDDS_IDL opendds_idl $ENV{DDS_ROOT}/bin NO_DEFAULT_PATH)
  if(NOT OPENDDS_IDL)
  message(FATAL_ERROR "opendds_idl compiler not found. Is $DDS_ROOT configured correctly?")
  else()
    set(OpenDDS_OpenDdsIdlProcessor ${OPENDDS_IDL})
  endif()

  # Set OpenDDS library directory.
  set(OpenDDS_INCLUDE_DIRS ${DDS_ROOT} ${ACE_ROOT} ${TAO_ROOT})
  set(OpenDDS_HEADER_DIRS "${DDS_ROOT}/dds")
  set(OpenDDS_LIBRARY_DIRS ${DDS_ROOT}/lib ${ACE_ROOT}/lib ${TAO_ROOT}/lib)

  set(_ace_libs
    #ACE_XML_Utils
    ACE)

  set(_tao_libs
    TAO_IORManip
    TAO_ImR_Client
    TAO_Svc_Utils
    TAO_IORTable
    TAO_IDL_FE
    TAO_PortableServer
    TAO_BiDirGIOP
    TAO_PI
    TAO_CodecFactory
    TAO_AnyTypeCode
    TAO)

  set(_opendds_libs
    OpenDDS_Dcps
    OpenDDS_Federator
    OpenDDS_InfoRepoDiscovery
    OpenDDS_InfoRepoLib
    OpenDDS_InfoRepoServ
    OpenDDS_Model
    OpenDDS_monitor
    OpenDDS_Multicast
    #OpenDDS_QOS_XML_XSC_Handler
    OpenDDS_Rtps
    OpenDDS_Rtps_Udp
    OpenDDS_Shmem
    OpenDDS_Tcp
    OpenDDS_Udp)

  list(APPEND _all_libs ${_opendds_libs} ${_ace_libs} ${_tao_libs})

  set(OpenDDS_LIBRARIES ${_all_libs})

  set(OpenDDS_FOUND TRUE)
endif()
