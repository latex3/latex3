@echo off

rem Makefile for LaTeX3 "l3kernel" files

  if not [%1] == [] goto init

:help

  echo.
  echo  make check [show]      - run the automated tests
  echo  make checkcmd ^<name^>   - checks all functions are defined in ^<name^>
  echo  make checkcmds         - checks all functions are defined in all modules
  echo  make checkdoc          - checks all documentation compiles correctly
  echo  make checklvt ^<name^>   - runs the automated tests for ^<name^>
  echo  make checktest         - checks test file coverage for all modules
  echo  make clean             - delete all generated files
  echo  make ctan              - create an archive ready for CTAN
  echo  make doc [show] ^<name^> - typesets ^<name^>.dtx
  echo  make format [^<engine^>] - creates a format file for ^<engine^>
  echo  make localinstall      - extract packages
  echo  make savetlg ^<name^>    - save test log for ^<name^>
  echo  make sourcedoc [show]  - typeset expl3 and source3
  echo  make test ^<name^>       - checks test file coverage for ^<name^>.dtx
  echo  make unpack [show]     - extract files

  goto :EOF

:init

  rem Avoid clobbering anyone else's variables

  setlocal

  rem Safety precaution against awkward paths

  cd /d "%~dp0"

  rem The name of the bundle

  set BUNDLE=l3kernel

  rem Unpacking information

  set UNPACK=l3.ins

  rem Clean up settings

  set AUXFILES=aux bbl blg cmds dvi glo gls hd idx ilg ind ist log lvt los out tlg tmp toc
  set CLEAN=bib bst cls def fc fmt gz ltx orig pdf sty zip

  rem Check system set up

  set CHECKDIR=testfiles
  set CHECKEXE=pdflatex
  set CHECKRUNS=2
  set CHECKUNPACK=%UNPACK%

  rem Locations for the various support items required

  set MAINDIR=..
  set SCRIPTDIR=%MAINDIR%\support
  set VALIDATE=%MAINDIR%\validate

  rem Set up redirection of output

  set REDIRECT=^> nul
  if not [%2] == [] (
    if /i [%2] == [show] (
      set REDIRECT=
    )
  )

  set CTANFILES=dtx ins pdf
  set CTANROOT=ctan
  set ENGINE=pdftex
  set MARKDOWN=README
  set INCLUDEPDF=expl3 interface3 l3docstrip l3styleguide l3syntax-changes source3
  set TDSFILES=%CTANFILES% cls def sty
  set TDSROOT=tds

  set CTANDIR=%CTANROOT%\%BUNDLE%

:main

  rem Cross-compatibility with *nix
  
  if /i [%1] == [-s] shift

  if /i [%1] == [check]        goto check
  if /i [%1] == [checkcmd]     goto checkcmd
  if /i [%1] == [checkcmds]    goto checkcmds
  if /i [%1] == [checkdoc]     goto checkdoc
  if /i [%1] == [checklvt]     goto checklvt
  if /i [%1] == [checktest]    goto checktest
  if /i [%1] == [clean]        goto clean
  if /i [%1] == [cleanall]     goto clean
  if /i [%1] == [ctan]         goto ctan
  if /i [%1] == [doc]          goto doc
  if /i [%1] == [help]         goto help
  if /i [%1] == [format]       goto format
  if /i [%1] == [localinstall] goto localinstall
  if /i [%1] == [savetlg]      goto savetlg
  if /i [%1] == [sourcedoc]    goto sourcedoc
  if /i [%1] == [test]         goto test
  if /i [%1] == [unpack]       goto unpack

  goto help

