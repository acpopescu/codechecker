# -------------------------------------------------------------------------
#
#  Part of the CodeChecker project, under the Apache License v2.0 with
#  LLVM Exceptions. See LICENSE for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# -------------------------------------------------------------------------
$CURRENT_DIR = Get-Location
$ROOT = $CURRENT_DIR

$BUILD_DIR = "$CURRENT_DIR\build"
$COMPILE_COMMANDS_DIR = "$BUILD_DIR\bazel"

function build()
{
	python setup.py build --build-purelib $COMPILE_COMMANDS_DIR
}

function clean()
{
	Remove-Item -Force -Recurse -ErrorAction Ignore $BUILD_DIR
	Remove-Item -Force -Recurse -ErrorAction Ignore .\bazel_compile_commands.egg-info
}
