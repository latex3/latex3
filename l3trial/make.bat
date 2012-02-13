@echo off

rem Makefile for LaTeX3 "l3trial" files

  if not [%1] == [] goto :init

:help

  rem Default with no target is to give help

  echo.
  echo  make check        - runs the automated test suite
  echo  make clean        - clean out directory tree
  each  make doc          - typeset documentation
  echo  make localinstall - install files in local texmf tree
  echo  make unpack       - extract packages

  goto :EOF

:init

  rem Avoid clobbering anyone else's variables

  setlocal

  set PACKAGES=l3benchmark l3file-extras l3fp-new l3hooks l3ldb l3rand l3trace

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
  
:ctan

  goto :end
  
:doc

  for %%I in (%PACKAGES%) do (
    pushd %%I
    call make doc
    popd
  )

  goto :end
  
:localinstall

  for %%I in (%PACKAGES%) do (
    pushd %%I
    call make localinstall
    popd
  )

  goto :end
  
:tds

  goto :end
  
:upack

  for %%I in (%PACKAGES%) do (
    pushd %%I
    call make unpack
    popd
  )

:end

  shift
  if not [%1] == [] goto :mai
