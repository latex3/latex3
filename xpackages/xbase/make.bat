@echo off

setlocal

set AUXFILES=aux cmds glo gls hd idx ilg ind log lvt out toc tlg xref
set CLEAN=pdf sty
set EXPL3DIR=..\..\l3in2e
set TEST=template-test template-test2 tprestrict-test xparse-test
set NEXT=end

:loop

  if /i [%1] == [all]    goto :all
  if /i [%1] == [check]  goto :check
  if /i [%1] == [clean]  goto :clean
  if /i [%1] == [doc]    goto :doc
  if /i [%1] == [test]   goto :test
  if /i [%1] == [unpack] goto :unpack

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

  goto :unpack-int

:check

  set NEXT=check-return
  goto :all-int
  
:check-return

  set NEXT=clean
  goto :test-int

:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I
      
  goto :end
  
:doc

  for %%I in (*.dtx) do (
    echo   %%I
    pdflatex -interaction=nonstopmode -draftmode %%~nI.dtx > temp.log
    if not ERRORLEVEL 1 (
      if exist %%~nI.idx (
        makeindex -q -s l3doc.ist -o %%~nI.ind %%~nI.idx > temp.log
      )
      pdflatex -interaction=nonstopmode %%I > temp.log
      pdflatex -interaction=nonstopmode %%I > temp.log
    )
  )

  goto :clean-int  
  
:help

  echo.
  echo  make all                - extract modules plus expl3
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
    pdflatex -interaction=batchmode %%I > temp.log
    if not %ERRORLEVEL%==0 (
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

  for %%I in (*.ins) do (
    tex %%I > temp.log
  )
  
  del /q *.log

  goto :%NEXT%
  
:end

  shift
  if not "%1" == "" goto :loop
  
  endlocal