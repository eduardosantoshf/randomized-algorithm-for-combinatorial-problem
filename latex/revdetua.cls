%% 
%% This is file `revdetua.cls'
%%
%% Created by Tomás Oliveira e Silva on March 1996 (current version, January 2012)
%%
%% Based on article.cls, and the old ieeetran.sty
%% 
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{revdetua}[2012/09/17 v1.3l revdetua document class]
\usepackage[english,portuguese]{babel}
\usepackage{url}

\setlength\paperheight{297mm}
\setlength\paperwidth {210mm}
\newcommand\@ptsize{0}
\@twosidetrue\@mparswitchtrue
\@twocolumntrue

\newif\ifportugues
\DeclareOption{portugues}{\portuguestrue}
\DeclareOption{english}{\portuguesfalse}

\newif\iftimes\timesfalse
\DeclareOption{times}{\timestrue}

\newif\ifmirror\mirrorfalse
\DeclareOption{mirror}{\mirrortrue}

\newif\iflongpaper\longpaperfalse
\DeclareOption{longpaper}{\longpapertrue}
\DeclareOption{shortpaper}{\longpaperfalse}

\newif\iffinal
\DeclareOption{draft}{\finalfalse}
\DeclareOption{final}{\finaltrue}

\newif\ifdisplaylabels\displaylabelsfalse
\DeclareOption{invisiblelabels}{\displaylabelsfalse}
\DeclareOption{visiblelabels}{\displaylabelstrue}

\newif\ifannotations\annotationsfalse
\DeclareOption{annotations}{\annotationstrue}

\ExecuteOptions{final,english}
\ProcessOptions

\ifmirror
  \special{! userdict begin /bop-hook { 595 0 translate -1 1 scale } def end}
\fi

\iffinal
  \setlength\overfullrule{0pt}
\else
  \setlength\overfullrule{5pt}
\fi
\iftimes
  \usepackage{times}
\fi
\iffinal\iftimes\else
  \typeout{* Please use the times option in the final version *}
\fi\ifdisplaylabels
  \typeout{* Please do not use the visiblelabels option in the final version *}
\fi\fi

\ifannotations
  \usepackage[dvips]{color}
\fi

\usepackage{cite}
\def\citepunct{], [}
%%% From v3.8 cite.sty ( to replace -- by ]-[ )
\def\@compress@cite#1{%  % This is executed for each number
  \advance\@tempcnta\@ne % Now \@tempcnta is one more than the previous number
  \ifnum #1=\@tempcnta   % Number follows previous--hold on to it
     \ifx\@h@ld\relax    % first pair of successives
        \edef\@h@ld{\@citea \noexpand\citeform{#1}}%
     \else               % compressible list of successives
%       \def\@h@ld{\hbox{--}\penalty\@m \citeform{#1}}%
        \def\@h@ld{]\hbox{-}\penalty\@m[\citeform{#1}}%
     \fi % (using \hbox avoids easy \exhyphenpenalty breaks)
  \else   %  non-successor -- dump what's held and do this one
     \@h@ld \@citea \citeform{#1}\let\@h@ld\relax
  \fi \@tempcnta#1\let\@citea\citepunct
}
%%% From v3.8 cite.sty ( to avoid ordering the reference numbers )
\begingroup \catcode`\_=8 % Just in case it was changed
\toks@={
\def\@make@cite@list{%
 \expandafter\let \expandafter\@B@citeB
          \csname b@\@citeb\@extra@b@citeb \endcsname
 \ifx\@B@citeB\relax % undefined: output ? and warning
    \@citea {\bf{?}}\let\@citea\citepunct \G@refundefinedtrue
    \@warning {Citation `\@citeb' on page \thepage\space undefined}%
    \oc@verbo \global\@namedef{b@\@citeb\@extra@b@citeb}{?}%
 \else %  defined               % remove previous line to repeat warnings
    \ifcat _\ifnum\z@<0\@B@citeB _\else A\fi % a positive number, put in list
       \@tempcnta\@B@citeB \relax
%      \ifnum \@tempcnta>\@tempcntb % new highest, add to end (efficiently)
          \edef\@cite@list{\@cite@list \@celt{\@B@citeB}}%
          \@tempcntb\@tempcnta
%      \else % arbitrary number: insert appropriately
%         \edef\@cite@list{\expandafter\@sort@celt \@cite@list \@gobble @}%
%      \fi
    \else % citation is not a number, output immediately
       \@citea \citeform{\@B@citeB}%
       \let\@citea\citepunct
 \fi\fi}
}
\expandafter \endgroup \the\toks@  % restore _ catcode
%%% From v3.9 cite.sty ( for new versions of babel.def and old versions of cite.sty)
\@ifundefined{bbl@cite@choice}{}{\@ifundefined{org@@citex}{}%
  {\let\org@@citex\@citex}}% Prevent stomping by babel


%% Start of modified size10.clo
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt{11.9}%
   \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\normalsize
\newcommand\Small{% Special font for the abstract
   \@setfontsize\Small\@ixpt{11.9}%
   \abovedisplayskip 9\p@ \@plus3\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 5\p@ \@plus2\p@ \@minus2\p@
   \belowdisplayskip \abovedisplayskip
   \let\@listi\@listI}
\newcommand\small{%
   \@setfontsize\small\@viiipt{9.2}%
   \abovedisplayskip 8\p@ \@plus3\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus2\p@
   \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 4\p@ \@plus2\p@ \@minus2\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\footnotesize{%
   \@setfontsize\footnotesize\@viiipt{8.8}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
   \def\@listi{\leftmargin\leftmargini
               \topsep 3\p@ \@plus\p@ \@minus\p@
               \parsep 2\p@ \@plus\p@ \@minus\p@
               \itemsep \parsep}%
   \belowdisplayskip \abovedisplayskip
}
\newcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand\Tiny{\@setfontsize\Tiny\@vipt{9.2}}% Special font for the header
\newcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\newcommand\large{\@setfontsize\large\@xiipt{14}}
\newcommand\Large{\@setfontsize\Large\@xivpt{18}}
\newcommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
\newcommand\huge{\@setfontsize\huge\@xxpt{22}}
\newcommand\Huge{\@setfontsize\Huge\@xxvpt{28}}
\setlength\parindent{1.2mm}
\setlength\headheight{12\p@}
\setlength\headsep{9mm}
\setlength\topskip{10\p@}
\setlength\footskip{4mm}
\setlength\maxdepth{4\p@}
\setlength\@maxdepth\maxdepth
\setlength\columnseprule{0pt}
\ifdisplaylabels
  \setlength\textwidth{178mm}
  \setlength\columnsep{12mm}
  \setlength\oddsidemargin{-9.4mm}
  \setlength\evensidemargin{-9.4mm}
\else
  \setlength\textwidth{174mm}
  \setlength\columnsep{8mm}
  \iffinal
    \setlength\oddsidemargin{2mm}
    \setlength\evensidemargin{-16.8mm}
  \else
    \setlength\oddsidemargin{-7.4mm}
    \setlength\evensidemargin{-7.4mm}
  \fi
\fi
\setlength\textheight{246mm}
\addtolength\textheight{\topskip}
\setlength\marginparsep{10\p@}
\setlength\marginparpush{5\p@}
\setlength\marginparwidth{20\p@}
\ifannotations
  \setlength\topmargin{-20mm}
\else
  \setlength\topmargin{-15mm}
\fi
\setlength\footnotesep{7\p@}
\setlength{\skip\footins}{10\p@ \@plus 4\p@ \@minus 2\p@}
\setlength\floatsep{12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\textfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep{12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dblfloatsep{12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\setlength\partopsep{\z@}
\setlength\itemindent{-1em}
\setlength\parsep{\z@}
\setlength\topsep{1.3ex}
\setlength\itemsep{\z@}
\def\@listI{\leftmargin\leftmargini} \@listI
\def\@listi{\leftmargin\leftmargini
              \topsep \z@ \@plus 1\p@ \@minus 1\p@}
\def\@listii{\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \topsep \z@}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \topsep \z@}
\def\@listiv{\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep
              \topsep \z@}
\def\@listv{\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep
              \topsep \z@}
\def\@listvi{\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep
              \topsep \z@}
%% End of modified size10.clo
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{3}
\renewcommand\topfraction{0.9}
\setcounter{bottomnumber}{2}
\renewcommand\bottomfraction{.9}
\setcounter{totalnumber}{5}
\renewcommand\textfraction{.1}
\renewcommand\floatpagefraction{.9}
\setcounter{dbltopnumber}{4}
\renewcommand\dbltopfraction{1.0}
\renewcommand\dblfloatpagefraction{.9}
\let\@mkboth\@gobbletwo
\iflongpaper
 \let\partmark\@gobble
\fi
\let\sectionmark\@gobble
\let\subsectionmark\@gobble
\def\lrmark{}
\def\pagemark{\thepage}
\def\ps@headings{%
    \ifannotations%
        \def\@oddfoot{\smash{\rlap{\parbox[t]{83mm}{\color{blue}\footnotesize\LeftAnnotationText}%
                      \kern\columnsep\parbox[t]{83mm}{\color{blue}\footnotesize\RightAnnotationText}}}\hss%
                      \global\def\LeftAnnotationText{\ }\global\def\RightAnnotationText{\ }}%
        \let\@evenfoot\@oddfoot%
    \else
        \let\@oddfoot\@empty\let\@evenfoot\@empty%
    \fi%
    \def\@oddhead{\hbox{}\small{\lrmark}\hfil\pagemark}%
    \def\@evenhead{\small\pagemark\hfil{\lrmark}\hbox{}}}
\ifannotations%
    \def\LeftAnnotationText{\ }%
    \def\RightAnnotationText{\ }%
\fi
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \ifnum \col@number=\@ne
      \@maketitle
    \else
      \twocolumn[\@maketitle]%
    \fi
    \global\@topnum\z@ % Prevents figures from going at top of page.
    \thispagestyle{headings}\@thanks
    \ifportugues
      \bibliographystyle{p-revdetua}
    \else
      \bibliographystyle{e-revdetua}
    \fi
  \endgroup
  \setcounter{footnote}{0}%
  \let\thanks\relax
  \let\maketitle\relax\let\@maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}}
\def\@maketitle{\newpage\begin{center}%
    \vskip 0.5em{\Large\bfseries\boldmath\@title\par}%
    \vskip2.7em{\lineskip.5em\large\rmfamily
    \begin{tabular}[t]{c}%
      \@author
    \end{tabular}\par}%
  \end{center}\par\vskip 2.7em}% was 3.1em without the tabular environment
\setcounter{secnumdepth}{3}
\iflongpaper
 \newcounter{part}
\fi
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\iflongpaper
 \renewcommand\thepart         {\@arabic\c@part}
\fi
\renewcommand\thesection       {\@Roman\c@section}
\renewcommand\thesubsection    {\thesection-\@Alph\c@subsection}
\renewcommand\thesubsubsection {\thesubsection.\@arabic\c@subsubsection}
\newcommand\thesubsubsectiondis{\@Alph\c@subsection.\@arabic\c@subsubsection}

\iflongpaper\else\def\addcontentsline#1#2#3{}\fi
\def\@punct{.\ \ } % Punctuation after run-in section heading
\def\@sect#1#2#3#4#5#6[#7]#8{%
     \ifnum #2>\c@secnumdepth
       \let\@svsec\@empty\else
       \refstepcounter{#1}%
       \protected@edef\@svsec{\ifnum #2=0Part~\arabic{#1}:\fi
                              \ifnum #2=1\Roman{#1}.\fi
                              \ifnum #2=2\Alph{#1}.\fi
                              \ifnum #2>2{\csname the#1dis\endcsname}\fi
                              \hskip .5em\relax}%
     \fi
     \@tempskipa #5\relax
      \ifdim \@tempskipa>\z@
        \begingroup #6\relax
          \@hangfrom{\hskip #3\relax\@svsec}%
                    {\interlinepenalty \@M #8\par}%
        \endgroup
       \csname #1mark\endcsname{#7}%
       \addcontentsline{toc}{#1}{%
         \ifnum #2>\c@secnumdepth \else
           \protect\numberline{\csname the#1\endcsname}%
         \fi
         #7}%
      \else
        \def\@svsechd{#6\hskip #3\relax
                   \@svsec #8\@punct\csname #1mark\endcsname{#7}%
          \addcontentsline{toc}{#1}{%
            \ifnum #2>\c@secnumdepth \else
              \protect\numberline{\csname the#1\endcsname}%
            \fi
           #7}}%
     \fi
     \@xsect{#5}}

\def\@ssect#1#2#3#4#5{\@tempskipa #3\relax
   \ifdim \@tempskipa>\z@
     \begingroup #4\@hangfrom{\hskip #1}{\interlinepenalty \@M #5\par}%
     \endgroup
   \else \def\@svsechd{#4\hskip #1\relax #5\@punct}\fi
    \@xsect{#3}}

\iflongpaper
 \newcommand\part{\@startsection{part}{0}{\z@}%
                                {3.0ex \@plus .7ex \@minus .3ex}%
                                {1.5ex \@plus .3ex}%
                                {\centering\normalfont\bfseries}}
\fi
\newcommand\section{\@startsection{section}{1}{\z@}%
                                  {2.0ex \@plus .5ex \@minus .2ex}%
                                  {1.0ex \@plus .2ex}%
                                  {\centering\normalfont\scshape}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {2.0ex \@plus .5ex \@minus .2ex}%
                                     {1.0ex \@plus .2ex}%
                                     {\normalfont\itshape}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                        {2.0ex \@plus .5ex \@minus .2ex}%
                                        {1.0ex \@plus .2ex}%
                                        {\normalfont\itshape}}%\rmfamily

\iflongpaper
 \newcommand\@pnumwidth{2.0em}
 \newcommand\@tocrmarg{2.0em}
 \newcommand\@dotsep{4.5}
 \setcounter{tocdepth}{1}
 \newcommand\tableofcontents{\section*{\contentsname}%
                             \small\@starttoc{toc}\normalsize
                             \addcontentsline{toc}{section}{\contentsname}}
 \newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{1.5pt \@plus\p@}%
    \begingroup
      \setlength\@tempdima{1.2em}%
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode
      \advance\leftskip\@tempdima
      \hskip -\leftskip\bfseries
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
    \endgroup
  \fi}
 \newcommand*\l@section{\@dottedtocline{1}{1.2em}{2.6em}}
 \newcommand*\l@subsection{\@dottedtocline{2}{2.4em}{3.2em}}
 \newcommand*\l@subsubsection{\@dottedtocline{3}{3.6em}{3.8em}}
\fi

\setlength\leftmargini  {2em}
\setlength\leftmarginii  {1em}
\setlength\leftmarginiii {1.5em}
\setlength\leftmarginiv  {1.5em}
\setlength\leftmarginv  {1em}
\setlength\leftmarginvi {1em}
\setlength\leftmargin    {\leftmargini}
\setlength  \labelsep  {5pt}
\setlength  \labelwidth{\z@}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{$\m@th\bullet$}
\newcommand\labelitemii{\normalfont\bfseries --}
\newcommand\labelitemiii{$\m@th\ast$}
\newcommand\labelitemiv{$\m@th\cdot$}
\newdimen\tmpitemindent
\renewcommand\@mklab[1]{#1}
\def\enumerate{\tmpitemindent\itemindent
  \ifnum \@enumdepth >\thr@@\@toodeep\else
    \advance\@enumdepth\@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
      \list
        {\csname label\@enumctr\endcsname}%
        {\itemindent\tmpitemindent
         \usecounter\@enumctr\def\makelabel##1{\hspace\labelsep\hfil{##1}}}%
  \fi}
\def\endenumerate{\endlist\par}
\def\itemize{\tmpitemindent\itemindent
  \ifnum \@itemdepth >\thr@@\@toodeep\else
    \advance\@itemdepth\@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \list
      {\csname\@itemitem\endcsname}%
      {\itemindent\tmpitemindent
       \def\makelabel##1{\hspace\labelsep\hfil\itshape{##1}}}%
  \fi}
\def\enditemize{\endlist\par}
\newenvironment{description}
               {\tmpitemindent\itemindent
                \list{}{\itemindent\tmpitemindent
                        \labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist\par}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\itshape #1}

\def\revdetua@language{\ifportugues\selectlanguage{portuguese}\else\selectlanguage{english}\fi}
\newenvironment{abstract}{\begingroup
   \selectlanguage{english}%
   \Small\rmfamily\bfseries{\itshape\abstractname\/} --\boldmath}
   {\vspace{0.6em}\par\endgroup}
\newenvironment{resumo}{\begingroup
   \selectlanguage{portuguese}%
   \Small\rmfamily\bfseries{\itshape\resumoname\/} --\boldmath}
   {\vspace{0.6em}\par\endgroup}
\newenvironment{keywords}{\vspace{-.3em}\begingroup
   \selectlanguage{english}%
   \Small\rmfamily\bfseries{\itshape\keywordsname\/} --\boldmath}
   {\vspace{0.6em}\par\endgroup}
\newenvironment{palavraschave}{\vspace{-.3em}\begingroup
   \selectlanguage{portuguese}%
   \Small\rmfamily\bfseries{\itshape\palavraschavename\/} --\boldmath}
   {\vspace{0.6em}\par\endgroup}

\newenvironment{verse}
               {\let\\=\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item[]}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item[]}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item[]}
               {\endlist}
\newcommand\appendix{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \renewcommand\thesection{\@Alph\c@section}%
  \section*{\appendixname}}
\newcommand\appendices{\par
  \setcounter{section}{0}%
  \setcounter{subsection}{0}%
  \renewcommand\thesection{\@Alph\c@section}%
  \section*{\appendicesname}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand\theequation{\@arabic\c@equation}
\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename~\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand\thetable{\@Roman\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename~\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{5\p@} %Warning: non-standard meaning
\setlength\belowcaptionskip{8\p@} %Warning: non-standard meaning
\long\def\@caption#1[#2]#3{\par \begingroup \@parboxrestore \normalsize
     \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}{#1}\par
   \endgroup}
%\def\tablestring{table}
\def\figurestring{figure}
\long\def\@makecaption#1#2#3{%
  \ifx\figurestring#3
    \vskip\abovecaptionskip
    \sbox\@tempboxa{\small #1 - #2}%
    \ifdim \wd\@tempboxa >\hsize
      \small #1 - #2 \par
    \else
      \global \@minipagefalse
      \hb@xt@\hsize{\small\hfil\box\@tempboxa\hfil}%
    \fi
  \else
    \begin{center}\small
      #1 \\[2pt] \scshape{#2}
    \end{center}
    \vskip\belowcaptionskip
  \fi}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch{\relax}{\mathcal}}
\DeclareRobustCommand*\mit{\@fontswitch{\relax}{\mathnormal}}
\newdimen\bibindent
\bibindent=1.5em
\newenvironment{thebibliography}[1]
     {\section*{\refname}\small
      \addcontentsline{toc}{section}{\refname}%
      \list{\@biblabel{\@arabic\c@enumiv}\hfill}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep \itemsep 0pt plus .5pt
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \renewcommand\newblock{\hskip .11em \@plus.33em \@minus.07em}%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \hbadness=10000%
      \sfcode`\.=\@m\iflongpaper\else\baselineskip=11.9pt\fi\relax}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{}
\renewcommand\footnoterule{}
\long\def\@makefntext#1{%
    \parindent 0.8em%
    \indent\@makefnmark #1}

%%\Header{Volume}{Number}{Month}{Year}{Page}
\def\@Hs#1{{\Tiny #1}}
\def\@Hu#1#2.{\uppercase{#1}\@Hs{\uppercase{#2}}}
\def\Publication{R\@Hs{EVISTA} \@Hs{DO} DETUA}
\def\Header#1#2#3#4#5{\global\def\lrmark{\Publication,
V\@Hs{OL}. #1, N$^\circ$ #2, \@Hu #3. #4}\setcounter{page}{#5}}

\def\QED{\mbox{\rule[0pt]{1.5ex}{1.5ex}}}
\def\proof{\noindent\hspace{2em}{\normalfont\itshape Proof: }}
\def\endproof{\hspace*{\fill}~\QED\par\endtrivlist\unskip}
\def\@begintheorem#1#2{\tmpitemindent\itemindent
    \topsep 0pt\normalfont\rmfamily\trivlist
    \item[\hskip \labelsep{\indent\itshape #1\ #2:}]%
    \itemindent\tmpitemindent}
\def\@opargbegintheorem#1#2#3{\tmpitemindent\itemindent
    \topsep 0pt\normalfont\rmfamily\trivlist
    \item[\hskip\labelsep{\indent\itshape #1\ #2\ \rmfamily(#3)}]%
    \itemindent\tmpitemindent}
\def\@endtheorem{\endtrivlist\unskip}

\newcommand\abstractname{Abstract}
\newcommand\resumoname{Resumo}
\newcommand\keywordsname{Keywords}
\newcommand\palavraschavename{Palavras chave}

\ifportugues
  \AtBeginDocument{\selectlanguage{portuguese}
  \def\contentname{\'\Indice}
  \def\refname{Bibliografia}
  \def\figurename{Fig.}%{Figure}
  \def\tablename{TABELA}%{Table}
  \def\appendixname{Ap\^endice}
  \def\appendicesname{Ap\^endices}
  \def\today{\number\day\space de \ifcase\month\or
    Janeiro\or Fevereiro\or Mar\c co\or Abril\or Maio\or Junho\or
    Julho\or Agosto\or Setembro\or Outubro\or Novembro\or Dezembro\fi
    \space de \number\year}}
\else
  \AtBeginDocument{\selectlanguage{english}
  \def\contentname{Contents}
  \def\refname{References}
  \def\figurename{Fig.}%{Figure}
  \def\tablename{TABLE}%{Table}
  \def\appendixname{Appendix}
  \def\appendicesname{Appendices}
  \def\today{\ifcase\month\or
    January\or February\or March\or April\or May\or June\or
    July\or August\or September\or October\or November\or December\fi
    \space\number\day, \number\year}}
\fi

\pagestyle{headings}
\pagenumbering{arabic}
\twocolumn
\sloppy
\flushbottom
%%
%% Labels
%%
\AtBeginDocument{\let\revdetua@tag=\tagform@
  \def\tagform@#1{\revdetua@tag#1\rlap{\tiny\ \revdetua@key}\gdef\revdetua@key{\relax}}
  \gdef\revdetua@key{\relax}}
\def\SL#1{\relax\label{s:#1}\vspace*{-1.5\baselineskip}%
  \rlap{\kern\linewidth{\tiny\ \ifdisplaylabels s:#1\fi}}\vspace*{0.5\baselineskip}}
\def\EL#1{\relax\label{e:#1}\ifdisplaylabels\gdef\revdetua@key{e:#1}\fi}
\def\FL#1{\relax\label{f:#1}\vspace*{-1.2\baselineskip}%
  \rlap{\kern\linewidth{\tiny\ \ifdisplaylabels f:#1\fi}}\vspace*{0.2\baselineskip}}
\def\SN#1{\ref{s:#1}}
\def\SP#1{\pageref{s:#1}}
\def\EN#1{(\ref{e:#1})}
\def\EP#1{\pageref{e:#1}}
\def\FN#1{\ref{f:#1}}   
\def\FP#1{\pageref{f:#1}}
%%
%% That's it!
%%
\endinput
