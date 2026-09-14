\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{td}[2026/09/13 v2.0 Class used for exercise sheets and booklets]

% Options and base class

\newif\if@tdcls@livret
\@tdcls@livretfalse
\DeclareOption{livret}{\@tdcls@livrettrue}
\newcommand{\iflivret}[1]{\if@tdcls@livret#1\else\fi}
\newcommand{\ifnotlivret}[1]{\if@tdcls@livret\else#1\fi}
\newcommand{\ifelselivret}[2]{\if@tdcls@livret#1\else#2\fi}

\newif\if@tdcls@correction
\@tdcls@correctionfalse
\DeclareOption{correction}{\@tdcls@correctiontrue}
\newcommand{\ifcorrection}[1]{\if@tdcls@correction#1\else\fi}
\newcommand{\ifnotcorrection}[1]{\if@tdcls@correction\else#1\fi}
\newcommand{\ifelsecorrection}[2]{\if@tdcls@correction#1\else#2\fi}

\newif\if@tdcls@examoption
\@tdcls@examoptionfalse
\DeclareOption{examen}{\@tdcls@examoptiontrue}

\newif\if@tdcls@ccoption
\@tdcls@ccoptionfalse
\DeclareOption{cc}{\@tdcls@ccoptiontrue}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
  \PassOptionsToClass{\CurrentOption}{book}%
}

\ProcessOptions\relax

\if@tdcls@livret
\LoadClass[twoside,a4paper]{book}
\else
\LoadClass[a4paper]{article}
\fi

% Packages and tools

\RequirePackage[french]{babel}
\RequirePackage{geometry}
\RequirePackage{newtxtext}
\RequirePackage{newtxmath}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{amsmath}
\RequirePackage{xcolor}
\RequirePackage{lastpage}
\RequirePackage{needspace}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\tcbuselibrary{breakable,skins}

\definecolor{charcoal}{RGB}{28,28,28}

\ifelselivret{%
  \geometry{textwidth=16cm,inner=2.8cm,top=2.6cm,textheight=24cm}%
}{%
  \geometry{textwidth=16cm,hcentering,top=2.6cm,textheight=24cm}%
}

\newcommand\tdcls@set@short[3]{\IfNoValueTF{#2}{\gdef#1{#3}}{\gdef#1{#2}}}
\newcommand\tdcls@set@longshort[4]{\gdef#1{#4}\tdcls@set@short#2{#3}{#4}}
\newsavebox{\tdcls@ignorebox}%
\newcommand\tdcls@hide@environment[1]{%
  \newenvironment{#1}[1][]{%
    \begin{lrbox}{\tdcls@ignorebox}%
      \begin{minipage}{\textwidth}%
  }{%
      \end{minipage}%
    \end{lrbox}%
  }%
}

% Structure of the document

\newcommand\inserttitle{}
\newcommand\runningtitle{}
\RenewDocumentCommand\title{o m}{%
  \gdef\@title{#2}%
  \gdef\inserttitle{\@title}%
  \tdcls@set@short\runningtitle{#1}{#2}%
}

\newcommand\insertauthor{\@author}
\newcommand\runningauthor{}
\RenewDocumentCommand\author{o m}{%
  \gdef\@author{#2}%
  \tdcls@set@short\runningauthor{#1}{#2}%
}%

\newcommand\insertinstitution{}
\newcommand\institution[1]{
  \gdef\insertinstitution{#1}
}

\newcommand\insertlogo{}
\newcommand\logo[1]{
  \gdef\insertlogo{\includegraphics[width=\textwidth,height=25mm,keepaspectratio]{#1}}
}

\newcommand\insertcursus{}
\newcommand\runningcursus{}
\NewDocumentCommand\cursus{o m}{%
  \tdcls@set@longshort\insertcursus\runningcursus{#1}{#2}%
}

\newcommand\insertcodeUE{}
\newcommand{\codeUE}[1]{
  \gdef\insertcodeUE{#1}
}

\newcommand\insertintituleUE{}
\newcommand\runningintituleUE{}
\NewDocumentCommand\intituleUE{o m}{%
  \tdcls@set@longshort\insertintituleUE\runningintituleUE{#1}{#2}%
}

\newcommand\insertdate{%
  \ifnum\month<8
    \number\numexpr\year-1\relax/\number\year
  \else
    \number\year/\number\numexpr\year+1\relax
  \fi
}
\renewcommand{\date}[1]{
  \gdef\insertdate{#1}
}

\DeclareDocumentEnvironment{abstract}{}{%
  \vspace{-5mm}%
  \begin{center}%
    \begin{minipage}{.9\textwidth}%
      \itshape
}{%
    \end{minipage}%
  \end{center}%
}

\NewDocumentCommand{\maketitlepage}{}{%
  \newgeometry{top=2.5cm,bottom=2.5cm,left=2.5cm,right=2.5cm}%
  \begin{titlepage}
    \begin{minipage}{.4\textwidth}
      \centering
      \insertlogo
      \par
    \end{minipage}%
    \begin{minipage}{.6\textwidth}
      \raggedleft\large\bfseries\color{charcoal!70}
      \insertcodeUE\par
      \insertdate\par
      \insertinstitution\par
    \end{minipage}
    \vspace{4cm}
    \begin{center}
      \rule{\linewidth}{0.8mm}\par
      \vspace{4mm}
      {\Huge\scshape\insertintituleUE\par}
      \vspace{4mm}
      \rule{\linewidth}{0.8mm}\par
      \ifx\inserttitle\@empty\else\vspace{3mm}{\LARGE\inserttitle\par}\fi
      \ifcorrection{\vspace{4mm}\LARGE\bfseries\color{charcoal}---~\tdcls@correctionname~---\par}%
    \end{center}
    \vfill
    \begin{minipage}[b]{.6\textwidth}
      {\large\bfseries\color{charcoal!70}\insertauthor\par}%
    \end{minipage}%
    \begin{minipage}[b]{.4\textwidth}
      {\raggedleft\large\bfseries\color{charcoal!70}\insertcursus\par}%
    \end{minipage}
    \addtocounter{page}{-1}%
  \end{titlepage}%
  \restoregeometry
}

\pagestyle{fancy}
\renewcommand{\footrulewidth}{.4pt}
\renewcommand{\headrulewidth}{0pt}
\fancyhead{}
\ifelselivret{
  \fancyhead[LE]{{\small \runningtypesession\insertnumerosession}}
  \fancyhead[CE]{}
  \fancyhead[RE]{{\small \insertinstitution}}
  \fancyhead[OL]{{\small \runningcursus}}
  \fancyhead[OC]{}
  \fancyhead[OR]{{\small \runningsession}}
  \fancyfoot[LE]{{\small \thepage/\pageref{LastPage}}}
  \fancyfoot[CE]{}
  \fancyfoot[RE]{{\small \insertcodeUE}}
  \fancyfoot[OL]{{\small \runningintituleUE}}
  \fancyfoot[OC]{}
  \fancyfoot[OR]{{\small \thepage/\pageref{LastPage}}}
}{
  \if@tdcls@examoption\fancyhead[L]{{\bfseries\color{charcoal!75}Numéro d'anonymat :}}\fi
  \if@tdcls@ccoption\fancyhead[L]{{\bfseries\color{charcoal!75}Nom :\hspace{3cm}Prénom :\hspace{3cm}Numéro d'étudiant :\hspace{2cm}Groupe :}}\fi
  \fancyfoot[L]{{\footnotesize \insertcodeUE~--~\runningintituleUE}}
  \fancyfoot[C]{{\footnotesize \thepage/\pageref{LastPage}}}
  \fancyfoot[R]{{\footnotesize \runningtypesession\insertnumerosession\ifx\runningsession\@empty\else~--~\runningsession\fi}}
}

\AtBeginDocument{%
  \@ifpackageloaded{hyperref}{%
    \providecommand*{\theHtdcls@session}{\arabic{tdcls@unit}}%
    \providecommand*{\theHtdcls@exercice}{\theHtdcls@session.\arabic{tdcls@exercice}}%
  }{}%
}

% Sessions configuration

\newcounter{tdcls@nextsession}
\setcounter{tdcls@nextsession}{1}
\newcounter{tdcls@unit}

\newcommand\tdcls@currentnumerosession{}

\newif\if@tdcls@appendix
\@tdcls@appendixfalse

\newcommand\tdcls@clear@session{}
\newcommand\cleardoublepageatbeginsession{%
  \renewcommand\tdcls@clear@session{\ifodd\value{page}\null\newpage\fi}%
}
\newcommand\nocleardoublepageatbeginsession{%
  \renewcommand\tdcls@clear@session{}%
}

\newcommand\inserttypesession{Travaux Dirigés}
\newcommand\runningtypesession{TD}
\NewDocumentCommand\typesession{o m}{%
  \tdcls@set@longshort\inserttypesession\runningtypesession{#1}{#2}%
}
\if@tdcls@examoption\typesession{Examen}\fi
\if@tdcls@ccoption\typesession[CC]{Contrôle Continu}\fi

\NewDocumentCommand\numerosession{m}{%
  \setcounter{tdcls@nextsession}{#1}%
}
\NewDocumentCommand\insertnumerosession{}{%
  \ifx\tdcls@currentnumerosession\@empty\else
    ~\no~\tdcls@currentnumerosession
  \fi
}

\newcommand\insertsession{}
\newcommand\runningsession{}

\NewDocumentCommand\session{s o m}{%
  \clearpage
  \tdcls@clear@session
  \stepcounter{tdcls@unit}%
  \@tdcls@appendixfalse

  \IfBooleanTF{#1}{%
    \gdef\tdcls@currentnumerosession{}%
  }{%
    \xdef\tdcls@currentnumerosession{\thetdcls@nextsession}%
    \stepcounter{tdcls@nextsession}%
  }%

  \tdcls@set@longshort\insertsession\runningsession{#2}{#3}%
  \setcounter{tdcls@exercice}{0}%
  \tdcls@print@session
}

\newcommand\annexesession{%
  \@tdcls@appendixtrue%
  \clearpage%
  \tdcls@print@session
}

\newcommand\tdcls@print@session{%
  \begingroup
  \ifnotlivret{{
    \setlength{\parindent}{0pt}
    \large\bfseries\color{charcoal!75}
    \noindent\insertintituleUE\hfill\insertcodeUE\par%
    \noindent\insertcursus\hfill\insertdate\par%
    \noindent\hfill\insertinstitution\par%
    \vspace{2mm}
  }}
  \begin{center}%
    {%
      \Large\itshape
      \tdcls@sessionname\inserttypesession\insertnumerosession
      \if@tdcls@appendix~---~\tdcls@complementname\fi
      \par
    }{%
      \vspace{1mm}\LARGE\insertsession\par
    }{%
      \ifnotlivret{\ifcorrection{\vspace{2mm}\LARGE\bfseries\color{charcoal}---~\tdcls@correctionname~---\par}}%
    }{%
      \iflivret{\vspace{2mm}\rule{8cm}{0.4pt}\par}
    }
  \end{center}%
  \vspace{2mm}
  \endgroup
}

% Exercice environnement

\newcounter{tdcls@exercice}

\newcommand\insertexercisenumber{%
  \iflivret{%
    \ifx\tdcls@currentnumerosession\@empty\else%
      \tdcls@currentnumerosession.%
    \fi%
  }%
  \thetdcls@exercice%
}

\NewDocumentEnvironment{exercice}{o}{%
  \needspace{3\baselineskip}%
  \par\addvspace{5mm}%
  \refstepcounter{tdcls@exercice}%
  \edef\tdcls@questionprefix{\arabic{tdcls@exercice}}%
  \noindent\textbf{\color{charcoal!85}\tdcls@exercisename~\insertexercisenumber\IfNoValueTF{#1}{}{~(#1)}.}%
  \par\vspace{2mm}%
}{\par\vspace{1mm}}

% Questions environment

\newcommand\tdcls@questionprefix{}

\newlist{questions}{enumerate}{1}
\setlist[questions,1]{%
  label={\bfseries\color{charcoal!85}\tdcls@questionprefix\alph*.},
  ref={\tdcls@questionprefix\alph*},
  leftmargin=15mm,
  resume
}

\newcommand\question[1]{%
  \begin{questions}%
  \item #1%
  \end{questions}%
}

% Responses environnement

\newcommand\tdcls@draw@grade[1]{%
  \if\relax\detokenize{#1}\relax\else
  \coordinate (grade-tl) at ([xshift=-2cm]interior.north east);
  \coordinate (grade-tr) at (interior.north east);
  \coordinate (grade-br) at ([yshift=-20pt]interior.north east);
  \coordinate (grade-bl) at ([xshift=-2cm,yshift=-20pt]interior.north east);
  \path[fill=black!10] (grade-tl) -- ([xshift=-3pt]grade-tr) arc[start angle=90, end angle=0, radius=3pt]
  -- (grade-br) -- ([xshift=3pt]grade-bl) arc[start angle=-90, end angle=-180, radius=3pt] -- (grade-tl) -- cycle;
  \draw[rounded corners=3pt, thick] (grade-tl) -- (grade-bl) -- (grade-br);
  \node[anchor=east, inner xsep=3pt] at ([yshift=-10pt]interior.north east) {/ #1};
  \fi
}

\ifelsecorrection{\tdcls@hide@environment{responses}}{
  \newtcolorbox{responses}[1][]{%
    enhanced,
    breakable,
    enlargepage flexible=10pt,
    colback=white,
    colframe=black,
    boxrule=1pt,
    arc=3pt,
    boxsep=0pt,
    left=10pt,
    right=0pt,
    top=0pt,
    bottom=10pt,
    before skip=5pt,
    after skip=5pt,
    overlay unbroken and first={%
      \tdcls@draw@grade{#1}%
    }
  }
}

\newcommand\response[2][]{\begin{responses}[#1]\vspace{#2}\end{responses}}

% Correction environnement

\ifelsecorrection{%
  \newtcolorbox{corrections}{%
    enhanced,
    breakable,
    enlargepage flexible=10pt,
    colback=charcoal!5,
    colframe=charcoal!50,
    boxrule=1pt,
    arc=10pt,
    boxsep=0pt,
    left=10pt,
    right=10pt,
    top=10pt,
    bottom=10pt,
    before skip=5pt,
    after skip=5pt
  }%
}{\tdcls@hide@environment{corrections}}

\newcommand\correction[1]{\begin{corrections}#1\end{corrections}}

% Texts

\newcommand\tdcls@sessionname{Séance de }
\newcommand\tdcls@exercisename{Exercice}
\newcommand\tdcls@correctionname{CORRECTION}
\newcommand\tdcls@complementname{pour aller plus loin}

%\let\response\reponse
%\let\responses\reponses
%\let\endresponses\endreponses

\endinput