:check

  call :check-aux-1

  for %%I in (%CHECKDIR%\*.lvt) do (
    if exist %CHECKDIR%\%%~nI.tlg (
      copy /y %CHECKDIR%\%%~nI.lvt > nul
      copy /y %CHECKDIR%\%%~nI.tlg > nul
    )
  )

  echo.
  echo Running checks on

  for %%I in (m3*.tlg) do (
    echo   %%~nI
    call :check-aux-2 %%~nI
  )
  
  echo   d3dvipdfmx
  latex d3dvipdfmx.lvt %REDIRECT%
  call :check-aux-3 d3dvipdfmx
  echo   d3dvips
  latex d3dvips.lvt %REDIRECT%
  call :check-aux-3 d3dvips
  echo   d3pdfmode
  pdflatex d3pdfmode.lvt %REDIRECT%
  call :check-aux-3 d3pdfmode
  echo   d3xdvipdfmx
  xelatex d3xdvipdfmx.lvt %REDIRECT%
  call :check-aux-3 d3xdvipdfmx

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

  goto clean-int

:check-aux-1

  if not exist %CHECKDIR%\nul goto end

  rem Check for Perl, and give up if it is not found

  call :perl
  if ERRORLEVEL 1 goto :EOF

  rem Unpack, allowing for using a 'trace' version or similar

  for %%I in (%CHECKUNPACK%) do (
    tex %%I > nul
  )

  rem Remove any old files, and copy the test system into place

  for %%I in (fc lvt tlg) do (
    if exist *.%%I del /q *.%%I
  )

  copy /y %SCRIPTDIR%\log2tlg > nul
  for %%I in (regression-test.tex) do (
    copy /y %VALIDATE%\%%I > nul
  )
  copy /y %CHECKDIR%\driver.tex > nul

  goto :EOF

:check-aux-2

  for /l %%I in (1,1,%CHECKRUNS%) do (
      %CHECKEXE% %1.lvt %REDIRECT%
  )
    
  call :check-aux-3 %1

  goto :EOF
  
:check-aux-3

  %PERLEXE% log2tlg %1 < %1.log > %1.new.log
  del /q %1.log > nul
  ren %1.new.log %~n1.log > nul
  fc /n  %1.log %~n1.tlg > %1.fc

  goto :EOF

:checkcmd

  shift
  if [%1] == [] goto help
  if not exist %1.dtx goto no-dtx

  call :unpack

:checkcmd-int

  copy /y %VALIDATE%\commands-check.tex > nul
  if exist missing.cmds.log del /q missing.cmds.log

  echo.
  echo Checking commands in %1

  pdflatex -interaction=batchmode "\PassOptionsToClass{check}{l3doc} \input %1.dtx" > nul
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

  goto clean-int

:checkcmds

  call :unpack

  copy /y %VALIDATE%\commands-check.tex > nul

  for %%I in (l3*.dtx) do (
    call :checkcmd-int %%I
  )

  goto clean-int

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

  shift

  call :check-aux-1

  if exist %CHECKDIR%\%~n1.lvt (
    if exist %CHECKDIR%\%~n1.tlg (
      copy /y %CHECKDIR%\%~n1.lvt > nul
      copy /y %CHECKDIR%\%~n1.tlg > nul
    ) else (
      goto clean-int
    )
  ) else (
    goto clean-int
  )

  echo.
  echo Running checks on %~n1

  call :check-aux-2 %~n1

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

  goto clean-int

:checktest

  call :unpack

  echo.
  echo Checking functions have tests

  for %%I in (l3*.dtx) do  (
    echo   %%~nI
    pdflatex --interaction=batchmode "\PassOptionsToClass{checktest}{l3doc} \input %%I"
  )

  goto clean-int

:clean

  echo.
  echo Deleting files

  for %%I in (%CLEAN%) do (
    if exist *.%%I del /q *.%%I
  )
  if exist l3docstrip.tex del /q l3docstrip.tex

:clean-int

  for %%I in (%AUXFILES%) do (
    if exist *.%%I del /q *.%%I
  )

  for %%I in (log2tlg commands-check.tex driver.tex regression-test.tex) do (
    if exist %%I del /q %%I
  )

  goto end

