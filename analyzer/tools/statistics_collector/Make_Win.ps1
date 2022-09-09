# -------------------------------------------------------------------------
#
#  Part of the CodeChecker project, under the Apache License v2.0 with
#  LLVM Exceptions. See LICENSE for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# -------------------------------------------------------------------------

$CURRENT_DIR = Get-Location
$ROOT = $CURRENT_DIR

if($null -eq $BUILD_DIR)
{
    $BUILD_DIR = "$CURRENT_DIR\build"
}
$STATISTICS_COLLECTOR_DIR = "$BUILD_DIR\statistics_collector"

function build()
{
	python setup.py build --build-purelib $STATISTICS_COLLECTOR_DIR
}
