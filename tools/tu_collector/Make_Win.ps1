﻿# -------------------------------------------------------------------------
#
#  Part of the CodeChecker project, under the Apache License v2.0 with
#  LLVM Exceptions. See LICENSE for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# -------------------------------------------------------------------------

$CURRENT_DIR = Get-Location
$BUILD_DIR = "build"
$BIN_DIR = "$BUILD_DIR\bin"
$TU_COLLECTOR_DIR = "$BUILD_DIR\tu_collector"

function build()
{
    python setup.py build --build-purelib $TU_COLLECTOR_DIR
}	
function clean()
{
	Remove-Item -Force -Recurse -ErrorAction Ignore $BUILD_DIR
	Remove-Item -Force -Recurse -ErrorAction Ignore .\dist
	Remove-Item -Force -Recurse -ErrorAction Ignore .\tu_collector.egg-info
}