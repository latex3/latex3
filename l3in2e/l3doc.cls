
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{l3doc}
     [1998/04/12 v0.0c class for documenting experimental stuff]

\DeclareOption*{\PassOptionstoClass{\CurrentOption}{article}}

\ProcessOptions

\LoadClass{article}
\RequirePackage{doc}

\RequirePackage[T1]{fontenc}

%% The Guilty Parties
\def\Team{%
  The \LaTeX3 Project\thanks{%
  Frank Mittelbach, Denys Duchier, Chris Rowley,
  Rainer Sch\"opf, Johannes Braams, Michael Downes,
  David Carlisle, Alan Jeffrey}}

%% You do not want to look at the mess below this line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\catcode`\_=11

\MakeShortVerb\"
\MakeShortVerb\|

\newcommand{\tn}[1]{{\tt\bslash #1}%
   \index{ \actualchar\string\TeX{} and \string\LaTeX2.09 commands:\levelchar
          #1\actualchar{\string\tt\string\bslash{}#1}}}



\def\vindex#1>#2\@nil{%
  \edef\temp{\foo#2<>\@nil}%
  \ifx\temp\space\else
  \expandafter\SpecialMainIndexB\expandafter{\temp}\fi}

% Cant remember why I switched from \SpecialMainIndexB
\gdef\SpecialMainIndexB#1{\index{\@gobble#1\space\actualchar{\string\verb+#1+}}}

% remove <foo> from index (quick hack, could be better)
\def\foo#1<#2>#3\@nil{%
 #1\ifx\foo#3\foo
   \else#2\expandafter\foo\fi#3\@nil}
\def\foo#1<#2>#3\@nil{#1<#2>#3}

\let\m\meta
\newenvironment{texnote}%
   {\endgraf\vspace{3mm}{\bf \TeX{}hackers~ note:}\small}
    {\vspace{3mm}}
% stick the function names in a box.
{\catcode`\|=\active\catcode`\<=\active

% index fuction lists (could be better...)
\gdef\funcindex#1 |{%
  \def\yyy{#1}%
  \ifx\yyy\empty\else
    \expandafter\vindex\meaning\yyy\@nil
    \expandafter\funcindex\fi}

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
    \funcindex#1 | |%
  \fi
  \tt
  \endgraf
  \noindent\hspace*{-2\parindent}%
  \tabular[b]%
     {@{\vline\hskip\tabcolsep}l@{\hskip\tabcolsep\vline}}
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
 
