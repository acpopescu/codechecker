# NOTICE

This is an experimental fork of Code Checker, made to build on Windows and provide a conda package. Does not support building the compilation db, or build logging. 

This is provided as is and not suited for a production environment and it's WIP.

# How to build

1. Install miniconda (works with full anaconda, I really recommend to use miniconda and then environments to isolate needs per project or chaos ensues)
2. Install nodejs: choco install nodejs --version 16.17.0
3. Start a miniconda powershell

## To run locally and debug the build_dist directory
4. cd to source directory. You may need to remove the old one `conda env remove -n codechecker-build` if something fails
5. `conda env create`
6. `conda activate codechecker-build`
7. Source the make file `. .\Make_Win.ps1`
8. Build the sources: `make_pip_package` 
9. Run the codechecker DEV server `run_dev_servers_after_make`

## To build the conda package
4. Install conda-build : `conda install conda-build`
5. Build the conda package: `conda build .`. 
6. If you were in base now, you should have this path below. Note it.
`C:\Users\<USERNAME>\miniconda3\conda-bld\win-64\codechecker-6.20.0-py39_0.tar.bz2`
```
...
# To have conda build upload to anaconda.org automatically, use
# $ conda config --set anaconda_upload yes
anaconda upload ^

    C:\Users\<USERNAME>\miniconda3\conda-bld\win-64\codechecker-6.20.0-py39_0.tar.bz2

anaconda_upload is not set.  Not uploading wheels: []

INFO :: The inputs making up the hashes for the built packages are as follows:
{
  "codechecker-6.20.0-py39_0": {
    "recipe": {}
  }
}
```
7. Activate your environment - or - create a test environment `conda create -n codechecker-test` and then `conda activate codechecker-test`
8. Install the package created in your test environment. Copy the path until just before win64: `conda install codechecker -c file:///C:/Users/<USERNAME>/miniconda3/conda-bld/`
9. Conda should download and install all deps
10. Start the server with `CodeChecker server`. If you have an error regarding some pickles see known issues below - edit the configuration the server pushes to you `%USERPROFILE%/.codechecker` to force a single worker.


# Known issues

- No stopping on build error. Yep, didn't do the whole "stop on error", there is work to support that in the powershell scripts. 
- No multithreading server. The forking mechanism does not seem to work on Windows, multiprocessing can't pickle the local state. If you get the error edit `%USERPROFILE%/.codechecker/server_config.json`. Add a top level json entry `worker_processes : 1` to fix.
- No make test support, so no guarantee that the port works
- No build log support to create the compilation database
- Not really tested with a real compilation database YET
- Not tested with real LDAP access control.
- Broke the other platforms, not sorry. By all means use the original for the other platforms.
- 
# TODO
- `make_dev_package` work properly. Window's mklink will break if you remove the original file it points to, leading to the need to re-link the cmdline scripts
- merge to head
- address the known issues

# How it was done
Literally translating hand-makefiles into Windows Powershell scripts. Why? Because Conda is the de facto python for windows, period. No mingw shenaningans for me, and it would have taken me JUST as much to hack an environment around...