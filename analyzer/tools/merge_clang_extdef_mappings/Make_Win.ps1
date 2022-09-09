$CURRENT_DIR = Get-Location
$ROOT = $CURRENT_DIR

$BUILD_DIR = "$CURRENT_DIR\build"
$MERGE_CLANG_EXTDEF_MAPS_DIR = "$BUILD_DIR\merge_clang_extdef_mappings"

function build()
{
	python setup.py build --build-purelib $MERGE_CLANG_EXTDEF_MAPS_DIR
}

