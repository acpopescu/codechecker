function make_wrapper($builddir, $directory, $entry_function)
{
	Push-Location $directory
	$BUILD_DIR = $builddir
	. .\Make_Win.ps1
	& $entry_function
	Pop-Location
}

function ln([switch]$sf, $target, $link)
{
    Remove-Item -Force -ErrorAction Ignore $link
	cmd /c mklink $link $target
}