@echo off
rem This Windows batch file provides some basic make-like functionality
rem for the expl3 bundle

set EXPL3AUXFILES=aux cmds dvi glo gls hd idx ilg ind ist log out toc
set EXPL3CHECKMODULES=expl3 l3basics l3box l3calc l3clist l3expan l3int l3intexpr l3io l3keyval l3messages l3msg l3names l3num l3precom l3prg l3prop l3quark l3seq l3skip l3tl l3token l3toks l3xref 
set EXPL3NEXT=end

if "%1" == "alldoc"    goto :alldoc
if "%1" == "checkcmd"  goto :checkcmd
if "%1" == "checkcmds" goto :checkcmds
if "%1" == "checkdoc"  goto :checkdoc
if "%1" == "clean"     goto :clean
if "%1" == "doc"       goto :doc
if "%1" == "sourcedoc" goto :sourcedoc

goto :help

:alldoc
  
  set EXPL3NEXT=alldoc-a
 
  goto :typeset-aux

:alldoc-a 

  echo Typesetting all dtx files: please be patient!
  
  for %%I in (*.dtx) do call temp %%~nI
  
  goto :sourcedoc-a
  
:checkcmd

  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-file
  
  set EXPL3NEXT=checkcmd-a
  goto :checkcmds-aux
  
:checkcmd-a
  
  call temp %2
  
  goto :end

:checkcmds

  set EXPL3NEXT=checkcmds-a
 
  goto :checkcmds-aux

:checkcmds-a

  for %%I in (%EXPL3CHECKMODULES%) do call temp %%~nI
  
  goto :clean
  
:checkcmds-aux

  tex -quiet l3.ins
  tex -quiet l3doc.dtx

  echo @echo off > temp.bat
  echo echo. >> temp.bat
  echo echo Checking %%1.dtx  >> temp.bat
  echo latex -interaction=batchmode -quiet %%1.dtx >> temp.bat
  echo latex -interaction=nonstopmode -quiet "\def\CMDS{%%1.cmds}\input commands-check" ^> cmds.log >> temp.bat
  echo for /F "tokens=1*" %%%%I in (cmds.log) do if "%%%%I"=="!>" echo %%%%J >> temp.bat
  echo :end >> temp.bat
  
  goto :%EXPL3NEXT%
    
:checkdoc
  
  set EXPL3NEXT=checkdoc-a
 
  goto :checkdoc-aux
  
:checkdoc-a
  
  for %%I in (*.dtx) do call temp %%~nI
  
  goto :clean
  
:checkdoc-aux

  tex -quiet l3doc.dtx

  echo @echo off > temp.bat
  echo echo. >> temp.bat
  echo echo Checking %%1.dtx  >> temp.bat
  echo pdflatex -interaction=nonstopmode -draftmode -quiet %%1.dtx >> temp.bat
  echo if not ERRORLEVEL 0 goto :error >> temp.bat
  echo for /F "skip=2000 tokens=*" %%%%I in (%%1.log) do if "%%%%I"=="Functions documented but not defined:" echo ! Warning: some functions documented but not defined >> temp.bat
  echo for /F "skip=2000 tokens=*" %%%%I in (%%1.log) do if "%%%%I"=="Functions defined but not documented:" echo ! Warning: some functions defined but not documented >> temp.bat
  echo goto :end >> temp.bat
  echo :error >> temp.bat
  echo echo ! %%1.dtx compilation failed >> temp.bat
  echo :end >> temp.bat
        
  goto :%EXPL3NEXT%
  
:clean

  for %%I in (%EXPL3AUXFILES%) do if exist *.%%I del /q *.%%I
  
  if exist l3doc.cls del /q l3doc.cls 
  if exist l3doc.ist del /q l3doc.ist
  
  if exist temp.bat del /q temp.bat
    
  echo.
  echo All done
  
  goto :end
  
:doc
  
  if "%2" == "" goto :help
  if not exist %2.dtx goto :no-file
  
  set EXPL3NEXT=doc-a
  goto :typeset-aux
  
:doc-a
  
  call temp %2
  
  goto :clean
  
:help

  echo.
  echo  make clean               - removes temporary files
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
  echo.
  
  goto :end
  
:no-file
  
  echo.
  echo No such file %2.dtx
  echo.
  echo Type "make help" for more help

  goto :end
  
:sourcedoc
  
  set EXPL3NEXT=sourcedoc-a
 
  goto :typeset-aux

:sourcedoc-a
  
  call temp source3
  
  goto :clean
  
:typeset-aux

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
        
  goto :%EXPL3NEXT%
  
:end