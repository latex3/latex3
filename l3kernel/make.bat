@echo off

rem Makefile for LaTeX3 "expl3" files

  if not "%1" == "" goto :init

:help

  rem Default with no target is to give help

  echo.
  echo  make check           - run the automated tests
  echo  make checkcmd ^<name^> - checks all functions are defined in ^<name^> 
  echo  make checkcmds       - checks all functions are defined in all modules
  echo  make checkdoc        - checks all documentation compiles correctly
  echo  make checklvt ^<name^> - runs the automated tests for ^<name^>
  echo  make checktest       - checks test file coverage for all modules
  echo  make clean           - delete all generated files
  echo  make ctan            - create an archive ready for CTAN
  echo  make doc ^<name^>      - typesets ^<name^>.dtx
  echo  make format          - create a format file using pdfTeX
  echo  make format ^<engine^> - creates a format file using ^<engine^>
  echo  make localinstall    - extract packages
  echo  make savetlg ^<name^>  - save test log for ^<name^>
  echo  make sourcedoc       - typeset expl3 and source3
  echo  make test ^<name^>     - checks test file coverage for ^<name^>.dtx
  echo  make tds             - create a TDS-ready archive
  echo  make unpack          - extract files

  goto :end

:init

  rem Avoid clobbering anyone else's variables
  
  setlocal
  
  set AUXFILES=aux bbl blg cmds dvi glo gls hd idx ilg ind ist log lvt los out tlg tmp toc
  set CLEAN=bib bst cls fc fmt gz ltx orig pdf sty zip
  set CTANFILES=dtx ins pdf
  set CTANROOT=ctan
  set ENGINE=pdftex
  set INCLUDETXT=README
  set INCLUDEPDF=expl3 source3
  set PACKAGE=l3kernel
  set TDSFILES=%CTANFILES% cls sty
  set TDSROOT=tds
  set TESTDIR=testfiles
  set SUPPORTDIR=..\support
  set UNPACK=l3.ins
  set VALIDATE=..\validate
  
  set CTANDIR=%CTANROOT%\%PACKAGE%

  cd /d "%~dp0"

:main

  if /i "%1" == "check"        goto :check
  if /i "%1" == "checkcmd"     goto :checkcmd
  if /i "%1" == "checkcmds"    goto :checkcmds
  if /i "%1" == "checkdoc"     goto :checkdoc
  if /i "%1" == "checklvt"     goto :checklvt
  if /i "%1" == "checktest"    goto :checktest
  if /i "%1" == "clean"        goto :clean
  if /i "%1" == "cleanall"     goto :clean
  if /i "%1" == "ctan"         goto :ctan
  if /i "%1" == "doc"          goto :doc
  if /i "%1" == "help"         goto :help
  if /i "%1" == "format"       goto :format
  if /i "%1" == "localinstall" goto :localinstall
  if /i "%1" == "savetlg"      goto :savetlg
  if /i "%1" == "sourcedoc"    goto :sourcedoc
  if /i "%1" == "test"         goto :test
  if /i "%1" == "tds"          goto :tds
  if /i "%1" == "unpack"       goto :unpack

  goto :help
  
