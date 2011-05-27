@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as Info-ZIP (http://www.info-zip.org).

setlocal

set CLEAN=zip
set CTAN= xhead
set PACKAGE=xpackages
set PATHCOPY=%PATH%
set TDSROOT=latex\%PACKAGE%
set TEST=xbase
set TXT=readme-ctan
set XPACKAGES=galley xcontents xfootnote xfrontm xinitials xlang xor xtheorem

:loop

  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [ctan]         goto :ctan
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [tds]          goto :tds
  if /i [%1] == [test]         goto :test

  goto :help

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
    xcopy /q /y *.sty ..\tds\tex\%TDSROOT%\%%I\      > nul
    call make doc
    xcopy /q /y *.dtx ..\temp\%PACKAGE%\             > nul
    xcopy /q /y *.dtx ..\tds\source\%TDSROOT%\%%I\   > nul
    xcopy /q /y *.ins ..\temp\%PACKAGE%\             > nul
    xcopy /q /y *.ins ..\tds\source\%TDSROOT%\%%I\   > nul
    xcopy /q /y *.pdf ..\temp\%PACKAGE%\             > nul
    xcopy /q /y *.pdf ..\tds\doc\%TDSROOT%\%%I\      > nul
    if exist *.tex (
      xcopy /q /y *.tex ..\temp\%PACKAGE%\           > nul
      xcopy /q /y *.tex ..\tds\source\%TDSROOT%\%%I\ > nul
    )
    call make clean
    popd
  )

  for %%I in (%TXT%) do (
    xcopy /q /y %%I.txt temp\%PACKAGE%\    > nul
    xcopy /q /y %%I.txt tds\doc\%TDSROOT%\ > nul
    ren temp\%PACKAGE%\%%I.txt    %%I
    ren tds\doc\%TDSROOT%\%%I.txt %%I
  )

  ren temp\%PACKAGE%\readme-ctan    README
  ren tds\doc\%TDSROOT%\readme-ctan README

  echo.
  echo Creating archive

  pushd tds
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  xcopy /q /y tds\%PACKAGE%.tds.zip temp\ > nul

  pushd temp
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.zip .
  popd
  xcopy /q /y temp\%PACKAGE%.zip > nul

  rmdir /q /s temp
  rmdir /q /s tds

  goto :end

:help

  echo.
  echo  make clean        - clean out all directories
  echo  make ctan         - create a zip file ready to go to CTAN
  echo  make localinstall - install the .sty files in your home texmf tree
  echo  make tds          - creates a TDS-ready zip of CTAN packages
  echo  make test         - set up and run all test documents
  
  goto :end

:localinstall

  echo.
  echo Installing files

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
  )
  set INSTALLROOT=%TEXMFHOME%\tex\%TDSROOT%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  for %%I in (%XPACKAGES%) do (
    echo   %%I
    pushd %%I
    call make unpack
    xcopy /q /y *.sty "%INSTALLROOT%\%%I\"   > nul 
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
    xcopy /q /y *.sty ..\tds\tex\%TDSROOT%\%%I\      > nul
    call make doc
    xcopy /q /y *.dtx ..\tds\source\%TDSROOT%\%%I\   > nul
    xcopy /q /y *.ins ..\tds\source\%TDSROOT%\%%I\   > nul
    xcopy /q /y *.pdf ..\tds\doc\%TDSROOT%\%%I\      > nul
    if exist *.tex (
      xcopy /q /y *.tex ..\tds\source\%TDSROOT%\%%I > nul
    )
    call make clean
    popd
  )

  for %%I in (%TXT%) do (
    xcopy /q /y %%I.txt tds\doc\%TDSROOT%\ > nul
    ren tds\doc\%TDSROOT%\%%I.txt %%I
  )

  ren tds\doc\%TDSROOT%\readme-ctan README

  echo.
  echo Creating archive

  pushd tds
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  xcopy /q /y tds\%PACKAGE%.tds.zip > nul

  rmdir /q /s tds
  
  goto :end

:test
  
  for %%I in (%TEST%) do (
    echo.
    echo Testing %%I
    pushd %%I
    call make test clean
    popd
  )

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