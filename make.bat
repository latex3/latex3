@echo off

rem Makefile for LaTeX3 files

  if not [%1] == [] goto :init

:help

  echo.
  echo  make check        - runs the automated test suite
  echo  make clean        - clean out directory tree
  echo  make ctan         - create CTAN-ready archives
  echo  make localinstall - install files in local texmf tree
  echo  make unpack       - extract packages

  goto :EOF

:init

  rem Avoid clobbering anyone else's variables

  setlocal

  rem Safety precaution against awkward paths

  cd /d "%~dp0"

  rem Clean up settings

  set CLEAN=zip

  rem Bundles that are part of the overall LaTeX3 structure

  set BUNDLES=l3kernel l3packages l3experimental l3trial

:main

  rem Cross-compatibility with *nix
  
  if /i [%1] == [-s] shift

  if /i [%1] == [check]        goto check
  if /i [%1] == [clean]        goto clean
  if /i [%1] == [cleanall]     goto clean
  if /i [%1] == [ctan]         goto ctan
  if /i [%1] == [localinstall] goto localinstall
  if /i [%1] == [unpack]       goto unpack

  goto help

:check

  for %%I in (%BUNDLES%) do (
    pushd %%I
    call make check
    popd
  )

  goto end

:clean

  for %%I in (%BUNDLES%) do (
    pushd %%I
    call make clean
    popd
  )

  for %%I in (%CLEAN%) do (
    if exist *.%%I del /q *.%%I
  )

  goto end

:ctan

  call :clean
  call :localinstall

  for %%I in (%BUNDLES%) do (
    pushd %%I
    call make ctan
    popd
    copy /y "%%I\%%I.zip" . > nul
  )

  goto end

:localinstall

  for %%I in (%BUNDLES%) do (
    pushd %%I
    call make localinstall
    popd
  )

  goto end

:unpack

  for %%I in (%BUNDLES%) do (
    pushd %%I
    call make unpack
    popd
  )

  goto end

:end

  shift
  if not [%1] == [] goto main