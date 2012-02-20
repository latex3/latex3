@echo off

rem Makefile for LaTeX3 "l3packages" files

  if not [%1] == [] goto init

:help

  echo.
  echo  make check        - run automated check system
  echo  make clean        - clean out directory
  echo  make ctan         - create an archive ready for CTAN
  echo  make doc          - typeset all dtx files
  echo  make localinstall - locally install package
  echo  make unpack       - extract modules

  goto :EOF

:init

  rem Avoid clobbering anyone else's variables and enable delayed expansion

  setlocal enabledelayedexpansion

  rem Safety precaution against awkward paths

  cd /d "%~dp0"

  rem The name of the bundle and the modules in it

  set BUNDLE=l3packages

  rem Automatically set the MODULES variable to all directories
  rem Needs delayed expansion (set above)

  set MODULES=
  for /d %%I in (*) do (
    set MODULES=!MODULES! %%I
  )

  rem Clean up settings

  set CLEAN=zip

  rem CTAN and TDS settings

  set CTANFILES=dtx ins pdf
  set MARKDOWN=README
  set TDSFILES=%CTANFILES% sty

:main

  if /i [%1] == [check]        goto check
  if /i [%1] == [clean]        goto clean
  if /i [%1] == [cleanall]     goto clean
  if /i [%1] == [ctan]         goto ctan
  if /i [%1] == [doc]          goto doc
  if /i [%1] == [localinstall] goto localinstall
  if /i [%1] == [unpack]       goto unpack

  goto help

:check

  for %%I in (%MODULES%) do (
    pushd %%I
    call make check
    popd
  )

  goto end

:clean

  for %%I in (%MODULES%) do (
    if exist %%I\make.bat (
      pushd %%I
      call make clean
      popd
    )
  )

  if exist ctan\nul rmdir /q /s ctan
  if exist tds\nul  rmdir /q /s tds

  for %%I in (%CLEAN%) do (
    if exist *.%%I del /q *.%%I
  )

  goto end

:ctan

  call :zip
  if ERRORLEVEL 1 goto :EOF

  if exist ctan\nul rmdir /q /s ctan
  if exist tds\nul  rmdir /q /s tds

  mkdir ctan\%BUNDLE%

  rem The following uses delayed evaluation twice (two loops); an alternative
  rem is a call-based method, but this keeps the code shorter

  for %%I in (%MODULES%) do (
    pushd %%I
    call make unpack doc
    for %%J in (%CTANFILES%) do (
      if exist *.%%J copy /y *.%%J ..\ctan\%BUNDLE%\ > nul
    )
    for %%J in (%TDSFILES%) do (
      call :file2tds %%J
      if exist *.%%J xcopy /q /y *.%%J ..\tds\!!TDSDIR!!\%%I\ > nul
    )
    popd
  )

  echo.
  echo Creating CTAN archive
  echo.

  set TDSDIR=doc\latex\%BUNDLE%

  for %%I in (%MARKDOWN%) do (
    copy /y %%I.markdown ctan\%BUNDLE%\ > nul
    copy /y %%I.markdown tds\%TDSDIR%\  > nul
    ren ctan\%BUNDLE%\%%I.markdown %%I
    ren tds\%TDSDIR%\%%I.markdown %%I
  )

  pushd tds
  %ZIPEXE% %ZIPFLAG% %BUNDLE%.tds.zip .
  popd
  copy /y tds\%BUNDLE%.tds.zip ctan\ > nul

  pushd ctan
  %ZIPEXE% %ZIPFLAG% %BUNDLE%.zip .
  popd
  copy /y ctan\%BUNDLE%.zip > nul

  rmdir /q /s ctan
  rmdir /q /s tds

  goto end

:doc

  for %%I in (%MODULES%) do (
    pushd %%I
    call make doc
    popd
  )

  goto end

:file2tds

  set TDSDIR=

  if /i "%1" == "def" set TDSDIR=tex\latex\%BUNDLE%
  if /i "%1" == "dtx" set TDSDIR=source\latex\%BUNDLE%
  if /i "%1" == "ins" set TDSDIR=source\latex\%BUNDLE%
  if /i "%1" == "pdf" set TDSDIR=doc\latex\%BUNDLE%
  if /i "%1" == "sty" set TDSDIR=tex\latex\%BUNDLE%
  if /i "%1" == "tex" set TDSDIR=doc\latex\%BUNDLE%
  if /i "%1" == "txt" set TDSDIR=doc\latex\%BUNDLE%

  goto :EOF

:localinstall

  for %%I in (%MODULES%) do (
    pushd %%I
    call make localinstall
    popd
  )

  goto end

:unpack

  for %%I in (%MODULES%) do (
    pushd %%I
    call make unpack
    popd
  )

  goto end

:zip

  set PATHCOPY=%PATH%

:zip-loop

  rem Search for INFO-Zip, or another similar tool

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
    echo This procedure requires a zip program, but one could not be found.
    echo
    echo If you do have a command-line zip program installed,
    echo set ZIPEXE to the full executable path and ZIPFLAG to the
    echo appropriate flag to create an archive.
    echo.
  )

  exit /b 1

  goto :EOF

:end

  shift
  if not [%1] == [] goto main