@echo off

rem Makefile for LaTeX3 "l3experimental" files

  if not [%1] == [] goto :init

:help

  rem Default with no target is to give help

  echo.
  echo  make check        - runs the automated test suite
  echo  make clean        - clean out directory tree
  echo  make ctan         - create an archive ready for CTAN
  each  make doc          - typeset documentation
  echo  make localinstall - install files in local texmf tree
  echo  make tds          - 
  echo  make unpack       - extract packages

  goto :EOF

:init

  rem Avoid clobbering anyone else's variables

  setlocal

  set CLEAN=zip
  set PACKAGE=l3package
  set PACKAGES=l3str xcoffins xgalley
  set TDSROOT=latex\%PACKAGE%
  set TXT=README

  cd /d "%~dp0"

:main

  if /i [%1] == [check]        goto :check
  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [cleanall]     goto :clean
  if /i [%1] == [ctan]         goto :ctan
  if /i [%1] == [doc]          goto :doc
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [tds]          goto :tds
  if /i [%1] == [unpack]       goto :unpack

  goto :help
  
:check

  for %%I in (%PACKAGES%) do (
    pushd %%I
    call make check
    popd
  )

  goto :end
  
:clean

  for %%I in (%PACKAGES%) do (
    pushd %%I
    call make clean
    popd
  )

  goto :end
  
  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:ctan

  call :zip

  echo.
  echo Creating CTAN file
  echo.

  if exist temp\*.* rmdir /q /s temp
  if exist tds\*.*  rmdir /q /s tds

  for %%I in (%PACKAGES%) do (
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
    xcopy /q /y %%I.markdown temp\%PACKAGE%\    > nul
    xcopy /q /y %%I.markdown tds\doc\%TDSROOT%\ > nul
    ren temp\%PACKAGE%\%%I.markdown    %%I
    ren tds\doc\%TDSROOT%\%%I.markdown %%I
  )

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

:doc

  for %%I in (%PACKAGES%) do (
    pushd %%I
    call make doc
    popd
  )

  goto :end

:localinstall

  echo.
  echo Installing files

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
  )
  set INSTALLROOT=%TEXMFHOME%\tex\%TDSROOT%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  for %%I in (%PACKAGES%) do (
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

  for %%I in (%PACKAGES%) do (
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
    xcopy /q /y %%I.markdown tds\doc\%TDSROOT%\ > nul
    ren tds\doc\%TDSROOT%\%%I.markdown %%I
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