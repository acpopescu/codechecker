# NOTICE

This is an experimental fork of Code Checker, made to build on Windows and provide a conda package. Does not support building the compilation db, or build logging.

# How to build

1. Install miniconda
2. Install nodejs: choco install nodejs --version 16.17.0
3. Start a miniconda powershell
4. cd to source directory
5. `conda env create`
6. `conda activate codechecker-build`
7. Source the make file `. .\Make_Win.ps1`
8. Build the sources: `make_pip_package` 
9. Run the codechecker DEV server `run_dev_servers_after_make`
9. Build the conda package: `conda build .` I did not test if the server works with just the package :)


# Known issues

- No stopping on build error. Yep, didn't do the whole "stop on error", there is work to support that in the powershell scripts. 
- No multithreading server. the forking mechanism does not seem to work on Windows, multiprocessing can't pickle the local state
- No make test support, so no guarantee that the port works
- No build log support
- Not really tested with a real compilation database YET

# How it was done
Literally translating makefiles into Windows Powershell scripts.