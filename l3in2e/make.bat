@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here. Some of the options provided here 
rem require Perl (http://www.perl.org) or a zip program such as 7-Zip
rem (http://www.7zip.org).

setlocal

set AUXFILES=aux cmds dvi glo gls hd idx ilg ind ist log lvt out tlg toc xref
set CHECKMODULES=expl3 l3basics l3box l3calc l3clist l3expan l3int l3intexpr l3io l3keyval l3messages l3msg l3names l3num l3precom l3prg l3prop l3quark l3seq l3skip l3tl l3token l3toks l3xref 
set CLEAN=fc pdf sty zip
set NEXT=end
set SCRIPTDIR=..\support
set TESTDIR=testfiles
set VALIDATE=..\validate

:loop

  if /i "%1" == "alldoc"       goto :alldoc
  if /i "%1" == "checkcmd"     goto :checkcmd
  if /i "%1" == "checkcmds"    goto :checkcmds
  if /i "%1" == "checkdoc"     goto :checkdoc
  if /i "%1" == "checklvt"     goto :checklvt
  if /i "%1" == "check"        goto :check
  if /i "%1" == "clean"        goto :clean
  if /i "%1" == "ctan"         goto :ctan
  if /i "%1" == "doc"          goto :doc
  if /i "%1" == "localinstall" goto :localinstall
  if /i "%1" == "savetlg"      goto :savetlg
  if /i "%1" == "sourcedoc"    goto :sourcedoc
  if /i "%1" == "tds"          goto :tds
  if /i "%1" == "unpack"       goto :unpack

  goto :help

:alldoc
  
  set NEXT=alldoc
 
  goto :typeset-aux

:alldoc-return

  echo Typesetting all dtx files: please be patient!
  
  for %%I in (*.dtx) do call temp %%~nI
  
  goto :sourcedoc
  
:check

  set NEXT=check
  
  goto :checklvt-aux

:check-return
 
  if exist *.tlg del /q *.tlg
  copy /y %TESTDIR%\*.tlg > temp.log
  copy /y %TESTDIR%\*.lvt > temp.log
     
  for %%I in (*.tlg) do call temp %%~nI
  
  if exist *.fc (
    echo.
    echo List of diffs produced during check:
    echo ====================================
    for %%I in (*.fc) do echo %%I
    echo ====================================
  ) else (
    echo.
    echo All tests passed successfully.
  )
  
  shift

  goto :clean-int
  
:checkcmd

  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-dtx
  
  set NEXT=checkcmd
  
  goto :checkcmds-aux
  
:checkcmd-return

  copy /y %VALIDATE%\commands-check.tex > temp.log
  
  call temp %2
  
  shift
  
  goto :clean-int

:checkcmds

  set NEXT=checkcmds
 
  goto :checkcmds-aux

:checkcmds-return

  for %%I in (%CHECKMODULES%) do call temp %%~nI
  
  goto :clean-int
  
:checkcmds-aux

  tex -quiet l3.ins
  tex -quiet l3doc.dtx

  echo @echo off                                    > temp.bat
  echo echo.                                       >> temp.bat
  echo echo Checking %%1.dtx                       >> temp.bat
  echo echo.                                       >> temp.bat
  echo latex -interaction=batchmode -quiet %%1.dtx >> temp.bat
  echo latex -interaction=nonstopmode "\def\CMDS{%%1.cmds}\input commands-check" ^> cmds.log >> temp.bat
  echo for /F "tokens=1*" %%%%I in (cmds.log) do ( >> temp.bat
  echo   if "%%%%I"=="!>" echo %%%%J               >> temp.bat
  echo )                                           >> temp.bat
  
  goto :%NEXT%-return
    
:checkdoc

  tex -quiet l3.ins
  tex -quiet l3doc.dtx
  
  echo.
  
  for %%I in (*.dtx) do (
    echo Checking %%I
    pdflatex -interaction=nonstopmode -draftmode -quiet %%I
    if  ERRORLEVEL 0 (
      for /F "tokens=*" %%J in (%%~nI.log) do (
        if "%%J" == "Functions documented but not defined:" (
          echo ! Warning: some functions not defined
        )
        if "%%J" == "Functions defined but not documented:" (
          echo ! Warning: some functions not documented
        )
      )
    ) else (
      echo ! %%1.dtx compilation failed
    )
  )
  
  goto :clean-int
  
:checklvt

  if "%2" == "" goto :help
  if not exist %TESTDIR%\%2.lvt goto :no-lvt
  if not exist %TESTDIR%\%2.tlg goto :no-tlg

  set NEXT=checklvt
  
  goto :checklvt-aux

:checklvt-return
 
  copy /y %TESTDIR%\%2.lvt > temp.log
  copy /y %TESTDIR%\%2.tlg > temp.log
  
  call temp %2
  
  if not exist *.fc (
    echo.
    echo Test passed successfully.
  )
  
  shift

  goto :clean-int
  
:checklvt-aux
 
  set PERLNEXT=checklvt-aux
  if not defined PERL goto :perl

  tex -quiet l3.ins
  
  echo Checking:
  
  echo @echo off                                                  > temp.bat
  echo echo   %%1.lvt                                            >> temp.bat
  echo latex %%1.lvt ^> temp.log                                 >> temp.bat
  echo latex %%1.lvt ^> temp.log                                 >> temp.bat
  echo %perl% log2tlg %%1 ^< %%1.log ^> %%1.tmp.log              >> temp.bat
  echo %perl% -n -e "/^\s*$/ || print" ^< %%1.tlg ^> %%1.mod.tlg >> temp.bat
  echo fc  %%1.tmp.log %%1.mod.tlg ^> %%1.fc                     >> temp.bat
  echo set FLAG=false                                            >> temp.bat
  echo for /f "skip=1 tokens=1" %%%%I in (%%1.fc) do (           >> temp.bat
  echo   if "%%%%I" == "FC:" (                                   >> temp.bat
  echo   set FLAG=true                                           >> temp.bat
  echo   )                                                       >> temp.bat
  echo )                                                         >> temp.bat
  echo if %%FLAG%%==true  (                                      >> temp.bat
  echo   del /q %%1.fc                                           >> temp.bat
  echo ) else (                                                  >> temp.bat
  echo   echo.                                                   >> temp.bat
  echo   echo *********************                              >> temp.bat
  echo   echo * Check not passed! *                              >> temp.bat
  echo   echo *********************                              >> temp.bat
  echo   echo.                                                   >> temp.bat
  echo )                                                         >> temp.bat
  
  copy /y %SCRIPTDIR%\log2tlg > temp.log
  copy /y %VALIDATE%\regression-test.tex > temp.log

  goto :%NEXT%-return
  
:clean

  for %%I in (%CLEAN%) do if exist *.%%I del /q *.%%I

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I
  
  if exist l3in2e.err del l3in2e.err
  
  if exist l3doc.cls del /q l3doc.cls 
  if exist l3doc.ist del /q l3doc.ist
  
  if exist log2tlg del /q log2tlg
  if exist commands-check.tex del /q commands-check.tex
  if exist regression-test.tex del /q regression-test.tex
  
  if exist temp.bat del /q temp.bat
    
  goto :end
  
:ctan

  set NEXT=ctan
  if not defined ZIP goto :zip
  
  call make tds
  
  if exist temp\*.* del /q /s temp\*.* > temp.log
  
  xcopy /y *.dtx temp\expl3\ > temp.log
  copy /y *.pdf temp\expl3\ > temp.log
  copy /y *.txt temp\expl3\ > temp.log
  copy /y l3.ins temp\expl3\ > temp.log
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
  
  set NEXT=doc-a
  goto :typeset-aux
  
:doc-return
  
  call temp %2
  
  shift
  
  goto :clean-int
  
:help

  echo.
  echo  make clean              - clean out test dirs
  echo.
  echo  make check              - set up and run all tests
  echo  make checklvt ^<name^>    - run ^<name^>.lvt only
  echo  make savetlg  ^<name^>    - save ^<name^>.tlg as a new certified test
  echo.
  echo  make checkdoc           - check all modules compile correctly
  echo  make checkcmd ^<name^>    - check all functions are defined in one module
  echo  make checkcmds          - check all functions are defined in all modules
  echo.
  echo  make doc ^<name^>         - typeset ^<name^>.dtx
  echo  make sourcedoc          - typeset source3.tex
  echo  make alldoc             - typeset all documentation
  echo.
  echo  make localinstall       - install the .sty files in your home texmf tree
  echo.
  echo  make tds                - creates a TDS-ready zip of all packages
  echo  make ctan               - create a zip file ready to go to CTAN
  echo.
  echo  make unpack             - extract all modules
  echo.
  echo  make help               - show this help text
  echo  make
  
  goto :end
  
:localinstall

  if not defined TEXMFHOME (
    set TEXMFHOME=%USERPROFILE%\texmf
    echo.
    echo TEXMFHOME variable was not set:
    echo using default value %USERPROFILE%\texmf
  )
  
  SET LTEXMF=%TEXMFHOME%\tex\latex\expl3
  
  echo.
  echo Installing files
  
  if exist "%LTEXMF%\*.*" del /q "%LTEXMF%\*.*"
  
  tex -quiet l3.ins
  tex -quiet l3doc.dtx
  
  xcopy /y *.sty "%LTEXMF%\*.*" > temp.log
  copy /y *.cls "%LTEXMF%\*.*" > temp.log
  copy /y l3vers.dtx "%LTEXMF%\*.*" > temp.log
  
  goto :clean-int
  
:no-dtx
  
  echo.
  echo No such file %2.dtx
  echo.
  echo Type "make help" for more help

  goto :end
  
:no-lvt
  
  echo.
  echo No such file %2.lvt
  echo.
  echo Type "make help" for more help

  goto :end
  
:no-tlg
  
  echo.
  echo No such file %2.tlg
  echo.
  echo Type "make help" for more help

  goto :end
  
:perl

  set PATHCOPY=%PATH%
  
:perl-loop
  
  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist %%I\perl.exe set PERL=perl
    set PATHCOPY=%%J;%%K
  )
  
  if defined PERL goto :%PERLNEXT%

  if not "%PATHCOPY%"==";" goto :perl-loop
  
  if exist %SYSTEMROOT%\Perl\bin\perl.exe set PERL=%SYSTEMROOT%\Perl\bin\perl
  if exist %ProgramFiles%\Perl\bin\perl.exe set PERL=%ProgramFiles%\Perl\bin\perl
  
  if defined PERL goto :%PERLNEXT%
  
  echo.
  echo   This procedure requires Perl, but it could not be found.
  echo.
  
  goto :end
  
:savetlg

  if "%2" == "" goto :help
  if not exist %TESTDIR%\%2.lvt goto :no-lvt

  set PERLNEXT=savetlg
  if not defined PERL goto :perl
 
  copy /y %SCRIPTDIR%\log2tlg > temp.log
  
  copy /y %TESTDIR%\%2.lvt > temp.log

  tex -quiet l3.ins
  
  echo Creating and copy /ying %2.tlg
  latex %2.lvt > temp.log 
  latex %2.lvt > temp.log
  %PERL% log2tlg %2 < %2.log > %2.tlg
  copy /y %2.tlg %TESTDIR%\%2.tlg
  
  shift 
  
  goto :clean-int
  
:sourcedoc

  echo.
  echo Typesetting source3.tex
  
  tex -quiet l3.ins
  tex -quiet l3doc.dtx

  pdflatex -interaction=nonstopmode -draftmode -quiet source3
  if ERRORLEVEL 0 ( 
    echo Re-typesetting for index generation
    makeindex -q -s l3doc.ist -o source3.ind source3.idx > temp.log
    pdflatex -interaction=nonstopmode -quiet source3
    echo Re-typesetting to resolve cross-references
    pdflatex -interaction=nonstopmode -quiet source3
    for /F "tokens=*" %%I in (source3.log) do (           
      if "%%I" == "Functions documented but not defined:" (   
        echo ! Warning: some functions not defined              
      )                                  
      if "%%I" == "Functions defined but not documented:" ( 
        echo ! Warning: some functions not documented      
      )                                                        
    )
  ) else (
    echo ! source3.tex compilation failed  
  )                                                           
  
  goto :clean-int
  
:tds

  set NEXT=tds
  if not defined ZIP goto :zip

  echo.
  echo Creating working files

  if exist tds\*.* del /q /s tds\*.* > temp.log
  
  tex -quiet l3.ins
  tex -quiet l3doc.dtx
  
  xcopy /y *.sty tds\tex\latex\expl3\ > temp.log
  copy /y *.cls tds\tex\latex\expl3\ > temp.log
  copy /y l3vers.dtx tds\tex\latex\expl3\ > temp.log
  
  xcopy /y *.dtx tds\source\latex\expl3\ > temp.log
  copy /y l3.ins tds\source\latex\expl3\ > temp.log
  copy /y source3.tex tds\source\latex\expl3\ > temp.log
  
  echo.
  echo Creating all documentation
  echo.
  
  call make alldoc
  
  xcopy /y *.txt tds\doc\latex\expl3\ > temp.log
  copy /y *.pdf tds\doc\latex\expl3\ > temp.log
  
  cd tds
  "%ZIP%" %ZIPFLAG% expl3.tds.zip > temp.log
  cd ..
  copy /y tds\expl3.tds.zip > temp.log
  
  rmdir /q /s tds
  
  goto :clean-int
  
:typeset-aux

  tex -quiet l3.ins
  tex -quiet l3doc.dtx

  echo @echo off                                                    > temp.bat
  echo echo Typesetting %%1.dtx                                    >> temp.bat
  echo pdflatex -interaction=nonstopmode -draftmode -quiet %%1.dtx >> temp.bat
  echo if ERRORLEVEL 0 (                                           >> temp.bat
  echo   makeindex -q -s l3doc.ist -o %%1.ind %%1.idx ^> temp.log  >> temp.bat
  echo   pdflatex -interaction=nonstopmode -quiet %%1.dtx          >> temp.bat
  echo   pdflatex -interaction=nonstopmode -quiet %%1.dtx          >> temp.bat
  echo   for /F "tokens=*" %%%%I in (%%1.log) do (                 >> temp.bat
  echo     if "%%%%I" == "Functions documented but not defined:" ( >> temp.bat
  echo       echo ! Warning: some functions not defined            >> temp.bat
  echo     )                                                       >> temp.bat
  echo     if "%%%%I" == "Functions defined but not documented:" ( >> temp.bat
  echo       echo ! Warning: some functions not documented         >> temp.bat
  echo     )                                                       >> temp.bat
  echo   )                                                         >> temp.bat
  echo ) else (                                                    >> temp.bat
  echo   echo ! %%1.dtx compilation failed                         >> temp.bat
  echo )                                                           >> temp.bat
        
  goto :%NEXT%-return
  
:unpack

  tex l3.ins > temp.log
  tex l3doc.dtx > temp.log
  
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
  if not "%2" == "" goto :loop
  
  endlocal
  
  echo.
  echo All done