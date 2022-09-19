# Set it to NO if you would not like to build the UI code.
$BUILD_UI_DIST = "$true"

$CURRENT_DIR = Get-Location
if ($null -eq $BUILD_DIR)
{
    $BUILD_DIR = "$CURRENT_DIR\build"
}


$CC_BUILD_DIR = "$BUILD_DIR\CodeChecker"
$CC_BUILD_WEB_DIR = "$CC_BUILD_DIR\www"
$CC_BUILD_PLUGIN_DIR = "$CC_BUILD_DIR\plugin"
$CC_BUILD_BIN_DIR = "$CC_BUILD_DIR\bin"
$CC_BUILD_LIB_DIR = "$CC_BUILD_DIR\lib\python3"
$CC_BUILD_SCRIPTS_DIR = "$CC_BUILD_WEB_DIR\scripts"
$CC_BUILD_API_DIR = "$CC_BUILD_SCRIPTS_DIR\codechecker-api"
$CC_BUILD_WEB_PLUGINS_DIR = "$CC_BUILD_SCRIPTS_DIR\plugins"
$CC_BUILD_GEN_DIR = "$CC_BUILD_LIB_DIR\codechecker_api"

$CC_SERVER = "$CURRENT_DIR\server\"
$CC_CLIENT = "$CURRENT_DIR\client\"

# Root of the repository.
$ROOT = "$CURRENT_DIR\.."

$CC_TOOLS = "$ROOT\tools"
$CC_WEB = "$ROOT\web"

$DIST_DIR = "$CC_SERVER\vue-cli\dist"
$LATEST_COMMIT_FILE = "$DIST_DIR\.build-commit"

# Get the latest commit in which the vue-cli directory was changed.
$LATEST_COMMIT = [string](git log -n 1 --pretty=format:%H $CC_SERVER\vue-cli)

# Get the latest build command from the dist directory.
$LATEST_BUILD_COMMIT = [string](cat ${LATEST_COMMIT_FILE} 2>dffd_garbage)

function package_dir_structure()
{
    mkdir -Force -Path  $BUILD_DIR 
	mkdir -Force -Path  $CC_BUILD_BIN_DIR 
	mkdir -Force -Path  $CC_BUILD_LIB_DIR

}
function clean_package_web()
{
    Remove-Item -Force -Recurse "$CC_SERVER\vue-cli\dist"
    Remove-Item -Force -Recurse "$CC_SERVER\vue-cli\node_modules"
}
function build_dist_dir()
{
    if($BUILD_UI_DIST)
    {
        Push-Location $CC_SERVER\vue-cli 
        npm install 
        npm run-script build 
        #echo $LATEST_COMMIT > $LATEST_COMMIT_FILE
        Pop-Location
    }
}

function package_report_converter()
{
    make_wrapper $null $CC_TOOLS\report-converter build
    cp -Force -Recurse -Path $CC_TOOLS\report-converter\build\report_converter\codechecker_report_converter $CC_BUILD_LIB_DIR 
	Push-Location $CC_BUILD_BIN_DIR 
	ln -sf ..\lib\python3\codechecker_report_converter\cli.py report-converter.py
    Pop-Location
}


function package_web()
{
	pip3 install ./api/py/codechecker_api/dist/codechecker_api.tar.gz
	pip3 install ./api/py/codechecker_api_shared/dist/codechecker_api_shared.tar.gz

	if ($BUILD_UI_DIST)  
	{
		Push-Location server\vue-cli 
		npm install 
		rm -Force -Recurse $DIST_DIR
		Pop-Location
	}		

    package_dir_structure
    # package_report_converter
    build_dist_dir

	if($BUILD_UI_DIST)
	{
        mkdir -Force -Path $CC_BUILD_WEB_DIR
	    cp -Force -Recurse $DIST_DIR\* $CC_BUILD_WEB_DIR
    }
}