:check

  call :unpack
  call :perl

  copy /y %SUPPORTDIR%\log2tlg           > nul
  copy /y %VALIDATE%\regression-test.tex > nul

  if exist *.fc  del /q *.fc
  if exist *.lvt del /q *.lvt
  if exist *.tlg del /q *.tlg
  for %%I in (%TESTDIR%\*.tlg) do (
    if exist %TESTDIR%\%%~nI.lvt (
      copy /y %TESTDIR%\%%~nI.lvt > nul
      copy /y %TESTDIR%\%%~nI.tlg > nul
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
  
:checkcmd

  shift
  if [%1] == [] goto :help
  if not exist %1.dtx goto :no-dtx
  
  call :unpack

:checkcmd-int
  
  copy /y %VALIDATE%\commands-check.tex > nul
  if exist missing.cmds.log del /q missing.cmds.log
  
  echo.
  echo Checking commands in %1
  
  pdflatex -interaction=batchmode %1.dtx > nul
  pdflatex -interaction=batchmode "\def\CMDS{%1.cmds}\input commands-check" > cmds.log
  for /F "tokens=1*" %%I in (cmds.log) do (
    if "%%I"=="!>" copy /y cmds.log missing.cmds.log > nul
  )
  if exist missing.cmds.log (
    echo   Missing commands:
    for /F "tokens=1*" %%I in (missing.cmds.log) do (
      if "%%I"=="!>" echo   - %%J 
    )
  ) 
  goto :end
  goto :clean-int

:checkcmds

  call :unpack
  copy /y %VALIDATE%\commands-check.tex > nul

  for %%I in (l3*.dtx) do (
    call :checkcmd-int %%I
  )

  goto :clean-int
  
:checkdoc

  call :unpack
  
  echo.
  echo Checking documentation of functions

  for %%I in (l3*.dtx) do (
    echo   %%~nI
    pdflatex -interaction=nonstopmode -draftmode %%I > nul
    if  not ERRORLEVEL 1 (
      for /F "tokens=*" %%J in (%%~nI.log) do (
        if "%%J" == "Functions documented but not defined:" (
          echo     Some functions not defined
        )
        if "%%J" == "Functions defined but not documented:" (
          echo     Some functions not documented
        )
      )
    ) else (
      echo     Compilation failed
    )
  )  

  goto :clean-int 
  
:checklvt

  call :unpack
  call :perl

  copy /y %SUPPORTDIR%\log2tlg           > nul
  copy /y %VALIDATE%\regression-test.tex > nul

  shift

  if exist %~n1.fc  del /q %~n1.fc
  if exist %~n1.lvt del /q %~n1.lvt
  if exist %~n1.tlg del /q %~n1.tlg
  if exist %TESTDIR%\%~n1.lvt (
    copy /y %TESTDIR%\%~n1.lvt > nul
    copy /y %TESTDIR%\%~n1.tlg > nul
  )
  
  echo.
  echo Running checks on %~n1
  
  pdflatex %~n1.lvt > nul
  pdflatex %~n1.lvt > nul
  %PERLEXE% log2tlg %~n1 < %~n1.log > %~n1.new.log 
  del /q %~n1.log > nul
  ren %~n1.new.log %~n1.log > nul
  fc /n  %~n1.log %~n1.tlg > %~n1.fc
  
  for %%I in (*.fc) do (
    for /f "skip=1 tokens=1" %%J in (%%~nI.fc) do (
      if "%%J" == "FC:" (
        del /q %%I
      )
    )
  )
  
  if exist %~n1.fc (
    echo   Check fails 
  ) else (
    echo   Check passes
  )
  
  if exist %~n1.pdf del /q %~n1.pdf
  
  goto :clean-int


:checktest

  call :unpack
  
  
  echo.
  echo Checking functions have tests
  
  for %%I in (l3*.dtx) do  (
    echo   %%~nI
    pdflatex --interaction=batchmode "\PassOptionsToClass{checktest}{l3doc} \input %%I"
  )

  goto :clean-int

:clean

  echo.
  echo Deleting files

  for %%I in (%CLEAN%) do (
    if exist *.%%I del /q *.%%I
  )

  for %%I in (%TXT% l3generic.tex regression-test.tex) do (
    if exist %%I del /q %%I
  )

:clean-int

  for %%I in (%AUXFILES%) do (
    if exist *.%%I del /q *.%%I
  )

  if exist log2tlg del /q log2tlg
  if exist commands-check.tex del /q commands-check.tex
  if exist regression-test.tex del /q regression-test.tex

  goto :end

:ctan

  call :zip
  if errorlevel 1 goto :end

  call :tds
  if errorlevel 1 goto :end

  for %%I in (%INCLUDEPDF%) do (
    xcopy /q /y %%I.pdf "%CTANDIR%\" > nul
  )  
  for %%I in (%CTANFILES%) do (
    xcopy /q /y *.%%I "%CTANDIR%\" > nul
  )
  for %%I in (%INCLUDETXT%) do (
    xcopy /q /y %%I.markdown "%CTANDIR%\" > nul
    ren "%CTANDIR%\%%I.markdown" %%I
  )

  xcopy /q /y %PACKAGE%.tds.zip "%CTANROOT%\" > nul

  pushd "%CTANROOT%"
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.zip .
  popd
  copy /y "%CTANROOT%\%PACKAGE%.zip" > nul

  rmdir /s /q %CTANROOT%

  goto :end

:doc

  shift
  if [%1] == []       goto :help
  if not exist %1.dtx goto :no-dtx

  call :unpack

:doc-int
  
  echo.
  echo Typesetting %1
  
  pdflatex -interaction=nonstopmode -draftmode "\input %1.dtx" > nul
  if not ERRORLEVEL 1 (
    makeindex -q -s l3doc.ist -o %2.ind %1.idx        > nul
    pdflatex -interaction=nonstopmode "\input %1.dtx" > nul
    pdflatex -interaction=nonstopmode "\input %1.dtx"  > nul
    for /F "tokens=*" %%I in (%1.log) do (
      if "%%I" == "Functions documented but not defined:" (
      echo ! Some functions not defined 
      )
      if "%%I" == "Functions defined but not documented:" (
      echo ! Some functions not documented 
      )
    )
  ) else (
    echo ! %1 compilation failed
  )
  
  goto :clean-int

:file2tdsdir

  set TDSDIR=

  if /i "%~x1" == ".cls" set TDSDIR=tex\latex\%PACKAGE%
  if /i "%~x1" == ".dtx" set TDSDIR=source\latex\%PACKAGE%
  if /i "%~x1" == ".ins" set TDSDIR=source\latex\%PACKAGE%
  if /i "%~x1" == ".pdf" set TDSDIR=doc\latex\%PACKAGE%
  if /i "%~x1" == ".sty" set TDSDIR=tex\latex\%PACKAGE%
  if /i "%~x1" == ".tex" set TDSDIR=doc\latex\%PACKAGE%
  if /i "%~x1" == ".txt" set TDSDIR=doc\latex\%PACKAGE%
  
  if /i "%~x1" == ".markdown" set TDSDIR=doc\latex\%PACKAGE%

  goto :end

:format

  echo. 
  echo Making format
  
  shift
  if not "%1" == "" set ENGINE=%1

  tex l3format.ins > nul
  %ENGINE% -etex -ini "*l3format.ltx"

  goto :end
  
:localinstall

  call :unpack

  echo.
  echo Installing files

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
  )
  set INSTALLROOT=%TEXMFHOME%\tex\latex\%PACKAGE%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  if exist *.cls (
    xcopy /q /y *.cls "%INSTALLROOT%\" > nul
  )
  xcopy /q /y *.sty "%INSTALLROOT%\"   > nul

  goto :clean-int

:no-lvt
  
  echo.
  echo No such file %1.lvt

  goto :end
  
:no-tlg
  
  echo.
  echo No such file %1.tlg

  goto :end

:perl 

  set PATHCOPY=%PATH%

:perl-loop

  if defined PERLEXE goto :end
  
  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist %%I\perl.exe set PERLEXE=perl
    set PATHCOPY=%%J;%%K
  )
  
  if defined PERLEXE goto :end

  if not "%PATHCOPY%"==";" goto :perl-loop
  
  echo.
  echo  This procedure requires Perl, but it could not be found.
  
  goto :end

