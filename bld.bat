echo Building Package
Powershell.exe -ExecutionPolicy ByPass -C ". .\Make_Win.ps1; make_dist"
"%PYTHON%" setup.py install
popd