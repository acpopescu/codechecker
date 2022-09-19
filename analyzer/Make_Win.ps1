$CURRENT_DIR = Get-Location
if ( $null -eq $BUILD_DIR) 
{
    $BUILD_DIR =  "$CURRENT_DIR\build"
}
$CC_BUILD_DIR = "$BUILD_DIR\CodeChecker"
$CC_BUILD_BIN_DIR = "$CC_BUILD_DIR\bin"
$CC_BUILD_LIB_DIR = "$CC_BUILD_DIR\lib\python3"

# Root of the repository.
$ROOT = "$CURRENT_DIR\.."

$CC_TOOLS = "$ROOT\tools"
$CC_ANALYZER = "$ROOT\analyzer"


# Set it to YES if you would like to build and package 64 bit only shared
# objects and ldlogger binary.

function package_dir_structure()
{
	mkdir  -Force -Path $BUILD_DIR 
	mkdir  -Force -Path $CC_BUILD_BIN_DIR 
	mkdir  -Force -Path $CC_BUILD_LIB_DIR
}

function package_tu_collector()
{
    make_wrapper $null $ROOT\tools\tu_collector build
	# Copy tu_collector files.
	cp -Force -Recurse -Path  $CC_TOOLS\tu_collector\build\tu_collector\tu_collector $CC_BUILD_LIB_DIR 
	Push-Location $CC_BUILD_BIN_DIR 
	ln -sf ..\lib\python3\tu_collector\tu_collector.py tu_collector.py  
    Pop-Location
}

function package_merge_clang_extdef_mappings()
{
    make_wrapper $null $CC_ANALYZER\tools\merge_clang_extdef_mappings build
	# Copy files.
	cp -Force -Recurse  tools\merge_clang_extdef_mappings\build\merge_clang_extdef_mappings\codechecker_merge_clang_extdef_mappings $CC_BUILD_LIB_DIR 
    Push-Location $CC_BUILD_BIN_DIR 
	ln -sf ..\lib\python3\codechecker_merge_clang_extdef_mappings\cli.py merge-clang-extdef-mappings.py
    Pop-Location
}

function package_report_converter()
{    
	make_wrapper $null $CC_TOOLS\report-converter build
    cp -Force -Recurse -Path $CC_TOOLS\report-converter\build\report_converter\codechecker_report_converter $CC_BUILD_LIB_DIR 
	Push-Location $CC_BUILD_BIN_DIR 
	ln -sf ..\lib\python3\codechecker_report_converter\cli.py report-converter.py
    Pop-Location
}

function package_statistics_collector()
{
	make_wrapper $null $CC_ANALYZER\tools\statistics_collector build

    cp -Force -Recurse tools\statistics_collector\build\statistics_collector\codechecker_statistics_collector $CC_BUILD_LIB_DIR 
	Push-Location $CC_BUILD_BIN_DIR 
	ln -sf ..\lib\python3\codechecker_statistics_collector\cli.py post-process-stats.py
    Pop-Location
}

function package_bazel_compile_commands()
{
	make_wrapper $null $ROOT\tools\bazel build
	# Copy bazel_compile_commands files.
	cp -Force -Recurse -Path $CC_TOOLS\bazel\build\bazel\bazel_compile_commands $CC_BUILD_LIB_DIR 
	Push-Location $CC_BUILD_BIN_DIR 
	ln -sf ..\lib\python3\bazel_compile_commands\bazel_compile_commands.py bazel-compile-commands.py
    Pop-Location
}

function package_analyzer()
{
    package_dir_structure
    package_tu_collector
    package_merge_clang_extdef_mappings
    package_report_converter
    package_statistics_collector
    package_bazel_compile_commands
}
