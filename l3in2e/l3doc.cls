% \iffalse
%% File: l3doc.dtx Copyright (C) 1990-2005 LaTeX3 project
%%
%% It may be distributed and/or modified under the conditions of the
%% LaTeX Project Public License (LPPL), either version 1.3a of this
%% license or (at your option) any later version.  The latest version
%% of this license is in the file
%%
%%    http://www.latex-project.org/lppl.txt
%%
%% This file is part of the ``expl3 bundle'' (The Work in LPPL)
%% and all files in that bundle must be distributed together.
%%
%% The released version of this bundle is available from CTAN.
%%
%% -----------------------------------------------------------------------
%%
%% The development version of the bundle can be found at
%%
%%    http://www.latex-project.org/cgi-bin/cvsweb.cgi/
%%
%% for those people who are interested.
%%
%%%%%%%%%%%
%% NOTE: %%
%%%%%%%%%%%
%%
%%   Snapshots taken from the repository represent work in progress and may
%%   not work or may contain conflicting material!  We therefore ask
%%   people _not_ to put them into distributions, archives, etc. without
%%   prior consultation with the LaTeX Project Team.
%%
%% -----------------------------------------------------------------------
%% \fi
% \iffalse
%    \begin{macrocode}
%<*class>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{l3doc}
         [2005/12/25 v0.0f class for documenting experimental stuff]
%
\NeedsTeXFormat{LaTeX2e}
%</class>
%    \end{macrocode}
%
% \section{Options}                       
%
%    \begin{macrocode}
%<*class>
\DeclareOption{a5paper}{\@latexerr{Option not supported}%
   {}}
%    \end{macrocode}
%
%    \begin{macrocode}
\DeclareOption*{\PassOptionstoClass{\CurrentOption}{article}}
%    \end{macrocode}
%
% \section{Option Processing}
%
%    \begin{macrocode}
\ProcessOptions
%    \end{macrocode}
%
% \section{Loading article and doc}
%
%    \begin{macrocode}
\LoadClass{article}
%    \end{macrocode}
%
%    \begin{macrocode}
\RequirePackage{doc}
\renewcommand\MakePrivateLetters{\makeatletter
  \catcode`\_=11\relax
  \catcode`\:=11\relax}
%    \end{macrocode}
%
% \section{Configuration}
% Input a local configuration file, if it exists.
%    \begin{macrocode}
\InputIfFileExists{l3doc.cfg}
           {\typeout{*************************************^^J%
                     * Local config file l3doc.cfg used^^J%
                     *************************************}}
           {}
%    \end{macrocode}
%
% taken out for the moment as my laptop doesn't have a full set of
% type 1 fonts installed right now --- fmi
%\RequirePackage[T1]{fontenc}

%% The Guilty Parties
\def\Team{%
  The \LaTeX3 Project\thanks{%
  Frank Mittelbach, Denys Duchier, Chris Rowley,
  Rainer Sch\"opf, Johannes Braams, Michael Downes,
  David Carlisle, Alan Jeffrey, Morten H\o gholm, Thomas Lotze,
  Javier Bezos}}