:ctan

  call :zip
  if ERRORLEVEL 1 goto end

  call :tds
  if ERRORLEVEL 1 goto end

  echo.
  echo Remember to:
  echo  - make cleanall
  echo  - make check
  echo  - make sourcedoc
  echo  - Update the file date for expl3.dtx
  echo before updating CTAN!
  echo.

  for %%I in (%INCLUDEPDF%) do (
    xcopy /q /y %%I.pdf "%CTANDIR%\" > nul
  )
  for %%I in (%CTANFILES%) do (
    xcopy /q /y *.%%I "%CTANDIR%\" > nul
  )
  for %%I in (%MARKDOWN%) do (
    xcopy /q /y %%I.markdown "%CTANDIR%\" > nul
    ren "%CTANDIR%\%%I.markdown" %%I
  )

  xcopy /q /y %BUNDLE%.tds.zip "%CTANROOT%\" > nul

  pushd "%CTANROOT%"
  %ZIPEXE% %ZIPFLAG% %BUNDLE%.zip .
  popd
  copy /y "%CTANROOT%\%BUNDLE%.zip" > nul

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

  if /i "%~x1" == ".cls" set TDSDIR=tex\latex\%BUNDLE%
  if /i "%~x1" == ".def" set TDSDIR=tex\latex\%BUNDLE%
  if /i "%~x1" == ".dtx" set TDSDIR=source\latex\%BUNDLE%
  if /i "%~x1" == ".ins" set TDSDIR=source\latex\%BUNDLE%
  if /i "%~x1" == ".pdf" set TDSDIR=doc\latex\%BUNDLE%
  if /i "%~x1" == ".sty" set TDSDIR=tex\latex\%BUNDLE%
  if /i "%~x1" == ".tex" set TDSDIR=doc\latex\%BUNDLE%
  if /i "%~x1" == ".txt" set TDSDIR=doc\latex\%BUNDLE%

  if /i "%~x1" == ".markdown" set TDSDIR=doc\latex\%BUNDLE%

  goto :end

:format

  echo.
  echo Making format

  shift
  if not [%1] == [] set ENGINE=%1

  tex l3format.ins > nul
  %ENGINE% -etex -ini "l3format.ltx"

  goto :end

:localinstall

  call :unpack

  echo.
  echo Installing %MODULE%

  if not defined TEXMFHOME (
    for /f "delims=" %%I in ('kpsewhich --var-value=TEXMFHOME') do @set TEXMFHOME=%%I
    if [%TEXMFHOME%] == [] (
      set TEXMFHOME=%USERPROFILE%\texmf
    )
  )
  set INSTALLROOT=%TEXMFHOME%\tex\latex\%BUNDLE%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  if exist *.cls (
    xcopy /q /y *.cls "%INSTALLROOT%\" > nul
  )
  xcopy /q /y *.def "%INSTALLROOT%\"   > nul
  xcopy /q /y *.sty "%INSTALLROOT%\"   > nul
  
  xcopy /q /y l3docstrip.tex "%INSTALLROOT%\" > nul

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

  exit /b 1

  goto :EOF

:savetlg

  shift

  call :check-aux-1

  if exist %CHECKDIR%\%~n1.lvt (
    copy /y %CHECKDIR%\%~n1.lvt > nul
  ) else (
    goto no-lvt
  )

  echo.
  echo Creating and copying %1.tlg

  for /l %%I in (1,1,%CHECKRUNS%) do (
      %CHECKEXE% %1.lvt %REDIRECT%
    )
  %PERLEXE% log2tlg %1 < %1.log > %1.tlg

  copy /y %1.tlg %CHECKDIR%\%1.tlg > nul

  goto :clean-int

