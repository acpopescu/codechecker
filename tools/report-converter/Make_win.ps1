# -------------------------------------------------------------------------
#
#  Part of the CodeChecker project, under the Apache License v2.0 with
#  LLVM Exceptions. See LICENSE for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# -------------------------------------------------------------------------
$CODEMIRROR = "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.30.0"

$CURRENT_DIR = Get-Location
$ROOT = $CURRENT_DIR

$BUILD_DIR = "$CURRENT_DIR\build"
$REPORT_CONVERTER_DIR = "$BUILD_DIR\report_converter"

$STATIC_DIR = "$CURRENT_DIR\codechecker_report_converter\report\output\html\static"
$VENDOR_DIR = "$STATIC_DIR\vendor"
$CODEMIRROR_DIR = "$VENDOR_DIR\codemirror"

function build()
{
	mkdir -Force -Path  $VENDOR_DIR
	mkdir -Force -Path  $CODEMIRROR_DIR
    curl -UseBasicParsing -Uri $CODEMIRROR/codemirror.min.js -OutFile  $CODEMIRROR_DIR\codemirror.min.js
	curl -UseBasicParsing -Uri $CODEMIRROR/codemirror.min.css -OutFile  $CODEMIRROR_DIR\codemirror.min.css 
    curl -UseBasicParsing  -Uri https://raw.githubusercontent.com/codemirror/CodeMirror/master/LICENSE -OutFile  $CODEMIRROR_DIR\codemirror.LICENSE 
	curl -UseBasicParsing  -Uri   $CODEMIRROR/mode/clike/clike.min.js -OutFile  $CODEMIRROR_DIR\clike.min.js 

    python setup.py build --build-purelib  $REPORT_CONVERTER_DIR
}

function clean()
{
	Remove-Item -Force -Recurse -ErrorAction Ignore $BUILD_DIR
	Remove-Item -Force -Recurse -ErrorAction Ignore .\report_converter.egg-info
}