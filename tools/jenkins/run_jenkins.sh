#!/bin/bash
# Copyright 2015, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This script is invoked by Jenkins and triggers a test run based on
# env variable settings.

set -ex

if [ "$platform" == "linux" ]
then
  echo "building $language on Linux"

  # Run tests inside docker
  docker run grpc/grpc_jenkins_slave bash -c "git clone --recursive $GIT_URL /var/local/git/grpc \
    && cd /var/local/git/grpc && git checkout -f $GIT_COMMIT \
    && git submodule update \
    && tools/run_tests/run_tests.py -t -l $language"
elif [ "$platform" == "windows" ]
then
  echo "building $language on Windows"

  # TODO(jtattermusch): integrate nuget restore in a nicer way.
  /cygdrive/c/nuget/nuget.exe restore vsprojects/grpc.sln
  /cygdrive/c/nuget/nuget.exe restore src/csharp/Grpc.sln

  python tools/run_tests/run_tests.py -t -l $language
else
  echo "Unknown platform $platform"
  exit 1
fi