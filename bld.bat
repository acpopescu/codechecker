echo Building Package
Powershell.exe -ExecutionPolicy ByPass -C ". .\Make_Win.ps1; make_dist"
"%PYTHON%" setup.py install
rem Clearing errorlevel as it requires build system refactor
cmd /c "exit /b 0"
exit 0