:savetlg

  shift
  if [%1] == [] goto :help
  if not exist %TESTDIR%\%1.lvt goto :no-lvt

  call :perl
  call :unpack
 
  copy /y %SUPPORTDIR%\log2tlg > nul
  copy /y %VALIDATE%\regression-test.tex > nul
  copy /y %TESTDIR%\%1.lvt > nul
  
  echo.
  echo Creating and copying %1.tlg
  
  pdflatex %1.lvt > nul 
  pdflatex %1.lvt > nul
  %PERLEXE% log2tlg %1 < %1.log > %1.tlg
  copy /y %1.tlg %TESTDIR%\%1.tlg > nul
  
  goto :clean-int
  
:sourcedoc

  call :unpack

  echo.
  echo Typesetting source3

  pdflatex -interaction=nonstopmode -draftmode "\PassOptionsToClass{nocheck}{l3doc} \input source3" > nul
  if not ERRORLEVEL 1 ( 
    echo   Re-typesetting for index generation
    makeindex -q -s l3doc.ist -o source3.ind source3.idx > nul
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} \input source3" > nul
    echo   Re-typesetting to resolve cross-references
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} \input source3" > nul
    for /F "tokens=*" %%I in (source3.log) do (           
      if "%%I" == "Functions documented but not defined:" (   
        echo ! Warning: some functions not defined              
      )                                  
      if "%%I" == "Functions defined but not documented:" ( 
        echo ! Warning: some functions not documented      
      )                                                        
    )
  ) else (
    echo ! source3 compilation failed  
  )

  echo.
  echo Typesetting expl3
  
  pdflatex -interaction=nonstopmode -draftmode "\input expl3.dtx" > nul
  if not ERRORLEVEL 1 (
    makeindex -q -s l3doc.ist -o expl3.ind expl3.idx > nul
    pdflatex -interaction=nonstopmode "\input expl3.dtx" > nul
    pdflatex -interaction=nonstopmode "\input expl3.dtx" > nul
  ) else (
    echo ! expl3 compilation failed
  )
  
  goto :clean-int

