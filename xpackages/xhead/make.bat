@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as Info-ZIP (http://www.info-zip.org).

setlocal

set AUXFILES=aux cmds glo hd idx ilg ind log lvt tlg toc out
set CLEAN=fc gz pdf sty
set EXPL3DIR=..\..\l3in2e
set PACKAGE=xhead
set PDFSETTINGS=\pdfminorversion=5  \pdfobjcompresslevel=2 \AtBeginDocument{\DisableImplementation}
set SCRIPTDIR=..\..\support
set TEST=xhead-test
set TESTDIR=testfiles
set TDSROOT=latex\xpackages\%PACKAGE%
set VALIDATE=..\..\validate

:loop

  if /i [%1] == [all]          goto :all
  if /i [%1] == [check]        goto :check
  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [doc]          goto :doc
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [savetlg]      goto :savetlg
  if /i [%1] == [test]         goto :test
  if /i [%1] == [unpack]       goto :unpack

  goto :help

:all

  pushd %EXPL3DIR%
  call make unpack
  popd 
  xcopy /q /y %EXPL3DIR%\*.sty > nul
  pushd %EXPL3DIR%
  call make clean
  popd

  goto :unpack


:check

  call :unpack
  call :perl
  
  xcopy /q /y %SCRIPTDIR%\log2tlg            > nul
  xcopy /q /y %VALIDATE%\regression-test.tex > nul
  
  if exist *.fc  del /q *.fc
  if exist *.lvt del /q *.lvt
  if exist *.tlg del /q *.tlg
  for %%I in (%TESTDIR%\*.tlg) do (
    if exist %TESTDIR%\%%~nI.lvt (
      xcopy /q /y %TESTDIR%\%%~nI.lvt > nul
      xcopy /q /y %TESTDIR%\%%~nI.tlg > nul
    )
  )
  
  echo.
  echo Running checks on
  
  for %%I in (*.tlg) do (
    echo   %%~nI
    pdflatex %%~nI.lvt > nul
    pdflatex %%~nI.lvt > nul
    %PERLEXE% log2tlg %%~nI < %%~nI.log > %%~nI.new.log 
    del /q %%~nI.log > nul
    ren %%~nI.new.log %%~nI.log > nul
    fc /n  %%~nI.log %%~nI.tlg > %%~nI.fc
  )
  
  for %%I in (*.fc) do (
    for /f "skip=1 tokens=1" %%J in (%%~nI.fc) do (
      if "%%J" == "FC:" (
        del /q %%I
      )
    )
  )
  
  echo.
  if exist *.fc (
    echo   Checks fails for
    for %%I in (*.fc) do (
      echo   - %%~nI
    ) 
  ) else (
    echo   All checks passed
  )
  
  for %%I in (*.tlg) do (
    if exist %%~nI.pdf del /q %%~nI.pdf
  )
  
  goto :clean-int

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
  echo  make all          - extract modules plus expl3
  echo  make clean        - clean out directory
  echo  make check        - run automated check system
  echo  make doc          - typeset all dtx files
  echo  make localinstall - locally install packages
  echo  make savetlg ^<name^> - save test log for ^<name^>
  echo  make test         - run test doucments
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

:perl 

  set PATHCOPY=%PATH%

:perl-loop

  if defined PERLEXE goto :EOF
  
  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist %%I\perl.exe set PERLEXE=perl
    set PATHCOPY=%%J;%%K
  )
  
  if defined PERLEXE goto :EOF

  if not "%PATHCOPY%"==";" goto :perl-loop
  
  if exist %SYSTEMROOT%\Perl\bin\perl.exe set PERLEXE=%SYSTEMROOT%\Perl\bin\perl
  if exist %ProgramFiles%\Perl\bin\perl.exe set PERLEXE=%ProgramFiles%\Perl\bin\perl
  if exist %SYSTEMROOT%\strawberry\Perl\bin\perl.exe set PERLEXE=%SYSTEMROOT%\strawberry\Perl\bin\perl
  
  if defined PERL goto :EOF
  
  echo.
  echo  This procedure requires Perl, but it could not be found.
  
  goto :EOF

:savetlg

  shift
  if [%1] == [] goto :help
  if not exist %TESTDIR%\%1.lvt goto :no-lvt

  call :perl
  call :unpack
 
  xcopy /q /y %SCRIPTDIR%\log2tlg > nul
  xcopy /q /y %VALIDATE%\regression-test.tex > nul
  xcopy /q /y %TESTDIR%\%1.lvt > nul
  
  echo.
  echo Creating and copying %1.tlg
  
  pdflatex %1.lvt > nul
  pdflatex %1.lvt > nul
  %PERLEXE% log2tlg %1 < %1.log > %1.tlg
  copy /y %1.tlg %TESTDIR%\%1.tlg > nul
  
  goto :clean-int

:test

  call :all

  for %%I in (%TEST%) do (
    echo   %%I
    pdflatex -interaction=batchmode %%I > nul
    if not [%ERRORLEVEL%] == [0] (
      echo.
      echo **********************
      echo * Compilation failed *
      echo **********************
      echo.
    ) 
  )

  goto :end

:unpack

  for %%I in (*.ins) do (
    tex %%I > nul
  )

  goto :end

:end

  shift
  if not [%1] == [] goto :loop