%% You do not want to look at the mess below this line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\catcode`\_=11

%    \end{macrocode}
%
%    Make \verb+|+ and \verb+"+ be `short verb' characters, but not in
%    the document preamble, where an active character may interfere
%    with packages that are loaded.
%    \begin{macrocode}
\MakeShortVerb\"
\MakeShortVerb\|
%    \end{macrocode}
%
% As `doc' documents tend to have a lot of monospaced material,
% Set up some |tt| substitutions to occur silently.
%    \begin{macrocode}
\DeclareFontShape{OT1}{cmtt}{bx}{n}{<-> ssub * cmtt/m/n}{}
\DeclareFontFamily{OMS}{cmtt}{\skewchar\font 48}  % '60
\DeclareFontShape{OMS}{cmtt}{m}{n}{<-> ssub * cmsy/m/n}{}
\DeclareFontShape{OMS}{cmtt}{bx}{n}{<-> ssub * cmsy/b/n}{}
%    \end{macrocode}
% This substitution is in the standard fd file, but not silent.
%    \begin{macrocode}
\DeclareFontShape{OT1}{cmss}{m}{it}{<->ssub*cmss/m/sl}{}
%    \begin{macrocode}
\CodelineNumbered
\DisableCrossrefs
%    \end{macrocode}
%
% Increase the text width slightly so that width the standard fonts
% 72 columns of code may appear in a |macrocode| environment.
% \changes{v2.0c}{1994/03/15}{Set \cs{textwidth}.}
%    \begin{macrocode}
\setlength{\textwidth}{355pt}
%    \end{macrocode}
%
% Increase the marginpar width slightly, for long command names.
% And increase the left margin by a similar amount
% \changes{v2.0l}
%      {1994/05/25}{Increase \cs{marginparwidth}}
% \changes{v2.0q}{1995/11/28}
%      {Increase \cs{marginparwidth} and page margin.}
%    \begin{macrocode}
\addtolength\marginparwidth{30pt}
\addtolength\oddsidemargin{20pt}
\addtolength\evensidemargin{20pt}
%    \end{macrocode}
%
%
%    \begin{macrocode}
\setcounter{StandardModuleDepth}{1}
%    \end{macrocode}
%
%    \begin{macrocode}
\newcommand{\tn}[1]{{\ttfamily\bslash #1}%
   \index{TeX and LaTeX2e commands\actualchar
          \string\TeX{} and \string\LaTeXe{} commands:\levelchar
          #1\actualchar{\string\ttfamily\string\bslash{}#1}}}

% This command will be used to input the patch file
% if that file exists.
\newcommand{\includeltpatch}{%
  \def\currentfile{l3patch.ltx}
  \part{l3patch}
  {\let\ttfamily\relax
    \xdef\filekey{\filekey, \thepart={\ttfamily\currentfile}}}%
  Things we did wrong\ldots
  \IndexInput{l3patch.ltx}}

% Get the date from ltvers.dtx
\let\patchdate=\@empty
\begingroup
   %%\def\ProvidesFile#1\fmtversion#2{\date{#2}\endinput}
   \def\ProvidesFile#1[#2 #3]{\date{#2}\endinput}
   \input{l3vers.dtx}
\global\let\X@date=\@date

% Add the patch version if available.
   \long\def\Xdef#1#2#3\def#4#5{%
    \xdef\X@date{#2}%
    \xdef\patchdate{#5}%
    \endinput}%
   \InputIfFileExists{l3patch.ltx}
    {\let\def\Xdef}{\global\let\includeltpatch\relax}
\endgroup

\ifx\@date\X@date
   \def\Xpatch{0}
   \ifx\patchdate\Xpatch\else
     \edef\@date{\@date\space Patch level \patchdate}
   \fi
\else
   \@warning{l3patch.ltx does not match l3tvers.dtx!}
   \let\includeltpatch\relax
\fi

\providecommand*\eTeX{%
  \if b\expandafter\@car\f@series\@nil\boldmath\fi
  $\m@th\varepsilon$-\TeX}




\def\vindex#1>#2\@nil{%
  \edef\temp{\foo#2<>\@nil}%
  \ifx\temp\space\else
  \expandafter\SpecialMainIndexB\expandafter{\temp}\fi}

% remove <foo> from index (quick hack, could be better)
\def\foo#1<#2>#3\@nil{%
 #1\ifx\foo#3\foo
   \else#2\expandafter\foo\fi#3\@nil}
%\def\foo#1<#2>#3\@nil{#1<#2>#3}
\def\foo#1<#2>#3\@nil{#1}

% Cant remember why I switched from \SpecialMainIndexB
%%\gdef\SpecialMainIndexB#1{\index{\@gobble#1\space\actualchar{\string\verb+#1+}}}

\gdef\SpecialMainIndexB#1{\index{\@gobble#1\actualchar\string\verb
    \quotechar*\verbatimchar#1\verbatimchar\encapchar usage}}

% A helper for later on.
\def\q@nil{\q@nil}
\long\def\tlist@if@blank@p@n #1{%
  \expandafter\tlist@if@blank@p@aux@w\detokenize{#1}aa..\q@nil}
\def\tlist@if@blank@p@aux@w #1#2a#3#4\q@nil{%
  \ifx #3#400\else01\fi}


\let\m\meta
\newenvironment{texnote}%
   {\endgraf\vspace{3mm}\textbf{\TeX{}hackers~note:}\small}
    {\vspace{3mm}}
% stick the function names in a box.
{\catcode`\|=\active\catcode`\<=\active


 
% index fuction lists (could be better...)
\gdef\funcindex#1|{%
  \if\tlist@if@blank@p@n{#1}%
    \expandafter\@firstoftwo
  \else
    \expandafter\@secondoftwo
  \fi
  {\@ifnextchar|{\@gobble}{}}% at the end, look for extra | and remove it
  {\def\yyy{#1}\expandafter\vindex\meaning\yyy\@nil  \funcindex}%
}

\gdef\function{%
  \catcode`\<=\active\def<##1>{\meta{##1}}%
  \bigskip
  \bgroup
  \@makeother\\
  \@makeother\_
  \catcode`\ =9
  \catcode`\^^M=9
  \catcode`\^^I=9
  \catcode`\|=\active\def|{\\}%
  \@function}
\gdef\@function#1{%
  \ifx\@function#1\@function\else
    \funcindex#1| |%
  \fi
  \ttfamily
  \endgraf
  \noindent\hspace*{-2\parindent}%
  \tabular[b]%
     {@{\vline\hskip\tabcolsep}l@{\hskip\tabcolsep\vline}}%
  \hline
  #1\crcr
  \hline
  \noalign{\kern-2pt}%
  \endtabular
  \egroup}}


\let\variable\function

% syntax for functions
\def\syntax{%
  \@syntax}

