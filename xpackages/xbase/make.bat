@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as Info-ZIP (http://www.info-zip.org).

setlocal

set AUXFILES=aux cmds glo hd idx ilg ind log out
set CLEAN=pdf sty
set EXPL3DIR=..\..\l3in2e
set TEMPLOG=%TEMP%\temp.log
set TEST=template-test template-test2 tprestrict-test xparse-test

:loop

  if /i [%1] == [all]    goto :all
  if /i [%1] == [check]  goto :check
  if /i [%1] == [clean]  goto :clean
  if /i [%1] == [doc]    goto :doc
  if /i [%1] == [unpack] goto :unpack

  goto :help

:all

  pushd %EXPL3DIR%
  call make unpack
  popd 
  xcopy /q /y %EXPL3DIR%\*.sty > %TEMPLOG%
  pushd %EXPL3DIR%
  call make clean
  popd

  goto :unpack

:check

  call :all

  for %%I in (%TEST%) do (
    echo   %%I
    pdflatex -interaction=batchmode %%I > %TEMPLOG%
    if not [%ERRORLEVEL%] == [0] (
      echo.
      echo **********************
      echo * Compilation failed *
      echo **********************
      echo.
    ) 
  )

  goto :end

:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I

  goto :end

:doc

  for %%I in (*.dtx) do (
    echo   %%I
    pdflatex -interaction=nonstopmode -draftmode %%~nI.dtx > %TEMPLOG%
    if not ERRORLEVEL 1 (
      if exist %%~nI.idx (
        makeindex -q -s l3doc.ist -o %%~nI.ind %%~nI.idx > %TEMPLOG%
      )
      pdflatex -interaction=nonstopmode %%I > %TEMPLOG%
      pdflatex -interaction=nonstopmode %%I > %TEMPLOG%
    )
  )

  goto :clean-int

:help

  echo.
  echo  make all    - extract modules plus expl3
  echo  make clean  - clean out directory
  echo  make check  - set up and run all test files
  echo  make doc    - typeset all dtx files
  echo  make test   - run all test files
  echo  make unpack - extract modules
  
  goto :end

:unpack

  for %%I in (*.ins) do (
    tex %%I > %TEMPLOG%
  )

  goto :end

:end

  shift
  if not [%1] == [] goto :loop