# -------------------------------------------------------------------------
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