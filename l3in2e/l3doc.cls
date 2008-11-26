%%
%% This is file `l3doc.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% l3doc.dtx  (with options: `class')
%% 
%% 
%% EXPERIMENTAL CODE
%% 
%% Do not distribute this file without also distributing the
%% source files specified above.
%% 
%% Do not distribute a modified version of this file.
%% 
%% 
%% File: l3doc.dtx Copyright (C) 1990-2008 LaTeX3 project
%%
%% It may be distributed and/or modified under the conditions of the
%% LaTeX Project Public License (LPPL), either version 1.3c of this
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
\RequirePackage{l3names}
\let        \filenameOld        \filename
\let     \filenameextOld     \filenameext
\let        \filedateOld        \filedate
\let     \fileversionOld     \fileversion
\let \filedescriptionOld \filedescription
\GetIdInfo$Id$
          {L3 Experimental documentation class}
\ProvidesExplClass
  {\filename}{\filedate}{\fileversion}{\filedescription}
\RequirePackage{expl3}
\let        \filename        \filenameOld
\let     \filenameext     \filenameextOld
\let        \filedate        \filedateOld
\let     \fileversion     \fileversionOld
\let \filedescription \filedescriptionOld
\ExplSyntaxOff
\def\Team{%
  The \LaTeX3 Project\thanks{%
  Frank Mittelbach, Denys Duchier, Chris Rowley,
  Rainer Sch\"opf, Johannes Braams, Michael Downes,
  David Carlisle, Alan Jeffrey, Morten H\o gholm, Thomas Lotze,
  Javier Bezos, Will Robertson}}
