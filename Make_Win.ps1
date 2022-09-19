
. .\Make_utils.ps1
$CURRENT_DIR = Get-Location
if ( $null -eq $BUILD_DIR) 
{
    $BUILD_DIR =  "$CURRENT_DIR\build_dist"
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
mkdir -Force -Path  $BUILD_DIR 
mkdir -Force -Path  $CC_BUILD_BIN_DIR 
mkdir -Force -Path  $CC_BUILD_LIB_DIR

cp -Force -Path scripts\gerrit_changed_files_to_skipfile.py $CC_BUILD_BIN_DIR

function make_dist()
{
	make_clean	
	make_pip_package	
}

function make_clean()
{
	make_wrapper $BUILD_DIR $CC_ANALYZER "clean_package_analyzer"
	make_wrapper $BUILD_DIR $CC_WEB "clean_package_web"
	
	Remove-Item -Recurse -Force -ErrorAction Ignore $BUILD_DIR
	Remove-Item -Recurse -Force -ErrorAction Ignore "$CURRENT_DIR\build"
	Remove-Item -Recurse -Force -ErrorAction Ignore "$CURRENT_DIR\build_dist"
}
function make_pip_package()
{	
	make_wrapper $BUILD_DIR $CC_ANALYZER "package_analyzer"
	make_wrapper $BUILD_DIR $CC_WEB "package_web"
	#
	#
    # Copy libraries.
	mkdir -Force -Path  $CC_BUILD_LIB_DIR\codechecker 
	cp -Force -Recurse $ROOT\codechecker_common $CC_BUILD_LIB_DIR 
	cp -Force -Recurse $CC_ANALYZER\codechecker_analyzer $CC_BUILD_LIB_DIR 
	cp -Force -Recurse $CC_WEB\codechecker_web $CC_BUILD_LIB_DIR 
	cp -Force -Recurse $CC_SERVER\codechecker_server $CC_BUILD_LIB_DIR 
	cp -Force -Recurse $CC_CLIENT\codechecker_client $CC_BUILD_LIB_DIR
	
	# Copy config files and extend 'version.json' file with git information.
	cp -Force -Recurse $ROOT\config $CC_BUILD_DIR 
	cp -Force -Recurse $CC_ANALYZER\config\* $CC_BUILD_DIR\config 
	cp -Force -Recurse $CC_WEB\config\* $CC_BUILD_DIR\config 
	cp -Force -Recurse $CC_SERVER\config\* $CC_BUILD_DIR\config 
		
	python .\scripts\build\extend_version_file.py -r $ROOT $CC_BUILD_DIR\config\analyzer_version.json $CC_BUILD_DIR\config\web_version.json

	python .\scripts\build\create_commands.py -b $BUILD_DIR `
	  --cmd-dir $ROOT\codechecker_common\cmd `
	    $CC_WEB\codechecker_web\cmd `
	    $CC_SERVER\codechecker_server\cmd `
	    $CC_CLIENT\codechecker_client\cmd `
	    $CC_ANALYZER\codechecker_analyzer\cmd `
	  --bin-file $ROOT\bin\CodeChecker

	# Copy license file.
	cp -Force -Recurse $ROOT\LICENSE.TXT $CC_BUILD_DIR
}

function make_pip_dev_package()
{
    make_pip_package
    rm  -Force -Recurse -ErrorAction Ignore  $CC_BUILD_LIB_DIR\codechecker_common 
	rm  -Force -Recurse -ErrorAction Ignore  $CC_BUILD_LIB_DIR\codechecker_analyzer 
	rm  -Force -Recurse -ErrorAction Ignore  $CC_BUILD_LIB_DIR\codechecker_web 
	rm  -Force -Recurse -ErrorAction Ignore  $CC_BUILD_LIB_DIR\codechecker_server 
	rm  -Force -Recurse -ErrorAction Ignore  $CC_BUILD_LIB_DIR\codechecker_report_converter 
	rm  -Force -Recurse -ErrorAction Ignore  $CC_BUILD_LIB_DIR\codechecker_client

	ln  $ROOT\codechecker_common $CC_BUILD_LIB_DIR 
	ln  $CC_ANALYZER\codechecker_analyzer $CC_BUILD_LIB_DIR 
	ln  $CC_WEB\codechecker_web $CC_BUILD_LIB_DIR 
	ln  $CC_SERVER\codechecker_server $CC_BUILD_LIB_DIR 
	ln  $CC_TOOLS\report-converter\codechecker_report_converter $CC_BUILD_LIB_DIR 
	ln  $CC_CLIENT\codechecker_client $CC_BUILD_LIB_DIR
}

function run_dev_servers_after_make()
{
	pip3 install $CC_WEB\api\py\codechecker_api\dist\codechecker_api.tar.gz
	pip3 install $CC_WEB\api\py\codechecker_api_shared\dist\codechecker_api_shared.tar.gz
	Push-Location $CC_BUILD_BIN_DIR
	invoke-expression 'cmd /c start powershell -Command { python .\CodeChecker server --verbose debug }'
	Pop-Location
}


