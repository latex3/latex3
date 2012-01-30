@echo off

setlocal

set INSFILES=xotrace.ins

set AUXFILES=aux dvi fpl log lof lot toc
set CLEAN=pdf sty
set EXPL3DIR=..\..\l3in2e
set NEXT=end
set REVERT=xo-balance.pdf xo-pfloat.pdf template-doc.sty
set TEST=xo-pfloat
set XBASEDIR=..\xbase

:loop

  if /i "%1" == "all"    goto :all
  if /i "%1" == "check"  goto :check
  if /i "%1" == "clean"  goto :clean
  if /i "%1" == "doc"    goto :doc
  if /i "%1" == "test"   goto :test
  if /i "%1" == "unpack" goto :unpack

  goto :help
  
:all

  set NEXT=end

:all-int 
 
  pushd %EXPL3DIR%
  tex l3.ins > temp.log
  popd
  copy /y %EXPL3DIR%\*.sty > temp.log
  pushd %EXPL3DIR%
  del /q *.sty *.log
  popd
  
  pushd %XBASEDIR%
  tex xbase.ins > temp.log
  popd
  copy /y %XBASEDIR%\*.sty > temp.log
  pushd %XBASEDIR%
  del /q *.sty *.log
  popd

  goto :unpack-int

:check

  set NEXT=check-return
  goto :all-int
  
:check-return

  set NEXT=clean
  goto :test-int

:clean

  ren template-doc.sty template-doc.xxx > temp.log
  ren xo-balance.pdf xo-balance.xxx > temp.log
  ren xo-pfloat.pdf xo-pfloat.xxx > temp.log

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I
  
  ren template-doc.xxx template-doc.sty > temp.log
  ren xo-balance.xxx xo-balance.pdf > temp.log
  ren xo-pfloat.xxx xo-pfloat.pdf > temp.log

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I
  for %%I in (%REVERT%) do svn revert %%I
  
  if exist l3in2e.err del l3in2e.err
  
  goto :end
  
:doc

  for %%I in (*.dtx) do (
    echo   %%I
    pdflatex -interaction=nonstopmode %%I > temp.log
    if ERRORLEVEL 0 (
      pdflatex -interaction=nonstopmode %%I > temp.log
    )
  )

  goto :clean-int  
  
:help

  echo.
  echo. make all                - extract modules plus expl3
  echo  make clean              - clean out directory
  echo  make check              - set up and run all test files
  echo  make doc                - typeset all dtx files
  echo  make test               - run all test files
  echo  make unpack             - extract modules
  echo.
  echo  make help               - show this help text
  echo  make
  
  goto :end
  
:test

  set NEXT=clean-int

:test-int

  for %%I in (%TEST%) do (
    echo   %%I
    latex -interaction=batchmode %%I > temp.log
    if not ERRORLEVEL 0 (
      echo.
      echo **********************
      echo * Compilation failed *
      echo **********************
      echo.
    )
  )

  goto :%NEXT%  

:unpack  

  set NEXT=end

:unpack-int

  for %%I in (%INSFILES%) do (
    tex %%I > temp.log
  )
  
  del /q *.log

  goto :%NEXT%
  
:end

  shift
  if not "%1" == "" goto :loop
  
  endlocal