@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as Info-ZIP (http://www.info-zip.org).

setlocal

set AUXFILES=aux cmds glo hd idx ilg ind log lvt out tlg toc xref
set CLEAN=cls fc fmt gz ist ltx pdf sty zip
set CHECKCMDS=basics box calc clist doc expan file int intexpr io keys keyval msg names num precom prg prop quark seq skip tl token toks xref
set PACKAGE=expl3
set PATHCOPY=%PATH%
set PDF=expl3 l3calc source3
set PDFSETTINGS=\pdfminorversion=5  \pdfobjcompresslevel=2
set SCRIPTDIR=..\support
set TDSROOT=latex\%PACKAGE%
set TESTDIR=testfiles
set TEX=source3
set TXT=README
set UNPACK=l3.ins l3doc.dtx
set VALIDATE=..\validate
set XPACKAGEDIR=..\xpackages\
set XPACKAGES=xbase

:loop

  if /i [%1] == [alldoc]       goto :alldoc
  if /i [%1] == [check]        goto :check
  if /i [%1] == [checkcmd]     goto :checkcmd
  if /i [%1] == [checkcmds]    goto :checkcmds
  if /i [%1] == [checkdoc]     goto :checkdoc
  if /i [%1] == [checklvt]     goto :checklvt
  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [ctan]         goto :ctan
  if /i [%1] == [doc]          goto :doc
  if /i [%1] == [format]       goto :format
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [savetlg]      goto :savetlg
  if /i [%1] == [sourcedoc]    goto :sourcedoc
  if /i [%1] == [tds]          goto :tds
  if /i [%1] == [unpack]       goto :unpack

  goto :help

:alldoc

  call :sourcedoc
  
  for %%I in (l3*.dtx) do (
    call :doc-int %%~nI
  )
  
  goto :end

:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I

  if exist log2tlg del /q log2tlg
  if exist commands-check.tex del /q commands-check.tex
  if exist regression-test.tex del /q regression-test.tex

  goto :end

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

:checkcmd

  shift
  if [%1] == [] goto :help
  if not exist %1.dtx goto :no-dtx
  
  call :unpack

:checkcmd-int
  
  xcopy /q /y %VALIDATE%\commands-check.tex > nul
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
  
  goto :clean-int

:checkcmds

  call :unpack
  xcopy /q /y %VALIDATE%\commands-check.tex > nul

  for %%I in (%CHECKCMDS%) do (
    call :checkcmd-int l3%%I
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

  shift 
  if [%1] == [] goto :help
  if not exist %TESTDIR%\%1.lvt goto :no-lvt
  if not exist %TESTDIR%\%1.tlg goto :no-tlg

  call :perl
  call :unpack
  
  xcopy /q /y %SCRIPTDIR%\log2tlg > nul
  xcopy /q /y %VALIDATE%\regression-test.tex > nul
  
  xcopy /q /y %TESTDIR%\%1.lvt > nul
  xcopy /q /y %TESTDIR%\%1.tlg > nul
  
  if exist %1.fc  del /q %1.fc
  
  echo.
  echo Running checks on %1

  pdflatex %1.lvt > nul
  pdflatex %1.lvt > nul
  %PERLEXE% log2tlg %1 < %1.log > %1.new.log
  del /q %1.log > nul 
  ren %1.new.log %1.log > nul
  fc /n  %1.log %1.tlg > %1.fc
  
  for /f "skip=1 tokens=1" %%I in (%1.fc) do (
    if "%%I" == "FC:" (
      del /q %1.fc
    )
  )
  
  if exist %1.fc (
    echo   Checks fails
  ) else (
    echo   Check passed
  )
  
  if exist %1.pdf del /q %1.pdf
  
  goto :clean-int 

:ctan

  call :zip
  call :sourcedoc

  echo.
  echo Creating archive

  if exist temp\*.*  rmdir /q /s temp
  if exist tds\*.*   rmdir /q /s tds

  if exist *.cls (
    xcopy /q /y *.cls tds\tex\%TDSROOT%\       > nul
  )
  xcopy /q /y *.dtx temp\%PACKAGE%\            > nul
  xcopy /q /y *.dtx tds\source\%TDSROOT%\      > nul
  for %%I in (%PDF%) do (
    xcopy /q /y %%I.pdf temp\%PACKAGE%\        > nul
    xcopy /q /y %%I.pdf tds\doc\%TDSROOT%\     > nul
  )
  xcopy /q /y *.ins temp\%PACKAGE%\            > nul
  xcopy /q /y *.ins tds\source\%TDSROOT%\      > nul
  if exist *.ist (
    xcopy /q /y *.ist tds\makeindex\%PACKAGE%\ > nul
  )
  xcopy /q /y *.sty tds\tex\%TDSROOT%\         > nul
  for %%I in (%TEX%) do (
    xcopy /q /y %%I.tex temp\%PACKAGE%\        > nul
    xcopy /q /y %%I.tex tds\source\%TDSROOT%\  > nul
  )
  for %%I in (%TXT%) do (
    xcopy /q /y %%I.txt temp\%PACKAGE%\    > nul
    xcopy /q /y %%I.txt tds\doc\%TDSROOT%\ > nul
    ren temp\%PACKAGE%\%%I.txt    %%I
    ren tds\doc\%TDSROOT%\%%I.txt %%I
  )

  pushd tds
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  xcopy /q /y tds\%PACKAGE%.tds.zip temp\ > nul

  pushd temp
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.zip .
  popd
  xcopy /q /y temp\%PACKAGE%.zip > nul

  rmdir /q /s tds
  rmdir /q /s temp
  
  goto :end

:doc

  shift
  if [%1] == []       goto :help
  if not exist %1.dtx goto :no-dtx

  call :unpack

:doc-int
  
  echo.
  echo Typesetting %1
  
  pdflatex -interaction=nonstopmode -draftmode "%PDFSETTINGS% \input %1.dtx" > nul
  if not ERRORLEVEL 1 (
    makeindex -q -s l3doc.ist -o %2.ind %1.idx        > nul
    pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input %1.dtx" > nul
    pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input %1.dtx"  > nul
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

:format
  
  call :unpack

  for %%I in (%XPACKAGES%) do (
    copy %XPACKAGEDIR%\%%I\*.dtx > nul
  )

  echo. 
  echo Making format

  tex l3format.ins              > nul
  pdftex -etex -ini *latex3.ltx > nul
  
  goto :clean-int  

:help

  echo  make alldoc            - typeset all documentation
  echo  make check             - runs automated test suite 
  echo  make checklvt ^<name^>   - runs automated test on ^<name^> 
  echo  make checkcmd ^<name^>   - checks all functions are defined in ^<name^> 
  echo  make checkcmds         - checks all functions are defined in all modules 
  echo  make checkdoc          - checks all documentation compiles correctly
  echo  make clean             - delete all generated files
  echo  make ctan              - create an archive ready for CTAN
  echo  make doc ^<name^>        - typesets ^<name^>.dtx
  echo  make format            - create create lbase format file
  echo  make localinstall      - extract packages
  echo  make savetlg ^<name^>    - save test log for ^<name^>
  echo  make sourcedoc         - typeset expl3 and source3
  echo  make tds               - create a TDS-ready archive
  echo  make unpack            - extract packages
  
  goto :end

:localinstall

  call :unpack

  echo.
  echo Installing files

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
  )
  set INSTALLROOT=%TEXMFHOME%\tex\%TDSROOT%

  if exist "%INSTALLROOT%\*.*" rmdir /q /s "%INSTALLROOT%"

  if exist *.cls (
    xcopy /q /y *.cls "%INSTALLROOT%\" > nul
  )
  xcopy /q /y *.sty "%INSTALLROOT%\"   > nul

  xcopy /q /y l3doc.ist  "%TEXMFHOME%\makeindex\%PACKAGE%\" > nul

  goto :clean-int

:no-dtx
  
  echo.
  echo No such file %1.dtx

  goto :end
  
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
  xcopy /q /y %1.tlg %TESTDIR%\%1.tlg > nul
  
  goto :clean-int

:sourcedoc

  call :unpack

  echo.
  echo Typesetting source3

  pdflatex -interaction=nonstopmode -draftmode "\PassOptionsToClass{nocheck}{l3doc} %PDFSETTINGS% \input source3" > nul
  if not ERRORLEVEL 1 ( 
    echo   Re-typesetting for index generation
    makeindex -q -s l3doc.ist -o source3.ind source3.idx > nul
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} %PDFSETTINGS% \input source3" > nul
    echo   Re-typesetting to resolve cross-references
    pdflatex -interaction=nonstopmode "\PassOptionsToClass{nocheck}{l3doc} %PDFSETTINGS% \input source3" > nul
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
  
  pdflatex -interaction=nonstopmode -draftmode "%PDFSETTINGS% \input expl3.dtx" > nul
  if not ERRORLEVEL 1 (
    makeindex -q -s l3doc.ist -o expl3.ind expl3.idx > nul
    pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input expl3.dtx" > nul
    pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input expl3.dtx" > nul
  ) else (
    echo ! expl3 compilation failed
  )

  echo.
  echo Typesetting l3calc
  
  pdflatex -interaction=nonstopmode -draftmode "%PDFSETTINGS% \input l3calc.dtx" > nul
  if not ERRORLEVEL 1 (
    makeindex -q -s l3doc.ist -o l3calc.ind l3calc.idx > nul
    pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input l3calc.dtx" > nul
    pdflatex -interaction=nonstopmode "%PDFSETTINGS% \input l3calc.dtx" > nul
  ) else (
    echo ! l3calc compilation failed
  )


  goto :clean-int

:tds

  call :zip
  call :sourcedoc

  echo.
  echo Creating archive

  if exist tds\*.*  rmdir /q /s tds

  if exist *.cls (
    xcopy /q /y *.cls tds\tex\%TDSROOT%\       > nul
  )
  xcopy /q /y *.dtx tds\source\%TDSROOT%\      > nul
  for %%I in (%PDF%) do (
    xcopy /q /y %%I.pdf tds\doc\%TDSROOT%\     > nul
  )
  xcopy /q /y *.ins tds\source\%TDSROOT%\      > nul
  if exist *.ist (
    xcopy /q /y *.ist tds\makeindex\%PACKAGE%\ > nul
  )
  xcopy /q /y *.sty tds\tex\%TDSROOT%\         > nul
  for %%I in (%TEX%) do (
    xcopy /q /y %%I.tex tds\doc\%TDSROOT%\  > nul
  )
  for %%I in (%TXT%) do (
    xcopy /q /y %%I.txt tds\doc\%TDSROOT%\ > nul
    ren tds\doc\%TDSROOT%\%%I.txt %%I
  )

  pushd tds
  %ZIPEXE% %ZIPFLAG% %PACKAGE%.tds.zip .
  popd
  xcopy /q /y tds\%PACKAGE%.tds.zip > nul

  rmdir /q /s tds
  
  goto :end

:unpack

  echo.
  echo Unpacking files

  for %%I in (%UNPACK%) do (
    tex %%I > nul
  )

  goto :clean-int

:zip 

  set PATHCOPY=%PATH%

:zip-loop

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
    echo This procedure requires a zip program,
    echo but one could not be found.
    echo
    echo If you do have a command-line zip program installed,
    echo set ZIPEXE to the full executable path and ZIPFLAG to the
    echo appropriate flag to create an archive.
    echo.
  )

  goto :EOF

:end

  shift
  if not [%1] == [] goto :loop