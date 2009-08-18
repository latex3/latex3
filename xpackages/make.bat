@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as Info-ZIP (http://www.info-zip.org).

setlocal

set CLEAN=zip
set CTAN=xbase
set PACKAGE=xpackages
set PATHCOPY=%PATH%
set TDSROOT=latex\%PACKAGE%
set TEMPLOG=%TEMP%\temp.log
set TEST=galley xbase xfootnote xfrontm xhead xor xtheorem
set TXT=readme-ctan
set XPACKAGES=galley xbase xcontents xfootnote xfrontm xhead xinitials xlang xor xtheorem

:loop

  if /i [%1] == [check]        goto :check
  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [ctan]         goto :ctan
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [tds]          goto :tds

  goto :help

:check
  
  for %%I in (%TEST%) do (
    echo.
    echo Testing %%I
    pushd %%I
    call make check clean
    popd
  )

  goto :end

:clean

  for %%I in (%XPACKACKAGES%) do (
    pushd %%I
    call make clean
    popd
  )

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

  goto :end

:ctan

  call :zip

  echo.
  echo Creating CTAN file
  echo.

  if exist temp\*.* rmdir /q /s temp
  if exist tds\*.*  rmdir /q /s tds

  for %%I in (%CTAN%) do (
    echo Typesetting
    pushd %%I
    call make unpack
    xcopy /q /y *.sty ..\tds\tex\%TDSROOT%\      > %TEMPLOG%
    call make doc
    xcopy /q /y *.dtx ..\temp\%PACKAGE%\         > %TEMPLOG%
    xcopy /q /y *.dtx ..\tds\source\%TDSROOT%\   > %TEMPLOG%
    xcopy /q /y *.ins ..\temp\%PACKAGE%\         > %TEMPLOG%
    xcopy /q /y *.ins ..\tds\source\%TDSROOT%\   > %TEMPLOG%
    xcopy /q /y *.pdf ..\temp\%PACKAGE%\         > %TEMPLOG%
    xcopy /q /y *.pdf ..\tds\doc\%TDSROOT%\      > %TEMPLOG%
    if exist *.tex (
      xcopy /q /y *.tex ..\temp\%PACKAGE%\       > %TEMPLOG%
      xcopy /q /y *.tex ..\tds\source\%TDSROOT%\ > %TEMPLOG%
    )
    call make clean
    popd
  )

  for %%I in (%TXT%) do (
    xcopy /q /y %%I.txt temp\%PACKAGE%\    > %TEMPLOG%
    xcopy /q /y %%I.txt tds\doc\%TDSROOT%\ > %TEMPLOG%
    ren temp\%PACKAGE%\%%I.txt    %%I
    ren tds\doc\%TDSROOT%\%%I.txt %%I
  )

  echo.
  echo Creating archive

  pushd tds
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  xcopy /q /y tds\%PACKAGE%.tds.zip temp\ > %TEMPLOG%

  pushd temp
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.zip .
  popd
  xcopy /q /y temp\%PACKAGE%.zip > %TEMPLOG%

  rmdir /q /s temp
  rmdir /q /s tds

  goto :end

:help

  echo.
  echo  make clean        - clean out all directories
  echo  make check        - set up and run all tests
  echo  make ctan         - create a zip file ready to go to CTAN
  echo  make localinstall - install the .sty files in your home texmf tree
  echo  make tds          - creates a TDS-ready zip of CTAN packages
  
  goto :end

:localinstall

  echo.
  echo Installing files

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
  )
  set INSTALLROOT=%TEXMFHOME%\%TDSROOT%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  for %%I in (%XPACKAGES%) do (
    echo   %%I
    pushd %%I
    call make unpack
    xcopy /q /y *.sty "%INSTALLROOT%\%%I\"   > %TEMPLOG% 
    if exist *.tex (
      xcopy /q /y *.tex "%INSTALLROOT%\%%I\" > %TEMPLOG%
    )
    call make clean
    popd
  )

  goto :end
  
:tds

  call :zip

  echo.
  echo Creating TDS file
  echo.

  if exist tds\*.*  rmdir /q /s tds

  for %%I in (%CTAN%) do (
    echo Typesetting
    pushd %%I
    call make unpack
    xcopy /q /y *.sty ..\tds\tex\%TDSROOT%\      > %TEMPLOG%
    call make doc
    xcopy /q /y *.dtx ..\tds\source\%TDSROOT%\   > %TEMPLOG%
    xcopy /q /y *.ins ..\tds\source\%TDSROOT%\   > %TEMPLOG%
    xcopy /q /y *.pdf ..\tds\doc\%TDSROOT%\      > %TEMPLOG%
    if exist *.tex (
      xcopy /q /y *.tex ..\tds\source\%TDSROOT%\ > %TEMPLOG%
    )
    call make clean
    popd
  )

  for %%I in (%TXT%) do (
    xcopy /q /y %%I.txt tds\doc\%TDSROOT%\ > %TEMPLOG%
    ren tds\doc\%TDSROOT%\%%I.txt %%I
  )

  echo.
  echo Creating archive

  pushd tds
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  xcopy /q /y tds\%PACKAGE%.tds.zip > %TEMPLOG%

  rmdir /q /s tds
  
  goto :end

:zip 

  set PATHCOPY=%PATH%

:zip-loop

  if defined ZIPEXE goto :EOF

  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist "%%I\zip.exe" (
      set ZIPEXE=zip
      set ZIPFLAG=-ll -q -r -X
    )
    set PATHCOPY=%%J;%%K
  )
  if not "%PATHCOPY%" == ";" goto :zip-loop
  
  if not defined ZIPEXE (
    echo.
    echo This procedure requires a zip program,
    echo but one could not be found.
    echo
    echo If you do have a command-line zip program installed,
    echo set ZIPEXE to the full executable path and ZIPFLAG to the
    echo appropriate flag to create an archive.
    echo.
  )

  goto :EOF

:end

  shift
  if not [%1] == [] goto :loop