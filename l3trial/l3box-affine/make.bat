@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as Info-ZIP (http://www.info-zip.org).

setlocal

set AUXFILES=aux cmds glo hd idx ilg ind log lvt tlg toc out
set CLEAN=fc gz pdf sty
set EXPL3DIR=..\..\l3kernel
set PACKAGE=l3box-affine
set PDFSETTINGS=\pdfminorversion=5  \pdfobjcompresslevel=2 \AtBeginDocument{\DisableImplementation}
set TDSROOT=latex\l3trial\%PACKAGE%

:loop

  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [doc]          goto :doc
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [unpack]       goto :unpack

  goto :help

:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I

  if exist log2tlg del /q log2tlg
  if exist regression-test.tex del /q regression-test.tex

  goto :end

:doc

  for %%I in (*.dtx) do (
    echo   %%I
    pdflatex -interaction=nonstopmode -draftmode "%PDFSETTINGS% \input %%I" > nul
    if not ERRORLEVEL 1 (
      if exist %%~nI.idx (
        makeindex -q -s l3doc.ist -o %%~nI.ind %%~nI.idx > nul
      )
      pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input %%I" > nul
      pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input %%I" > nul
    )
  )

  goto :clean-int

:help

  echo.
  echo  make clean        - clean out directory
  echo  make doc          - typeset all dtx files
  echo  make localinstall - locally install packages
  echo  make unpack       - extract modules
  
  goto :end

:localinstall

  echo.
  echo Installing files

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
  )
  set INSTALLROOT=%TEXMFHOME%\tex\%TDSROOT%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  call make unpack
  xcopy /q /y *.sty "%INSTALLROOT%\"   > nul 
  call make clean

  goto :end

:unpack

  for %%I in (*.ins) do (
    tex %%I > nul
  )

  goto :end

:end

  shift
  if not [%1] == [] goto :loop