@echo off

setlocal

set AUXFILES=aux dvi log toc
set CLEAN=cls pdf sty
set EXPL3DIR=..\..\l3in2e
set NEXT=end
set XBASEDIR=..\xbase
set XORDIR=..\xor

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
  
  pushd %XORDIR%
  tex xo.ins > temp.log
  popd
  copy /y %XORDIR%\*.sty > temp.log
  pushd %XORDIR%
  ren template-doc.sty template-doc.xxx > temp.log
  del /q *.sty *.log
  ren template-doc.xxx template-doc.sty > temp.log
  popd

  goto :unpack-int

:check

  set NEXT=check-return
  goto :all-int
  
:check-return

  set NEXT=clean
  goto :test-int

:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I
  
  if exist xfmgalley-sample.tex del /q xfmgalley-sample.tex 

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
  
  echo   xfm-test userinput=1
  latex -interaction=batchmode "\def\userinput{1}\input{xfm-test.tex}" > temp.log
  echo   xfm-test userinput=2
  latex -interaction=batchmode "\def\userinput{2}\input{xfm-test.tex}" > temp.log
  rem echo   xfm-test userinput=3
  rem latex -interaction=batchmode "\def\userinput{3}\input{xfm-test.tex}" broken!
  echo   xfm-test userinput=4
  latex -interaction=batchmode "\def\userinput{4}\input{xfm-test.tex}" > temp.log
  echo   xfm-test userinput=5
  latex -interaction=batchmode "\def\userinput{5}\input{xfm-test.tex}" > temp.log

  goto :%NEXT%  

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