@echo off
rem This Windows batch file provides some basic make-like functionality
rem for the expl3 bundle

setlocal

set AUXFILES=aux cmds dvi glo gls hd idx ilg ind ist log lvt out tlg toc 
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
rem  if "%1" == "checklvt"  goto :checklvt
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
  
:checkcmd

  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-dtx
  
  set NEXT=checkcmd
  
  goto :checkcmds-aux
  
:checkcmd-return

  copy %VALIDATE%\commands-check.tex
  
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

  set NEXT=checklvt
  
  goto :checklvt-aux

:checklvt-return

  if "%2" == "" goto :help
  if not exist %TESTDIR%\%2.lvt goto :no-lvt
  
  copy %SCRIPTDIR%\log2tlg
  
  call temp %2
  
  shift

  goto :end
  
:checklvt-aux

  tex -quiet l3.ins
  
  echo @echo off > temp.bat
  echo copy %TESTDIR%\%%1.lvt >> temp.bat
  echo if exist %%1.tlg copy %TESTDIR%\%%1.tlg >> temp.bat
  echo latex -quiet %%1.lvt >> temp.bat
  echo perl log2tlg %%1.log

  goto :%NEXT%-return
  
:clean

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
rem  echo  make checklvt ^<name^>  - run ^<name^>.lvt only
rem  echo.
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
  echo makeindex -q -s l3doc.ist -o %%1.ind %%1.idx >> temp.bat
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