:tds

  call :zip
  if errorlevel 1 goto :end

  call :sourcedoc
  if errorlevel 1 goto :end

  echo.
  echo Creating archive

  for %%I in (%INCLUDEPDF%) do (
    call :tds-int %%I.pdf
  )
  for %%I in (%TDSFILES%) do (
    call :tds-int *.%%I
  )
  for %%I in (%INCLUDETXT%) do (
    copy /y %%I.markdown "%TDSROOT%\doc\latex\%PACKAGE%\" > nul
    ren "%TDSROOT%\doc\latex\%PACKAGE%\%%I.markdown" %%I
  )

  pushd "%TDSROOT%"
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  copy /y "%TDSROOT%\%PACKAGE%.tds.zip" > nul

  rmdir /s /q "%TDSROOT%"

  goto :end

:tds-int

  call :file2tdsdir %1

  if defined TDSDIR (
    xcopy /q /y %1 "%TDSROOT%\%TDSDIR%\" > nul
  ) else (
    echo Unknown file type "%~x1"
  )

  goto :end

:unpack

  echo.
  echo Unpacking files

  for %%I in (%UNPACK%) do (
    tex %%I > nul
  )

  goto :end

:zip 

  if not defined ZIPFLAG set ZIPFLAG=-r -q -X -ll

  if defined ZIPEXE goto :end

  for %%I in (zip.exe "%~dp0zip.exe") do (
    if not defined ZIPEXE if exist %%I set ZIPEXE=%%I
  )

  for %%I in (zip.exe) do (
    if not defined ZIPEXE set ZIPEXE="%%~$PATH:I"
  )

  if not defined ZIPEXE (
    echo.
    echo This procedure requires a zip program,
    echo but one could not be found.
    echo
    echo If you do have a command-line zip program installed,
    echo set ZIPEXE to the full executable path and ZIPFLAG to the
    echo appropriate flag to create an archive.
    echo.
  )

  goto :end

:end

  shift
  if not "%1" == "" goto :main