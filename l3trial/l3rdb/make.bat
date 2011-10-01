@echo off

setlocal

set AUXFILES=aux dvi log sig toc
set CLEAN=pdf sty
set EXPL3DIR=..\..\l3in2e
set NEXT=end
set XBASEDIR=..\xbase

:loop

  if /i "%1" == "all"    goto :all
  if /i "%1" == "clean"  goto :clean
  if /i "%1" == "doc"    goto :doc
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


:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I
  
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
  echo  make doc                - typeset all dtx files
  echo  make unpack             - extract modules
  echo.
  echo  make help               - show this help text
  echo  make
  
  goto :end
  
:unpack  

  set NEXT=end

:unpack-int

  for %%I in (*.ins) do (
    tex %%I > temp.log
  )
  
  del /q *.log

  goto :%NEXT%
  
:end

  shift
  if not "%1" == "" goto :loop
  
  endlocal