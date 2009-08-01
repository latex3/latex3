@echo off
rem This Windows batch file provides very similar functionality to the
rem Makefile also available here.  Some of the options provided here 
rem require a zip program such as 7-Zip (http://www.7zip.org).

setlocal

set CTAN=xbase
set NEXT=end
set ROOT=latex\xpackages
set TEST=galley xbase xfootnote xfrontm xhead xor xtheorem
set TXT=readme-ctan
set XPACKAGES=galley xbase xcontents xfootnote xfrontm xhead xinitials xlang xor xtheorem

:loop

  if /i [%1] == [check]        goto :check
  if /i [%1] == [clean]        goto :clean
  if /i [%1] == [ctan]         goto :ctan
  if /i [%1] == [localinstall] goto :localinstall
  if /i [%1] == [tds]          goto :tds
  
  goto :help
  
:check

  for %%I in (%TEST%) do (
    cd %%I
    echo Testing %%I
    call make check
    cd ..
  )
  
  goto :end

:clean
  
  for %%I in (%XPACKAGES%) do (
    cd %%I
    call make clean
    cd ..
  )
  
  if exist *.zip del /q *.zip

:clean-int

  if exist *.log del /q *.log

  goto :end

:ctan

  set NEXT=ctan
  if not defined ZIP goto :zip

  echo.
  echo Working

  if exist tds\*.* del /q /s tds\*.* > temp.log
  if exist temp\*.* del /q /s temp\*.* > temp.log
  
  for %%I in (%CTAN%) do (
    echo Package %%I
    cd %%I
    call make unpack
    xcopy /y *.sty "..\tds\tex\%ROOT%\"  > temp.log
    if exist *.cls (
      copy /y *.cls "..\tds\tex\%ROOT%\" > temp.log
    )
    call make doc
    xcopy /y *.pdf "..\tds\doc\%ROOT%\"  > temp.log
    xcopy /y *.pdf "..\temp\xpackages\"  > temp.log
    xcopy /y *.dtx "..\tds\source\%ROOT%\"  > temp.log
    copy /y *.dtx "..\temp\xpackages\"  > temp.log
    copy /y *.ins "..\tds\source\%ROOT%\"  > temp.log
    copy /y *.ins "..\temp\xpackages\"  > temp.log
    if exist *.tex copy /y *.tex "..\tds\source\%ROOT%\" > temp.log
    if exist *.tex copy /y *.tex "..\temp\xpackages\" > temp.log
    call make clean
    cd ..
  )
  
  for %%I in (%TXT%) do (
    copy /y %%I.txt "tds\doc\%ROOT%\" > temp.log
    copy /y %%I.txt "temp\xpackages\" > temp.log
  )
  pushd tds\doc\%ROOT%\
  ren README-ctan.txt README
  popd
  pushd temp\xpackages\
  ren README-ctan.txt README
  popd
  
  cd tds
  "%ZIP%" %ZIPFLAG% xpackages.tds.zip > temp.log
  cd ..
  copy /y tds\xpackages.tds.zip temp\ > temp.log
  
  cd temp
  "%ZIP%" %ZIPFLAG% xpackages.zip > temp.log
  cd ..
  copy /y temp\xpackages.zip > temp.log
  
  rmdir /q /s tds
  rmdir /q /s temp

  goto :clean-int
  
:help

  echo.
  echo  make clean              - clean out all directories
  echo  make check              - set up and run all tests
  echo  make ctan               - create a zip file ready to go to CTAN
  echo  make localinstall       - install the .sty files in your home texmf tree
  echo  make tds                - creates a TDS-ready zip of CTAN packages
  echo.
  echo  make help               - show this help text
  echo  make
  
  goto :end

:localinstall

  if not defined TEXMFHOME (
    if exist "%APPDATA%\MiKTeX\2.8" (
      set TEXMFHOME=%APPDATA%\MiKTeX\2.8
    ) else (
      echo.
      echo TEXMFHOME variable was not set:
      echo using default value %USERPROFILE%\texmf
      set TEXMFHOME=%USERPROFILE%\texmf
    )
  )
  
  SET LTEXMF=%TEXMFHOME%\tex\%ROOT%
  
  echo.
  echo Installing files
  
  if exist "%LTEXMF%\*.*" del /q /s "%LTEXMF%\*.*"
  
  for %%I in (%XPACKAGES%) do (
    echo Package %%I
    cd %%I
    echo   %%I
    call make unpack
    xcopy /y *.sty "%LTEXMF%\%%I\"  > temp.log
    if exist *.cls (
      copy /y *.cls "%LTEXMF%\%%I\"  > temp.log
    )
    call make clean
    cd ..
  )
  
  goto :clean-int
  
:tds

  set NEXT=tds
  if not defined ZIP goto :zip

  echo.
  echo Creating working files

  if exist tds\*.* del /q /s tds\*.* > temp.log
  
  for %%I in (%CTAN%) do (
    echo Package %%I
    cd %%I
    call make unpack
    xcopy /y *.sty "..\tds\tex\%ROOT%\"  > temp.log
    if exist *.cls (
      copy /y *.cls "..\tds\tex\%ROOT%\" > temp.log
    )
    call make doc
    xcopy /y *.pdf "..\tds\doc\%ROOT%\"  > temp.log
    if exist *.tex xcopy /y *.tex "..\tds\doc\%ROOT%\" > temp.log
    xcopy /y *.dtx "..\tds\source\%ROOT%\"  > temp.log
    copy /y *.ins "..\tds\source\%ROOT%\"  > temp.log
    call make clean
    cd ..
  )
  
  for %%I in (%TXT%) do (
    copy /y %%I.txt "tds\doc\%ROOT%\" > temp.log
  )
  
  cd tds
  "%ZIP%" %ZIPFLAG% xpackages.tds.zip > temp.log
  cd ..
  copy /y tds\xpackages.tds.zip > temp.log
  
  rmdir /q /s tds

  goto :clean-int

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
  if not [%1] == [] goto :loop
  
  endlocal
  
  echo.
  echo All done