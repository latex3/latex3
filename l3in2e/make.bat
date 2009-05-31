@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here. Some of the options provided here 
rem require Perl (http://www.perl.org) or a zip program such as 7-Zip
rem (http://www.7zip.org).

setlocal

set AUXFILES=aux cmds glo gls hd idx ilg ind log lvt out toc tlg  xref
set CHECKCMDS=basics box calc clist doc expan file int intexpr io keyval msg names num precom prg prop quark seq skip tl token toks xref
set CLEAN=fc cls fmt gz ist ltx pdf sty zip
set ENGINE=pdflatex
set NEXT=end
set PDF=expl3 source3
set SCRIPTDIR=..\support
set TESTDIR=testfiles
set VALIDATE=..\validate

:loop

  if /i "%1" == "alldoc"       goto :alldoc
  if /i "%1" == "check"        goto :check
  if /i "%1" == "checkcmd"     goto :checkcmd
  if /i "%1" == "checkcmds"    goto :checkcmds
  if /i "%1" == "checkdoc"     goto :checkdoc
  if /i "%1" == "checklvt"     goto :checklvt
  if /i "%1" == "clean"        goto :clean
  if /i "%1" == "ctan"         goto :ctan
  if /i "%1" == "doc"          goto :doc
  if /i "%1" == "format"       goto :format
  if /i "%1" == "localinstall" goto :localinstall
  if /i "%1" == "savetlg"      goto :savetlg
  if /i "%1" == "sourcedoc"    goto :sourcedoc
  if /i "%1" == "tds"          goto :tds
  if /i "%1" == "unpack"       goto :unpack
  if /i "%1" == "xecheck"      goto :xecheck
  if /i "%1" == "xechecklvt"   goto :xechecklvt

  goto :help
  
:alldoc

  call make sourcedoc

  echo.
  echo Typesetting
  
  for %%I in (l3*.dtx) do (
    echo   %%~nI
    pdflatex -interaction=nonstopmode -draftmode -quiet %%~nI.dtx
    if ERRORLEVEL 0 (
      makeindex -q -s l3doc.ist -o %%I.ind %%~nI.idx > temp.log
      pdflatex -interaction=nonstopmode -quiet %%~nI.dtx
      pdflatex -interaction=nonstopmode -quiet %%~nI.dtx
      for /F "tokens=*" %%J in (%%~nI.log) do (
        if "%%J" == "Functions documented but not defined:" (
        echo   ! Some functions not defined 
        )
        if "%%J" == "Functions defined but not documented:" (
        echo   ! Some functions not documented 
        )
      )
    ) else (
      echo   ! %%~nI compilation failed
    )
  )
  
  goto :end
  
:check

  set ENGINE=pdflatex
    
  call make unpack

:check-int

  set NEXT=check-int
  if not defined PERL goto :perl
  
  copy /y %SCRIPTDIR%\log2tlg > temp.log
  copy /y %VALIDATE%\regression-test.tex > temp.log
  
  if exist *.fc  del /q *.fc
  if exist *.lvt del /q *.lvt
  if exist *.tlg del /q *.tlg
  for %%I in (%TESTDIR%\*.tlg) do (
    if exist %TESTDIR%\%%~nI.lvt (
      copy /y %TESTDIR%\%%~nI.lvt > temp.log
      copy /y %TESTDIR%\%%~nI.tlg > temp.log
    )
  )
  
  echo.
  echo Running checks on
  
  for %%I in (*.tlg) do (
    echo   %%~nI
    %ENGINE% %%~nI.lvt > temp.log
    %ENGINE% %%~nI.lvt > temp.log
    %PERL% log2tlg %%~nI < %%~nI.log > %%~nI.new.log 
    del /q %%~nI.log > temp.log
    ren %%~nI.new.log %%~nI.log > temp.log
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
  
  goto :clean-int
  
:checkcmd

  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-dtx
  
  call make unpack
 
  copy /y %VALIDATE%\commands-check.tex > temp.log
  
  if exist missing.cmds.log del /q missing.cmds.log
  
  echo.
  echo Checking commands in %2
  
  pdflatex -interaction=batchmode -quiet %2.dtx 
  pdflatex -interaction=batchmode "\def\CMDS{%2.cmds}\input commands-check" > cmds.log
  for /F "tokens=1*" %%I in (cmds.log) do (
    if "%%I"=="!>" copy /y cmds.log missing.cmds.log > temp.log
  )
  if exist missing.cmds.log (
    echo   Missing commands:
    for /F "tokens=1*" %%I in (missing.cmds.log) do (
      if "%%I"=="!>" echo   - %%J 
    )
  ) 
  
  shift
  
  goto :clean-int
  
:checkcmds
  
  call make unpack
 
  copy /y %VALIDATE%\commands-check.tex > temp.log
  
  echo.
  echo Checking commands
  
  for %%I in (%CHECKCMDS%) do (
    echo   l3%%~nI
    if exist missing.cmds.log del /q missing.cmds.log
    pdflatex -interaction=batchmode -quiet l3%%I.dtx
    pdflatex -interaction=batchmode "\def\CMDS{l3%%I.cmds}\input commands-check" > cmds.log
    for /F "tokens=1*" %%J in (cmds.log) do (
      if "%%J"=="!>" copy /y cmds.log missing.cmds.log > temp.log
    )
    if exist missing.cmds.log (
      echo     Missing commands:
      for /F "tokens=1*" %%J in (missing.cmds.log) do (
        if "%%J"=="!>" echo     - %%K
      )
    )
  )
  
  goto :clean-int
  
:checkdoc

  call make unpack
  
  echo.
  echo Checking documentation of functions

  for %%I in (l3*.dtx) do (
    echo   %%~nI
    pdflatex -interaction=nonstopmode -draftmode -quiet %%I
    if  ERRORLEVEL 0 (
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

  set ENGINE=pdflatex
    
  call make unpack

:checklvt-int

  set NEXT=checklvt-int
  if not defined PERL goto :perl
  
  if "%2" == "" goto :help
  if not exist %TESTDIR%\%2.lvt goto :no-lvt
  if not exist %TESTDIR%\%2.tlg goto :no-tlg
  
  copy /y %SCRIPTDIR%\log2tlg > temp.log
  copy /y %VALIDATE%\regression-test.tex > temp.log
  
  copy /y %TESTDIR%\%2.lvt > temp.log
  copy /y %TESTDIR%\%2.tlg > temp.log
  
  if exist %2.fc  del /q %2.fc
  
  echo.
  echo Running checks on %2

  %ENGINE% %2.lvt > temp.log
  %ENGINE% %2.lvt > temp.log
  %PERL% log2tlg %2 < %2.log > %2.new.log
  del /q %2.log > temp.log 
  ren %2.new.log %2.log > temp.log
  fc /n  %2.log %2.tlg > %2.fc
  
  for /f "skip=1 tokens=1" %%I in (%2.fc) do (
    if "%%I" == "FC:" (
      del /q %2.fc
    )
  )
  
  if exist %2.fc (
    echo   Checks fails
  ) else (
    echo   Check passed
  )
  
  shift
  
  goto :clean-int 

:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I
  
  if exist log2tlg del /q log2tlg
  if exist commands-check.tex del /q commands-check.tex
  if exist regression-test.tex del /q regression-test.tex
    
  goto :end
  
:ctan

  set NEXT=ctan
  if not defined ZIP goto :zip
  
  call make tds
  
  echo.
  echo Making CTAN archive
  
  if exist temp\*.* del /q /s temp\*.* > temp.log
  
  xcopy /y *.dtx temp\expl3\ > temp.log
  for %%I in (%PDF%) do (
    copy /y %%I.pdf temp\expl3\ > temp.log
  )
  copy /y *.txt temp\expl3\ > temp.log
  pushd temp\expl3
  ren README.txt README
  popd
  copy /y *.ins temp\expl3\ > temp.log
  copy /y source3.tex temp\expl3\ > temp.log
  copy /y expl3.tds.zip temp\ > temp.log
  
  cd temp
  "%ZIP%" %ZIPFLAG% expl3.zip > temp.log
  cd ..
  copy temp\expl3.zip > temp.log
  rmdir /q /s temp
  
  goto :clean-int
  
:doc

  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-dtx

  call make unpack

  echo Typesetting %2
  pdflatex -interaction=nonstopmode -draftmode -quiet %2.dtx
  if ERRORLEVEL 0 (
    makeindex -q -s l3doc.ist -o %2.ind %2.idx > temp.log
    pdflatex -interaction=nonstopmode -quiet %2.dtx
    pdflatex -interaction=nonstopmode -quiet %2.dtx
    for /F "tokens=*" %%I in (%2.log) do (
      if "%%I" == "Functions documented but not defined:" (
      echo ! Some functions not defined 
      )
      if "%%I" == "Functions defined but not documented:" (
      echo ! Some functions not documented 
      )
    )
  ) else (
    echo ! %2 compilation failed
  )
  
  shift
  
  goto :clean-int
  
:format
  
  call make unpack

  echo. 
  echo Making format

  tex l3format.ins > temp.log
  pdftex -ini *lbase.ltx > temp.log
  
  goto :clean-int  
  
:help

  echo.
  echo  make alldoc            - typeset all documentation
  echo  make check             - runs automated test suite using pdfLaTeX
  echo  make checklvt ^<name^>   - runs automated test on ^<name^> using pdfLaTeX
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
  echo  make xecheck           - runs automated test suite using XeLaTeX
  echo  make xechecklvt ^<name^> - runs automated test for ^<name^> using XeLaTeX
  
  goto :end
  
:localinstall

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
    echo.
    echo TEXMFHOME variable was not set:
    echo using default value %USERPROFILE%\texmf
  )
  
  SET LTEXMF=%TEXMFHOME%\tex\latex\keys3
  
  call make unpack
  
  echo.
  echo Installing files
  
  if exist "%LTEXMF%\*.*" del /q "%LTEXMF%\*.*"
  xcopy /y *.sty "%LTEXMF%\*.*" > temp.log
  copy /y l3doc.cls "%LTEXMF%\*.*" > temp.log
  copy /y l3vers.dtx "%LTEXMF%\*.*" > temp.log
  xcopy /y l3doc.ist "%TEXMFHOME%\makeindex\expl3\*.*" > temp.log
  
  goto :clean-int
  
:no-dtx
  
  echo.
  echo No such file %2.dtx
  
  shift

  goto :end
  
:no-lvt
  
  echo.
  echo No such file %2.lvt
  
  shift

  goto :end
  
:no-tlg
  
  echo.
  echo No such file %2.tlg
  
  shift

  goto :end
  
:savetlg

  if "%2" == "" goto :help
  if not exist %TESTDIR%\%2.lvt goto :no-lvt

  set NEXT=savetlg
  if not defined PERL goto :perl
  
  call make unpack
 
  copy /y %SCRIPTDIR%\log2tlg > temp.log
  copy /y %VALIDATE%\regression-test.tex > temp.log
  copy /y %TESTDIR%\%2.lvt > temp.log
  
  echo.
  echo Creating and copying %2.tlg
  
  pdflatex %2.lvt > temp.log 
  pdflatex %2.lvt > temp.log
  %PERL% log2tlg %2 < %2.log > %2.tlg
  copy /y %2.tlg %TESTDIR%\%2.tlg > temp.log
  
  shift 
  
  goto :clean-int
  
:perl

  set PATHCOPY=%PATH%
  
:perl-loop
  
  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist %%I\perl.exe set PERL=perl
    set PATHCOPY=%%J;%%K
  )
  
  if defined PERL goto :%NEXT%

  if not "%PATHCOPY%"==";" goto :perl-loop
  
  if exist %SYSTEMROOT%\Perl\bin\perl.exe set PERL=%SYSTEMROOT%\Perl\bin\perl
  if exist %ProgramFiles%\Perl\bin\perl.exe set PERL=%ProgramFiles%\Perl\bin\perl
  
  if defined PERL goto :%NEXT%
  
  echo.
  echo  This procedure requires Perl, but it could not be found.
  
  goto :end
  
:sourcedoc

  call make unpack

  echo.
  echo Typesetting source3
  
  pdflatex -interaction=nonstopmode -draftmode -quiet "\PassOptionsToClass{nocheck}{l3doc} \input source3"
  if ERRORLEVEL 0 ( 
    echo   Re-typesetting for index generation
    makeindex -q -s l3doc.ist -o source3.ind source3.idx > temp.log
    pdflatex -interaction=nonstopmode -quiet "\PassOptionsToClass{nocheck}{l3doc} \input source3"
    echo   Re-typesetting to resolve cross-references
    pdflatex -interaction=nonstopmode -quiet "\PassOptionsToClass{nocheck}{l3doc} \input source3"
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
  
  pdflatex -interaction=nonstopmode -draftmode -quiet expl3.dtx
  if ERRORLEVEL 0 (
    makeindex -q -s l3doc.ist -o expl3.ind expl3.idx > temp.log
    pdflatex -interaction=nonstopmode -quiet expl3.dtx
    pdflatex -interaction=nonstopmode -quiet expl3.dtx
  ) else (
    echo ! expl3 compilation failed
  )
    
  goto :clean-int
  
:tds

  set NEXT=tds
  if not defined ZIP goto :zip

  if exist tds\*.* del /q /s tds\*.* > temp.log
  
  call make sourcedoc
  
  echo.
  echo Making TDS structure 
  
  xcopy /y *.sty tds\tex\latex\expl3\ > temp.log
  copy /y l3doc.cls tds\tex\latex\expl3\ > temp.log
  copy /y l3vers.dtx tds\tex\latex\expl3\ > temp.log
  
  xcopy /y l3doc.ist tds\makeindex\expl3\ > temp.log
  
  xcopy /y *.dtx tds\source\latex\expl3\ > temp.log
  copy /y *.ins tds\source\latex\expl3\ > temp.log
  copy /y source3.tex tds\source\latex\expl3\ > temp.log
  
  xcopy /y *.txt tds\doc\latex\expl3\ > temp.log
  pushd tds\doc\latex\expl3
  ren README.txt README
  popd
  for %%I in (%PDF%) do (
    copy /y %%I.pdf tds\doc\latex\expl3\ > temp.log
  )
 
  cd tds
  "%ZIP%" %ZIPFLAG% expl3.tds.zip > temp.log
  cd ..
  copy /y tds\expl3.tds.zip > temp.log
  
  rmdir /q /s tds
  
  goto :clean-int
  
:xecheck

  set ENGINE=xelatex

  call make unpack
  
  goto :check-int

:xechecklvt

  set ENGINE=xelatex

  call make unpack
  
  goto :checklvt-int
  
:unpack
  
  echo.
  echo Unpacking files
  
  tex -quiet l3.ins
  tex -quiet l3doc.dtx
  del /q *.log
  
  goto :end
  
:zip  

  set PATHCOPY=%PATH%
  
:zip-loop
  
  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist %%I\7z.exe (
      set ZIP=7z
      set ZIPFLAG=a
    )
    set PATHCOPY=%%J;%%K
  )
  
  if defined ZIP goto :%NEXT%

  if not "%PATHCOPY%"==";" goto :zip-loop
  
  if exist %ProgramFiles%\7-zip\7z.exe (
    set ZIP=%ProgramFiles%\7-zip\7z.exe
    set ZIPFLAG=a
  )
  
  if defined ZIP (
    goto :%NEXT%
  ) else (
    echo.
    echo This procedure requires a zip program,
    echo but one could not be found.
    echo
    echo If you do have a command-line zip program installed,
    echo set ZIP to the full executable path and ZIPFLAG to the
    echo appropriate flag to create an archive.
    echo.
    goto :end
  )
  
:end

  shift
  if not "%1" == "" goto :loop
  
  endlocal
