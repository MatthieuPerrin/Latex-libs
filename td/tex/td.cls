\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{td}[2026/09/13 v2.0 Class used for exercise sheets and booklets]

% Options and base class

\newif\if@tdcls@livret
\@tdcls@livretfalse
\DeclareOption{livret}{\@tdcls@livrettrue}
\providecommand\iflivret[1]{\if@tdcls@livret#1\else\fi}
\providecommand\ifnotlivret[1]{\if@tdcls@livret\else#1\fi}
\providecommand\ifelselivret[2]{\if@tdcls@livret#1\else#2\fi}

\newif\if@tdcls@reponse
\@tdcls@reponsefalse
\DeclareOption{reponse}{\@tdcls@reponsetrue}
\providecommand\ifreponse[1]{\if@tdcls@reponse#1\else\fi}
\providecommand\ifnotreponse[1]{\if@tdcls@reponse\else#1\fi}
\providecommand\ifelsereponse[2]{\if@tdcls@reponse#1\else#2\fi}

\newif\if@tdcls@correction
\@tdcls@correctionfalse
\DeclareOption{correction}{\@tdcls@reponsefalse\@tdcls@correctiontrue}
\providecommand\ifcorrection[1]{\if@tdcls@correction#1\else\fi}
\providecommand\ifnotcorrection[1]{\if@tdcls@correction\else#1\fi}
\providecommand\ifelsecorrection[2]{\if@tdcls@correction#1\else#2\fi}

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
\RequirePackage{etoolbox}
\RequirePackage{xfp}
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
\tcbset{%
  tdcls minimum height/.code={%
    \ifblank{#1}{}{%
      \tcbset{height from={#1} to \textheight}%
    }%
  }%
}

% Structure of the document

\providecommand\inserttitle{}
\providecommand\runningtitle{}
\RenewDocumentCommand\title{o m}{%
  \gdef\@title{#2}%
  \gdef\inserttitle{\@title}%
  \tdcls@set@short\runningtitle{#1}{#2}%
}

\providecommand\insertauthor{\@author}
\providecommand\runningauthor{}
\RenewDocumentCommand\author{o m}{%
  \gdef\@author{#2}%
  \tdcls@set@short\runningauthor{#1}{#2}%
}%

\providecommand\insertinstitution{}
\providecommand\institution[1]{
  \gdef\insertinstitution{#1}
}

\providecommand\insertlogo{}
\providecommand\logo[1]{
  \gdef\insertlogo{\includegraphics[width=\textwidth,height=25mm,keepaspectratio]{#1}}
}

\providecommand\insertcursus{}
\providecommand\runningcursus{}
\NewDocumentCommand\cursus{o m}{%
  \tdcls@set@longshort\insertcursus\runningcursus{#1}{#2}%
}

\providecommand\insertcodeUE{}
\providecommand{\codeUE}[1]{
  \gdef\insertcodeUE{#1}
}

\providecommand\insertintituleUE{}
\providecommand\runningintituleUE{}
\NewDocumentCommand\intituleUE{o m}{%
  \tdcls@set@longshort\insertintituleUE\runningintituleUE{#1}{#2}%
}

\providecommand\insertdate{%
  \ifnum\month<8
    \number\numexpr\year-1\relax/\number\year
  \else
    \number\year/\number\numexpr\year+1\relax
  \fi
}
\renewcommand\date[1]{
  \gdef\insertdate{#1}
}

\DeclareDocumentEnvironment{abstract}{}{%
  \vspace{2mm}%
  \begin{center}%
    \begin{minipage}{.9\textwidth}%
      \itshape
}{%
    \end{minipage}%
  \end{center}%
}

\NewDocumentCommand\maketitlepage{}{%
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
\renewcommand\footrulewidth{.4pt}
\renewcommand\headrulewidth{0pt}
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
    \newcommand*{\theHtdcls@session}{\arabic{tdcls@unit}}%
    \newcommand*{\theHtdcls@exercice}{\theHtdcls@session.\arabic{tdcls@exercice}}%
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
\providecommand\cleardoublepageatbeginsession{%
  \renewcommand\tdcls@clear@session{\ifodd\value{page}\null\newpage\fi}%
}
\providecommand\nocleardoublepageatbeginsession{%
  \renewcommand\tdcls@clear@session{}%
}

\providecommand\inserttypesession{Séance de Travaux Dirigés}
\providecommand\runningtypesession{TD}
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

\providecommand\insertsession{}
\providecommand\runningsession{}

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

\providecommand\annexesession{%
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
      \inserttypesession\insertnumerosession
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

% Bareme command

\newcommand\tdcls@pendinggrades{}
\newcommand\tdcls@exercisegrades{}
\newcommand\tdcls@currentgrade{}
\newcommand\tdcls@totalgrade{}

\newcounter{tdcls@gradeindex}
\newcounter{tdcls@gradecursor}
\newcounter{tdcls@gradecount}

\NewDocumentCommand\bareme{m}{%
  \gdef\tdcls@pendinggrades{#1}%
}

\newcommand\tdcls@grading@add[1]{%
  \stepcounter{tdcls@gradecount}%
  \xdef\tdcls@totalgrade{%
    \fpeval{\tdcls@totalgrade+(#1)}%
  }%
}

\newcommand\tdcls@grading@select[1]{%
  \stepcounter{tdcls@gradecursor}%
  \ifnum\value{tdcls@gradecursor}=\value{tdcls@gradeindex}%
    \gdef\tdcls@currentgrade{#1}%
    \listbreak
  \fi
}

\newcommand\tdcls@grading@begin{%
  \global\let\tdcls@exercisegrades\tdcls@pendinggrades
  \global\let\tdcls@pendinggrades\@empty
  \setcounter{tdcls@gradeindex}{0}%
  \setcounter{tdcls@gradecount}{0}%
  \gdef\tdcls@currentgrade{}%
  \gdef\tdcls@totalgrade{}%
  \ifdefempty{\tdcls@exercisegrades}{}{%
    \gdef\tdcls@totalgrade{0}%
    \begingroup
      \let\do\tdcls@grading@add
      \expandafter\docsvlist\expandafter{%
        \tdcls@exercisegrades
      }%
    \endgroup
  }%
}

\newcommand\tdcls@grading@nextquestion{%
  \gdef\tdcls@currentgrade{}%
  \ifdefempty{\tdcls@exercisegrades}{}{%
    \stepcounter{tdcls@gradeindex}%
    \setcounter{tdcls@gradecursor}{0}%
    \begingroup
      \let\do\tdcls@grading@select
      \expandafter\docsvlist\expandafter{%
        \tdcls@exercisegrades
      }%
    \endgroup
  }%
}

\newcommand\tdcls@grading@end{%
  \ifdefempty{\tdcls@exercisegrades}{}{%
    \ifnum\value{tdcls@gradeindex}=\value{tdcls@gradecount}%
    \else\ClassWarning{td}{%
      Bareme incoherent:
      \space\arabic{tdcls@gradecount} notes
      pour \arabic{tdcls@gradeindex} questions%
    }\fi
  }%
  \gdef\tdcls@exercisegrades{}%
  \gdef\tdcls@currentgrade{}%
  \gdef\tdcls@totalgrade{}%
}

\newcommand\tdcls@grading@ifactive[2]{%
  \ifdefempty{\tdcls@exercisegrades}{#2}{#1}%
}

\newcommand\tdcls@grading@ifcurrent[2]{%
  \ifdefempty{\tdcls@currentgrade}{#2}{#1}%
}

\newcommand\tdcls@draw@grade{%
  \tdcls@grading@ifcurrent{%
    \coordinate (grade-tl) at ([xshift=-2cm]interior.north east);
    \coordinate (grade-tr) at (interior.north east);
    \coordinate (grade-br) at ([yshift=-20pt]interior.north east);
    \coordinate (grade-bl) at ([xshift=-2cm,yshift=-20pt]interior.north east);
    \path[fill=black!10] (grade-tl) -- ([xshift=-5pt]grade-tr) arc[start angle=90, end angle=0, radius=5pt]
    -- (grade-br) -- ([xshift=5pt]grade-bl) arc[start angle=-90, end angle=-180, radius=5pt] -- (grade-tl) -- cycle;
    \draw[charcoal!75, rounded corners=5pt, thick] (grade-tl) -- (grade-bl) -- (grade-br);
    \node[anchor=east, inner xsep=3pt] at ([yshift=-10pt]interior.north east) {/ \tdcls@currentgrade};
  }{}%
}

\newcommand\tdcls@draw@exercisegrade{%
  \tdcls@grading@ifactive{\nobreak\hfill%
    \begin{tikzpicture}[baseline=(grade.base)]
    \draw[charcoal!75, fill=black!10, rounded corners=5pt] (0,0) rectangle (2cm,20pt);
    \node[anchor=east, inner xsep=3pt] (grade) at (2cm,10pt) {/ \tdcls@totalgrade};
    \end{tikzpicture}%
  }{}
}

% Exercice environnement

\newcounter{tdcls@exercice}

\providecommand\insertexercisenumber{%
  \iflivret{%
    \ifx\tdcls@currentnumerosession\@empty\else%
      \tdcls@currentnumerosession.%
    \fi%
  }%
  \thetdcls@exercice%
}

\NewDocumentEnvironment{exercice}{o}{%
  \tdcls@grading@begin
  \needspace{3\baselineskip}%
  \par\addvspace{5mm}%
  \refstepcounter{tdcls@exercice}%
  \edef\tdcls@questionprefix{\arabic{tdcls@exercice}}%
  \noindent\textbf{\color{charcoal!85}\tdcls@exercisename~\insertexercisenumber\IfNoValueTF{#1}{}{~(#1)}.}%
  \tdcls@draw@exercisegrade%
  \par\vspace{2mm}%
}{%
  \tdcls@grading@end
  \par\vspace{1mm}%
}

% Questions environment

\newcommand\tdcls@questionprefix{}

\newlist{questions}{enumerate}{1}

\setlist[questions,1]{%
  label={\bfseries\color{charcoal!85}\tdcls@questionprefix\alph*.},
  ref={\tdcls@questionprefix\alph*},
  leftmargin=15mm,
  resume,
  before={%
    \let\tdcls@original@item\item
    \def\item{%
      \ifdefstring{\@currenvir}{questions}{%
        \tdcls@grading@nextquestion
      }{}%
      \tdcls@original@item
    }%
  }
}

\providecommand\question[1]{%
  \begin{questions}%
  \item #1%
  \end{questions}%
}

% Reponses environnement

\ifelsereponse{
  \newtcolorbox{reponses}[1][]{%
    enhanced,
    breakable,
    enlargepage flexible=10pt,
    colback=white,
    colframe=charcoal!75,
    boxrule=1pt,
    arc=5pt,
    boxsep=0pt,
    left=10pt,
    right=10pt,
    top=10pt,
    bottom=10pt,
    before skip=5pt,
    after skip=5pt,
    tdcls minimum height={#1},
    overlay unbroken and first={%
      \tdcls@draw@grade%
    }
  }
}{\tdcls@hide@environment{reponses}}

\NewDocumentCommand\reponse{O{}}{\begin{reponses}[#1]\end{reponses}}

% Correction environnement

\ifelsecorrection{%
  \newtcolorbox{corrections}[1][]{%
    enhanced,
    breakable,
    enlargepage flexible=10pt,
    colback=charcoal!5,
    colframe=charcoal!75,
    boxrule=1pt,
    arc=5pt,
    boxsep=0pt,
    left=10pt,
    right=10pt,
    top=10pt,
    bottom=10pt,
    before skip=5pt,
    after skip=5pt,
    tdcls minimum height={#1},
    overlay unbroken and first={%
      \tdcls@draw@grade%
    }
  }%
}{\tdcls@hide@environment{corrections}}

\NewDocumentCommand\correction{O{} +m}{\begin{corrections}[#1]#2\end{corrections}}

% Solutions environnement

\NewDocumentEnvironment{solutions}{O{}}{%
  \begin{reponses}[#1]%
  \end{reponses}%
  \begin{corrections}[#1]%
}{%
  \end{corrections}%
}

\NewDocumentCommand\solution{O{} +m}{\begin{solutions}[#1]#2\end{solutions}}

% Texts

\providecommand\tdcls@exercisename{Exercice}
\providecommand\tdcls@correctionname{CORRECTION}
\providecommand\tdcls@complementname{pour aller plus loin}

\endinput