\DeclareOption{a5paper}{\@latexerr{Option not supported}{}}
\DeclareOption{full}{\AtBeginDocument{\input{l3full.cfg}}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{ltxdoc}
\RequirePackage{color,fixltx2e,trace,url}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage{hypdoc}
\RequirePackage{underscore}
\InputIfFileExists{l3doc.cfg}
           {\typeout{*************************************^^J%
                     * Local config file l3doc.cfg used^^J%
                     *************************************}}
           {}
\renewcommand\MakePrivateLetters{%
  \makeatletter
  \catcode`\_=11\relax
  \catcode`\:=11\relax}
\CodelineNumbered
\EnableCrossrefs
\setcounter{StandardModuleDepth}{1}
\setlength   \textwidth      { 385pt }
\addtolength \marginparwidth {  30pt }
\addtolength \oddsidemargin  {  20pt }
\addtolength \evensidemargin {  20pt }
\let\@@oldlist\list
\def\list#1#2{\@@oldlist{#1}{#2\listparindent\z@}}
\setlength \parindent  { 0pt }
\setlength \itemindent { 0pt }
\setlength \parskip    { \medskipamount }
\AtBeginDocument{%
  \MakeShortVerb\"%
  \MakeShortVerb\|%
}
\newcommand\tn[1]{%
  \texttt{\bslash #1}%
  \index{TeX and LaTeX2e commands\actualchar
          \string\TeX{} and \string\LaTeXe{} commands:\levelchar
          #1\actualchar{\string\ttfamily\string\bslash{}#1}}}
\providecommand*\eTeX{%
  \if b\expandafter\@car\f@series\@nil\boldmath\fi
  $\m@th\varepsilon$-\TeX}
\let\m\meta
\let\file\url
\newcommand\Arg[1]{\texttt{\{}\,\meta{#1}\,\texttt{\}}}
\newenvironment{texnote}{%
  \endgraf
  \vspace{3mm}%
  \small\textbf{\TeX{}hackers~note:}%
}{%
  \vspace{3mm}%
}
\begingroup
\catcode`\|=\active
\catcode`\<=\active
\gdef\function{%
  \catcode`\<=\active\def<##1>{\meta{##1}}%
  \bigskip
  \begingroup
  \@makeother\\
  \catcode`\~=10
  \catcode`\ =9
  \catcode`\^^M=9
  \catcode`\^^I=9
  \catcode`\|=\active
  \@function}
\global\let\variable\function
\gdef\@function#1{%
  \ifx\@function#1\@function\else
    \funcindex#1| |%
  \fi
  \def\nextnewline{\gdef\nextnewline{\\}}
  \global\let\macroname\@empty
  \endgraf
  \ttfamily
  \noindent\hspace*{-2\parindent}%
  \tabular[b]{ @{\vline\hskip\tabcolsep}
               l @{} c
               @{\hskip\tabcolsep\vline} }%
    \hline
    \showexplmacros#1|\@nil
    \crcr
    \hline
    \noalign{\kern-2pt}%
  \endtabular
  \endgroup
}
\ExplSyntaxOn
\gdef:Npn \funcindex #1| {
  \tlist_if_blank:nTF {#1} {
    \@ifnextchar|{\@gobble}{}
  }{
    \def\yyy{#1}
    \expandafter\vindex\meaning\yyy\@nil
    \funcindex
  }
}
\ExplSyntaxOff
\gdef\showexplmacros#1|{%
  \showexplmacro#1::\@nil
  \@ifnextchar\@nil{\@gobble}{\showexplmacros}%
}
\gdef\showexplmacro#1:#2:#3\@nil{%
  \gdef\newmacroname{#1}%
  \gdef\macrosuffix{#2}%
  \parse@meta#2/\@nil
  \ifx\newmacroname\@empty
    \expandafter\@gobble
  \else
    \expandafter\@firstofone
  \fi{%
    \nextnewline
    \ifx\newmacroname\macroname
      \color[gray]{0.5}%
    \else
      \global\let\macroname\newmacroname
      \color{black}%
    \fi
    \detokenize{#1}\unskip
    \ifx\macrosuffix\@empty
      #3% in case we gobbled a : we wanted
    \else
      \color{black}:\before@slash\unskip
    \fi
    &%
    \def\@tempa{{(EXP)}}%
    \expandafter\expandafter\expandafter\in@\expandafter\@tempa\after@slash
    \ifin@
      \hspace{\tabcolsep}$\star$%
    \else
    \fi}%
}
\endgroup
\def\parse@meta#1/#2\@nil{%
  \gdef\before@slash{#1}%
  \gdef\after@slash{{#2}}}
\newenvironment{syntax}{%
  \minipage[b]{.7\textwidth}%
    \def\meta@font@select{\rmfamily\itshape} % (Will: I HATE italic cmtt!)
    \small
    \ttfamily
    \raggedright
    \obeyspaces
    \obeylines
}{%
  \endminipage
  \hfil\break
  \global\@ignoretrue
}
\newenvironment{macros}[1]{%
  \let\doc@beginmacros\@empty
  \let\doc@endmacros\@empty
  \@for\@ii:=\@empty#1\do{%
    \expandafter\macros@addto\expandafter{\@ii}%
  }%
  \doc@beginmacros
}{%
  \doc@endmacros
}
\newcommand\macros@addto[1]{%
  \g@addto@macro\doc@beginmacros{\begin{macro}{#1}}%
  \g@addto@macro\doc@endmacros{\end{macro}}%
}
\def\vindex#1>#2\@nil{%
  \edef\temp{\foo#2<>\@nil}%
  \ifx\temp\space\else
  \expandafter\SpecialMainIndexB\expandafter{\temp}\fi}
\def\foo#1<#2>#3\@nil{%
 #1\ifx\foo#3\foo
   \else#2\expandafter\foo\fi#3\@nil}
\def\foo#1<#2>#3\@nil{#1}
\def\SpecialMainIndexB#1{%
  \index{%
    \@gobble#1%
    \actualchar
    \string\verb\quotechar*\verbatimchar#1\verbatimchar
    \encapchar
    hdpgindex{\thepage}{usage}%
  }%
}
\def\hdpgindex#1#2#3{%
  \csname\ifx\\#2\\relax\else#2\fi\endcsname{%
    \hyperlink{page.#1}{#3}%
  }%
}
\newcommand{\includeltpatch}{%
  \def\currentfile{l3patch.ltx}
  \part{l3patch}
  {\let\ttfamily\relax
    \xdef\filekey{\filekey, \thepart={\ttfamily\currentfile}}}%
  Things we did wrong\ldots
  \IndexInput{l3patch.ltx}}
\def\patchdate{0}
\begingroup
   %%\def\ProvidesFile#1\fmtversion#2{\date{#2}\endinput}
   \def\ProvidesFile#1[#2#3]{\date{#2}\endinput}
   \input{l3vers.dtx}
   \xdef\@date{\@date}
   \global\let\X@date=\@date
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
   \@warning{l3patch.ltx does not match l3vers.dtx!}
   \let\includeltpatch\relax
\fi
%% 
%%
%% End of file `l3doc.cls'.
