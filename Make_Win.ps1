
. .\Make_utils.ps1
$CURRENT_DIR = Get-Location
if ( $null -eq $BUILD_DIR) 
{
    $BUILD_DIR =  "$CURRENT_DIR\build"
}

$CC_BUILD_DIR = "$BUILD_DIR\CodeChecker"
$CC_BUILD_BIN_DIR = "$CC_BUILD_DIR\bin"
$CC_BUILD_WEB_DIR = "$CC_BUILD_DIR\www"
$CC_BUILD_LIB_DIR = "$CC_BUILD_DIR\lib\python3"

$CC_WEB = "$CURRENT_DIR\web"
$CC_SERVER = "$CC_WEB\server\"
$CC_CLIENT = "$CC_WEB\client\"
$CC_ANALYZER = "$CURRENT_DIR\analyzer"
$CC_COMMON = "$CURRENT_DIR\codechecker_common"

$CC_TOOLS = "$CURRENT_DIR\tools"
$CC_ANALYZER_TOOLS = "$CC_ANALYZER\tools"

# Root of the repository.
$ROOT = "$CURRENT_DIR"

# Set it to YES if you would like to build and package 64 bit only shared
# objects and ldlogger binary.


# Package
mkdir -p $BUILD_DIR 
mkdir -p $CC_BUILD_BIN_DIR 
mkdir -p $CC_BUILD_LIB_DIR

cp -Path scripts\gerrit_changed_files_to_skipfile.py $CC_BUILD_BIN_DIR

function make_pip_package()
{
	make_wrapper $BUILD_DIR $CC_ANALYZER "package_analyzer"
	return
	make_wrapper $BUILD_DIR $CC_WEB "package_web"

	
    # Copy libraries.
	mkdir -p $CC_BUILD_LIB_DIR\codechecker 
	cp -r $ROOT\codechecker_common $CC_BUILD_LIB_DIR 
	cp -r $CC_ANALYZER\codechecker_analyzer $CC_BUILD_LIB_DIR 
	cp -r $CC_WEB\codechecker_web $CC_BUILD_LIB_DIR 
	cp -r $CC_SERVER\codechecker_server $CC_BUILD_LIB_DIR 
	cp -r $CC_CLIENT\codechecker_client $CC_BUILD_LIB_DIR

	# Copy config files and extend 'version.json' file with git information.
	cp -r $ROOT\config $CC_BUILD_DIR 
	cp -r $CC_ANALYZER\config\* $CC_BUILD_DIR\config 
	cp -r $CC_WEB\config\* $CC_BUILD_DIR\config 
	cp -r $CC_SERVER\config\* $CC_BUILD_DIR\config 
	python .\scripts\build\extend_version_file.py -r $ROOT `
	$CC_BUILD_DIR\config\analyzer_version.json `
	$CC_BUILD_DIR\config\web_version.json

	python .\scripts\build\create_commands.py -b $BUILD_DIR `
	  --cmd-dir $ROOT\codechecker_common\cmd `
	    $CC_WEB\codechecker_web\cmd `
	    $CC_SERVER\codechecker_server\cmd `
	    $CC_CLIENT\codechecker_client\cmd `
	    $CC_ANALYZER\codechecker_analyzer\cmd `
	  --bin-file $ROOT\bin\CodeChecker

	# Copy license file.
	cp $ROOT\LICENSE.TXT $CC_BUILD_DIR
}

function make_pip_dev_package()
{
    make_pip_package
    rm -rf $CC_BUILD_LIB_DIR\codechecker_common 
	rm -rf $CC_BUILD_LIB_DIR\codechecker_analyzer 
	rm -rf $CC_BUILD_LIB_DIR\codechecker_web 
	rm -rf $CC_BUILD_LIB_DIR\codechecker_server 
	rm -rf $CC_BUILD_LIB_DIR\codechecker_report_converter 
	rm -rf $CC_BUILD_LIB_DIR\codechecker_client

	ln -fsv $ROOT\codechecker_common $CC_BUILD_LIB_DIR 
	ln -fsv $CC_ANALYZER\codechecker_analyzer $CC_BUILD_LIB_DIR 
	ln -fsv $CC_WEB\codechecker_web $CC_BUILD_LIB_DIR 
	ln -fsv $CC_SERVER\codechecker_server $CC_BUILD_LIB_DIR 
	ln -fsv $CC_TOOLS\report-converter\codechecker_report_converter $CC_BUILD_LIB_DIR 
	ln -fsv $CC_CLIENT\codechecker_client $CC_BUILD_LIB_DIR
}


