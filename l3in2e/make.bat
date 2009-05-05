@echo off
rem This Windows batch file provides some basic make-like functionality
rem for the expl3 bundle

setlocal

set AUXFILES=aux cmds dvi glo gls hd idx ilg ind ist log lvt out tlg toc xref
set CHECKMODULES=expl3 l3basics l3box l3calc l3clist l3expan l3int l3intexpr l3io l3keyval l3messages l3msg l3names l3num l3precom l3prg l3prop l3quark l3seq l3skip l3tl l3token l3toks l3xref 
set NEXT=end
set SCRIPTDIR=..\support
set TESTDIR=testfiles
set VALIDATE=..\validate

:loop

  if "%1" == "alldoc"    goto :alldoc
  if "%1" == "checkcmd"  goto :checkcmd
  if "%1" == "checkcmds" goto :checkcmds
  if "%1" == "checkdoc"  goto :checkdoc
  if "%1" == "checklvt"  goto :checklvt
  if "%1" == "check"     goto :check
  if "%1" == "clean"     goto :clean
  if "%1" == "doc"       goto :doc
  if "%1" == "sourcedoc" goto :sourcedoc

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
  copy %TESTDIR%\*.tlg > temp.log
  copy %TESTDIR%\*.lvt > temp.log
    
  copy %SCRIPTDIR%\log2tlg > temp.log
  
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

  copy %VALIDATE%\commands-check.tex > temp.log
  
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

  echo @echo off > temp.bat
  echo echo. >> temp.bat
  echo echo Checking %%1.dtx  >> temp.bat
  echo echo. >> temp.bat
  echo latex -interaction=batchmode -quiet %%1.dtx >> temp.bat
  echo latex -interaction=nonstopmode -quiet "\def\CMDS{%%1.cmds}\input commands-check" ^> cmds.log >> temp.bat
  echo for /F "tokens=1*" %%%%I in (cmds.log) do if "%%%%I"=="!>" echo %%%%J >> temp.bat
  echo :end >> temp.bat
  
  goto :%NEXT%-return
    
:checkdoc
  
  set NEXT=checkdoc
 
  goto :checkdoc-aux
  
:checkdoc-return
  
  for %%I in (*.dtx) do call temp %%~nI
  
  goto :clean-int
  
:checkdoc-aux

  tex -quiet l3.ins
  tex -quiet l3doc.dtx

  echo @echo off > temp.bat
  echo echo. >> temp.bat
  echo echo Checking %%1.dtx  >> temp.bat
  echo pdflatex -interaction=nonstopmode -draftmode -quiet %%1.dtx >> temp.bat
  echo if not ERRORLEVEL 0 goto :error >> temp.bat
  echo for /F "tokens=*" %%%%I in (%%1.log) do if "%%%%I"=="Functions documented but not defined:" echo ! Warning: some functions documented but not defined >> temp.bat
  echo for /F "tokens=*" %%%%I in (%%1.log) do if "%%%%I"=="Functions defined but not documented:" echo ! Warning: some functions defined but not documented >> temp.bat
  echo goto :end >> temp.bat
  echo :error >> temp.bat
  echo echo ! %%1.dtx compilation failed >> temp.bat
  echo :end >> temp.bat
        
  goto :%NEXT%-return
  
:checklvt

  if "%2" == "" goto :help
  if not exist %TESTDIR%\%2.lvt goto :no-lvt
  if not exist %TESTDIR%\%2.tlg goto :no-tlg

  set NEXT=checklvt
  
  goto :checklvt-aux

:checklvt-return
 
  copy %SCRIPTDIR%\log2tlg > temp.log
  
  copy %TESTDIR%\%2.lvt > temp.log
  copy %TESTDIR%\%2.tlg > temp.log
  
  call temp %2
  
  shift

  goto :clean-int
  
:checklvt-aux
 
  if not defined PERL goto :perl

  tex -quiet l3.ins
  
  echo @echo off                                                > temp.bat
  echo echo Checking %%1.lvt                                   >> temp.bat
  echo latex %%1.lvt ^> temp.log                               >> temp.bat
  echo latex %%1.lvt ^> temp.log                               >> temp.bat
  echo perl log2tlg %%1 ^< %%1.log ^> %%1.tmp.log              >> temp.bat
  echo perl -n -e "/^\s*$/ || print" ^< %%1.tlg ^> %%1.mod.tlg >> temp.bat
  echo fc  %%1.tmp.log %%1.mod.tlg ^> %%1.fc                   >> temp.bat
  echo for /f "skip=1 tokens=1*" %%%%I in (%%1.fc) do (        >> temp.bat
  echo   if "%%%%J" == "no differences encountered" (          >> temp.bat
  echo     del %%1.fc                                          >> temp.bat
  echo   )                                                     >> temp.bat
  echo )                                                       >> temp.bat
  echo if exist %%1.fc (                                       >> temp.bat
  echo   echo.                                                 >> temp.bat
  echo   echo *********************                            >> temp.bat
  echo   echo * Check not passed! *                            >> temp.bat
  echo   echo *********************                            >> temp.bat
  echo   echo.                                                 >> temp.bat
  echo )                                                       >> temp.bat

  goto :%NEXT%-return
  