:sourcedoc

  call :unpack

  echo.
  echo Typesetting expl3

  pdflatex -interaction=nonstopmode -draftmode "\input expl3.dtx" %REDIRECT%
  if not ERRORLEVEL 1 (
    makeindex -q -s l3doc.ist -o expl3.ind expl3.idx > nul
    pdflatex -interaction=nonstopmode "\input expl3.dtx" %REDIRECT%
    pdflatex -interaction=nonstopmode "\input expl3.dtx" %REDIRECT%
  ) else (
    echo ! expl3 compilation failed
  )

  echo.
  echo Typesetting l3styleguide

  pdflatex -interaction=nonstopmode -draftmode l3styleguide %REDIRECT%
  if not ERRORLEVEL 1 (
    pdflatex -interaction=nonstopmode l3styleguide %REDIRECT%
  ) else (
    echo ! l3styleguide compilation failed
  )

  echo.
  echo Typesetting l3syntax-changes

  pdflatex -interaction=nonstopmode -draftmode l3syntax-changes %REDIRECT%
  if not ERRORLEVEL 1 (
    pdflatex -interaction=nonstopmode l3syntax-changes %REDIRECT%
  ) else (
    echo ! l3syntax-changes compilation failed
  )

  echo.
  echo Typesetting l3docstrip

  pdflatex -interaction=nonstopmode -draftmode l3docstrip.dtx %REDIRECT%
  if not ERRORLEVEL 1 (
    pdflatex -interaction=nonstopmode l3docstrip.dtx %REDIRECT%
  ) else (
    echo ! l3docstrip compilation failed
  )

  echo.
  echo Typesetting source3

  pdflatex -interaction=nonstopmode -draftmode "\PassOptionsToClass{nocheck}{l3doc} \input source3" %REDIRECT%
  if not ERRORLEVEL 1 (
    echo   Re-typesetting for index generation
    makeindex -q -s l3doc.ist -o source3.ind source3.idx > nul
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} \input source3" %REDIRECT%
    echo   Re-typesetting to resolve cross-references
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} \input source3" %REDIRECT%
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
  echo Typesetting interface3

  pdflatex -interaction=nonstopmode -draftmode "\PassOptionsToClass{nocheck}{l3doc} \input interface3" %REDIRECT%
  if not ERRORLEVEL 1 (
    echo   Re-typesetting for index generation
    makeindex -q -s l3doc.ist -o interface3.ind interface3.idx > nul
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} \input interface3" %REDIRECT%
    echo   Re-typesetting to resolve cross-references
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} \input interface3" %REDIRECT%
    for /F "tokens=*" %%I in (interface3.log) do (
      if "%%I" == "Functions documented but not defined:" (
        echo ! Warning: some functions not defined
      )
      if "%%I" == "Functions defined but not documented:" (
        echo ! Warning: some functions not documented
      )
    )
  ) else (
    echo ! interface3 compilation failed
  )

  goto :clean-int

:tds

  call :zip
  if errorlevel 1 goto :EOF

  call :sourcedoc
  if errorlevel 1 goto :EOF

  echo.
  echo Creating archive

  for %%I in (%INCLUDEPDF%) do (
    call :tds-int %%I.pdf
  )
  for %%I in (%TDSFILES%) do (
    call :tds-int *.%%I
  )
  xcopy /q /y l3docstrip.tex "%TDSROOT%\tex\latex\%BUNDLE%\" > nul
  for %%I in (%MARKDOWN%) do (
    copy /y %%I.markdown "%TDSROOT%\doc\latex\%BUNDLE%\" > nul
    ren "%TDSROOT%\doc\latex\%BUNDLE%\%%I.markdown" %%I
  )

  pushd "%TDSROOT%"
  %ZIPEXE% %ZIPFLAG% %BUNDLE%.tds.zip .
  popd
  copy /y "%TDSROOT%\%BUNDLE%.tds.zip" > nul

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
    tex %%I %REDIRECT%
  )

  goto :end

:zip

  set PATHCOPY=%PATH%

:zip-loop

  rem Search for INFO-Zip, or another similar tool

  if defined ZIPEXE goto :EOF

  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist "%%I\zip.exe" (
      set ZIPEXE=zip
      set ZIPFLAG=-ll -q -r -X
    )
    set PATHCOPY=%%J;%%K
  )
  if not "%PATHCOPY%" == ";" goto :zip-loop

  if not defined ZIPEXE (
    echo.
    echo This procedure requires a zip program, but one could not be found.
    echo
    echo If you do have a command-line zip program installed,
    echo set ZIPEXE to the full executable path and ZIPFLAG to the
    echo appropriate flag to create an archive.
    echo.
  )

  exit /b 1

  goto :EOF

:end

  rem If something like "make check show" was used, remove the "show"

  if /i [%2] == [show] shift

  shift
  if not [%1] == [] goto :main