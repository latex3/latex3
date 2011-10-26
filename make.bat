@echo off

rem Makefile for LaTeX3 files

  if not "%1" == "" goto :init

:help

  rem Default with no target is to give help

  echo.
  echo  make check        - runs the automated test suite
  echo  make clean        - clean out directory tree
  echo  make ctan         - create CTAN-ready archives
  echo  make localinstall - install files in local texmf tree

  goto :EOF

:init

  rem Avoid clobbering anyone else's variables

  setlocal
  
  set INCLUDE=l3kernel l3packages l3experimental

  cd /d "%~dp0"

:main

  if /i [%1] == [check]        goto :check
  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [cleanall]     goto :clean
  if /i [%1] == [ctan]         goto :ctan
  if /i [%1] == [localinstall] goto :localinstall

  goto :help
  
:check

  for %%I in (%INCLUDE%) do (
    pushd %%I
    call make check
    popd
  )

  goto :end
  
:clean

  for %%I in (%INCLUDE%) do (
    pushd %%I
    call make clean
    popd
  )

  goto :end
  
:ctan

  call :clean
  call :localinstall
  for %%I in (%INCLUDE%) do (
    pushd %%I
    call make ctan
    popd
    copy /q "%%I\%%I.zip" .
  )
  
  goto :end
  
:localinstall

  for %%I in (%INCLUDE%) do (
    pushd %%I
    call make localinstall
    popd
  )

  goto :end

:end

  shift
  if not "%1" == "" goto :main