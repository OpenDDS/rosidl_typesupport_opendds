# Copyright 2014 Open Source Robotics Foundation, Inc.
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

import os
import subprocess
import sys
import shutil

from rosidl_cmake import generate_files
from pathlib import Path
from ament_index_python.packages import get_package_share_directory
from ament_index_python.packages import get_package_prefix

def generate_dds_opendds_cpp(
        pkg_name, dds_interface_files, dds_interface_base_path, deps,
        output_basepath, idl_pp):

    # pkg_name may be used later (-Wb,export_macro=pkg_name) if the code will be compiled
    # into a shared library(*.so on Linux) and it will need to be called from other libraries.

    # List additional include directories for preprocessor
    include_dirs = [dds_interface_base_path]
    for dep in deps:
        # Extract from tuple: only take the first : for separation, as Windows follows with a C:\
        dep_parts = dep.split(':', 1)
        assert len(dep_parts) == 2, "The dependency '%s' must contain a double colon" % dep
        idl_path = dep_parts[1]
        idl_base_path = os.path.dirname(
            os.path.dirname(os.path.dirname(os.path.normpath(idl_path))))
        if idl_base_path not in include_dirs:
            include_dirs.append(idl_base_path)

    for idl_file in dds_interface_files:
        assert os.path.exists(idl_file), 'Could not find IDL file: ' + idl_file

        # get two level of parent folders for idl file
        folder = os.path.dirname(idl_file)
        parent_folder = os.path.dirname(folder)
        output_path = os.path.join(
            output_basepath,
            os.path.basename(parent_folder),
            os.path.basename(folder))
        try:
            os.makedirs(output_path)
        except FileExistsError:
            pass

        package_prefix = get_package_prefix('rosidl_typesupport_opendds_cpp')
        rpc_file_path = package_prefix + '/include/rosidl_typesupport_opendds_cpp'

        #msg_name is idl_file name without extension
        msg_name = os.path.splitext(os.path.basename(idl_file))[0]

        try:
            cmd = [idl_pp, idl_file, "-Lc++11", "-o", output_path, "-Cw"]
            for include_dir in include_dirs:
                cmd += ['-I', include_dir]
            cmd += ['-I', rpc_file_path]
            subprocess.check_call(cmd)
        except subprocess.CalledProcessError as e:
            raise RuntimeError('failed to generate the expected files')
            
        any_missing = False
        for suffix in ['C.h', 'TypeSupportImpl.cpp', 'TypeSupportImpl.h', 'TypeSupport.idl']:
            filename = os.path.join(output_path, msg_name + suffix)
            if not os.path.exists(filename):
                any_missing = True
                break
        if any_missing:
            print("'%s' failed to generate the expected files for '%s/%s'" %
                  (idl_pp, pkg_name, msg_name), file=sys.stderr)

        if "/srv/" in idl_file or "/action/" in idl_file:
            generated_idl_file = output_path + "/" + msg_name + "_RequestResponse.idl"
            input_idl_path = os.path.dirname(idl_file)

            try:
                cmd = [idl_pp, generated_idl_file, "-Lc++11", "-o", output_path, "-Sa", "-St", "-Cw", "--no-dcps-data-type-warnings"]
                for include_dir in include_dirs:
                    cmd += ['-I', include_dir]
                cmd += ['-I', input_idl_path]
                cmd += ['-I', rpc_file_path]
                subprocess.check_call(cmd)
            except subprocess.CalledProcessError as e:
                raise RuntimeError('OpenDDS compiler failed to generate the expected service files')
            
            any_missing = False
            for suffix in ['_RequestResponseC.h', '_RequestResponseTypeSupportImpl.cpp', '_RequestResponseTypeSupportImpl.h', '_RequestResponseTypeSupport.idl']:
                filename = os.path.join(output_path, msg_name + suffix)
                if not os.path.exists(filename):
                    any_missing = True
                    break
            if any_missing:
                print("'%s' failed to generate the expected files for '%s/%s'" %
                      (idl_pp, pkg_name, msg_name), file=sys.stderr)

            try:
                generated_idl_file = output_path + "/" + msg_name + "_RequestResponseTypeSupport.idl"
                cmd = ["tao_idl", generated_idl_file, "-o", output_path, "-I$TAO_ROOT", "-I$DDS_ROOT", "-I/opt/OpenDDS", "--idl-version",  "4", "-SS", "-Sa", "-St", "-Cw", "-Wb,pre_include=ace/pre.h", "-Wb,post_include=ace/post.h", "--unknown-annotations", "ignore"]
                for include_dir in include_dirs:
                    cmd += ['-I', include_dir]
                cmd += ['-I', input_idl_path]
                cmd += ['-I', output_path]
                cmd += ['-I', rpc_file_path]
                subprocess.check_call(cmd)
            except subprocess.CalledProcessError as e:
                raise RuntimeError('TAO IDL compiler failed to generate the expected service files')

    return 0


def generate_cpp(arguments_file):
    mapping = {
        'idl__rosidl_typesupport_opendds_cpp.hpp.em':
        '%s__rosidl_typesupport_opendds_cpp.hpp',
        'idl__dds_opendds__type_support.cpp.em':
        'dds_opendds/%s__type_support.cpp'
    }
    generate_files(arguments_file, mapping)
    return 0

def generate_idl(arguments_file):
    mapping = {
        'idl__rosidl_typesupport_opendds_cpp.idl.em':
        'dds_opendds/%s__RequestResponse.idl'
    }
    generate_files(arguments_file, mapping, None, True)
    return 0