:clean

  if exist *.fc  del /q *.fc
  if exist *.pdf del /q *.pdf
  if exist *.sty del /q *.sty

:clean-int

  for %%I in (%AUXFILES%) do if exist *.%%I del /q *.%%I
  
  if exist l3in2e.err del l3in2e.err
  
  if exist l3doc.cls del /q l3doc.cls 
  if exist l3doc.ist del /q l3doc.ist
  
  if exist log2tlg del /q log2tlg
  if exist commands-check.tex del /q commands-check.tex
  
  if exist temp.bat del /q temp.bat
    
  echo.
  echo All done
  
  goto :end
  
:doc
  
  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-dtx
  
  set NEXT=doc-a
  goto :typeset-aux
  
:doc-a
  
  call temp %2
  
  shift
  
  goto :clean-int
  
:help

  echo.
  echo  make clean              - clean out test dirs
  echo.
  echo  make check              - set up and run all tests
  echo  make checklvt ^<name^>  - run ^<name^>.lvt only
  echo.
  echo  make checkdoc           - check all modules compile correctly
  echo  make checkcmd ^<name^>    - check all functions are defined in one module
  echo  make checkcmds          - check all functions are defined in all modules
  echo.
  echo  make doc ^<name^>         - typeset ^<name^>.dtx
  echo  make sourcedoc          - typeset source3.tex
  echo  make alldoc             - typeset all documentation
  echo.
  echo  make help               - show this help text
  echo  make
  
  goto :end
  
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
  set PERL=
  
:perl-loop
  
  for /f "delims=; tokens=1,2*" %%I in ("%PATHCOPY%") do (
    if exist %%I\perl.exe set PERL=perl
    set PATHCOPY=%%J;%%K
  )
  
  if defined PERL goto :checklvt-aux

  if not "%PATHCOPY%"==";" goto :perl-loop
  
  if exist %SYSTEMROOT%\Perl\bin\perl.exe set PERL=%SYSTEMROOT%\Perl\bin\perl
  if exist %ProgramFiles%\Perl\bin\perl.exe set PERL=%ProgramFiles%\Perl\bin\perl
  
  if defined PERL goto :checklvt-aux
  
  echo.
  echo   This procedure requires Perl, but it could not be found.
  echo.
  
  goto :end
  
:sourcedoc
  
  set NEXT=sourcedoc
 
  goto :typeset-aux

:sourcedoc-return
  
  call temp source3
  
  goto :clean-int
  
:typeset-aux

  tex -quiet l3.ins
  tex -quiet l3doc.dtx

  echo @echo off > temp.bat
  echo echo. >> temp.bat
  echo echo Typesetting %%1.dtx  >> temp.bat
  echo pdflatex -interaction=nonstopmode -draftmode -quiet %%1.dtx >> temp.bat
  echo if not ERRORLEVEL 0 goto :error >> temp.bat
  echo makeindex -q -s l3doc.ist -o %%1.ind %%1.idx ^temp.log >> temp.bat
  echo pdflatex -interaction=nonstopmode -quiet %%1.dtx >> temp.bat
  echo pdflatex -interaction=nonstopmode -quiet %%1.dtx >> temp.bat
  echo for /F "skip=2000 tokens=*" %%%%I in (%%1.log) do if "%%%%I"=="Functions documented but not defined:" echo ! Warning: some functions documented but not defined >> temp.bat
  echo for /F "skip=2000 tokens=*" %%%%I in (%%1.log) do if "%%%%I"=="Functions defined but not documented:" echo ! Warning: some functions defined but not documented >> temp.bat
  echo goto :end >> temp.bat
  echo :error >> temp.bat
  echo echo ! %%1.dtx compilation failed >> temp.bat
  echo :end >> temp.bat
        
  goto :%NEXT%-return
  
:end

  shift
  if not "%2" == "" goto :loop
  
  endlocal