$CURRENT_DIR = Get-Location
$ROOT = $CURRENT_DIR

$BUILD_DIR = "$CURRENT_DIR\build"
$MERGE_CLANG_EXTDEF_MAPS_DIR = "$BUILD_DIR\merge_clang_extdef_mappings"

function build()
{
	python setup.py build --build-purelib $MERGE_CLANG_EXTDEF_MAPS_DIR
}

function clean()
{
	Remove-Item -Force -Recurse -ErrorAction Ignore $BUILD_DIR
	Remove-Item -Force -Recurse -ErrorAction Ignore .\dist
	Remove-Item -Force -Recurse -ErrorAction Ignore .\merge_clang_extdef_mappings.egg-info
}