\def\@syntax{%
 \minipage[b]{.7\textwidth}%
  \small\ttfamily\raggedright
  \obeyspaces\obeylines}
\def\endsyntax{\endminipage\hfil\break\global\@ignoretrue}


%The toks file uses these, Icould not see the original definition...
\let\zz\m
\let\zv\m

\setcounter{StandardModuleDepth}{1}
\addtolength{\textwidth}{30pt}

\let\@@oldlist\list
\def\list#1#2{\@@oldlist{#1}{#2\listparindent\z@}}

\setlength{\parindent}{0pt}
\setlength{\itemindent}{0pt}
\setlength{\parskip}{\medskipamount}
 
% \section{DocInclude}
%
%    \begin{macrocode}
\@addtoreset{CodelineNo}{part}
%    \end{macrocode}
%
% \begin{macro}{\DocInclude}
% More or less exactly the same as |\include|, but uses |\DocInput|
% on a |dtx| file, not |\input| on a |tex| file.
% \changes{v2.0b}{1994/03/14}{Rename from \cs{docinclude}}
% \changes{v2.0f}{1994/03/25}{Use \cs{part}}
% \changes{v2.0u}{1999/08/08}{Also works for .fdd (M. Schroeder)}
%    \begin{macrocode}
\def\partname{File}
%    \end{macrocode}
%
%    \begin{macrocode}
\newcommand*{\DocInclude}[1]{%
  \relax
  \clearpage
  \docincludeaux
  \IfFileExists{#1.fdd}{\def\currentfile{#1.fdd}}{\def\currentfile{#1.dtx}}%
  \ifnum\@auxout=\@partaux
    \@latexerr{\string\include\space cannot be nested}\@eha
  \else \@docinclude#1 \fi}
\def\@docinclude#1 {\clearpage
\if@filesw \immediate\write\@mainaux{\string\@input{#1.aux}}\fi
\@tempswatrue\if@partsw \@tempswafalse\edef\@tempb{#1}\@for
\@tempa:=\@partlist\do{\ifx\@tempa\@tempb\@tempswatrue\fi}\fi
\if@tempswa \let\@auxout\@partaux \if@filesw
\immediate\openout\@partaux #1.aux
\immediate\write\@partaux{\relax}\fi
%    \end{macrocode}
% We need to save (and later restore) various index-related
% commands which might be changed by the included file.
%    \begin{macrocode}
\let\@ltxdoc@PrintIndex\PrintIndex
\let\PrintIndex\relax
\let\@ltxdoc@PrintChanges\PrintChanges
\let\PrintChanges\relax
\let\@ltxdoc@theglossary\theglossary
\let\@ltxdoc@endtheglossary\endtheglossary
\part{\currentfile}%
  {\let\ttfamily\relax
  \xdef\filekey{\filekey, \thepart={\ttfamily\currentfile}}}%
\DocInput{\currentfile}%
\let\PrintIndex\@ltxdoc@PrintIndex
\let\PrintChanges\@ltxdoc@PrintChanges
\let\theglossary\@ltxdoc@theglossary
\let\endtheglossary\@ltxdoc@endtheglossary
\clearpage
\@writeckpt{#1}\if@filesw \immediate\closeout\@partaux \fi
\else\@nameuse{cp@#1}\fi\let\@auxout\@mainaux}
%    \end{macrocode}
%
%    \begin{macrocode}
\gdef\codeline@wrindex#1{\if@filesw
        \immediate\write\@indexfile
            {\string\indexentry{#1}%
            {\filesep\number\c@CodelineNo}}\fi}%
%    \end{macrocode}
% \end{macro}
%
%    \begin{macrocode}
\let\filesep\@empty
%    \end{macrocode}
%
% \begin{macro}{\docincludeaux}
% \changes{v2.06}{1994/03/31}{Use \cs{footnotesize} in file key.}
% \changes{v2.0k}{1994/05/21}{Use \cs{aalph}}
%    \begin{macrocode}
\def\docincludeaux{%
  \def\thepart{\aalph{part}}\def\filesep{\thepart-}%
  \let\filekey\@gobble
  \g@addto@macro\index@prologue{%
    \gdef\@oddfoot{\parbox{\textwidth}{\strut\footnotesize
       \raggedright{\bfseries File Key:} \filekey}}%
    \let\@evenfoot\@oddfoot}%
  \global\let\docincludeaux\relax
 \gdef\@oddfoot{%
   \expandafter\ifx\csname ver@\currentfile\endcsname\relax
    File \thepart: {\ttfamily\currentfile} %
   \else
    \GetFileInfo{\currentfile}%
    File \thepart: {\ttfamily\filename} %
    Date: \filedate\ %
    Version \fileversion
    \fi
    \hfill\thepage}%
 \let\@evenfoot\@oddfoot}%
%    \end{macrocode}
% \end{macro}
%
%
%    \begin{macrocode}
\def\task#1#2{}
%</class>
%    \end{macrocode}
% \Finale
%
