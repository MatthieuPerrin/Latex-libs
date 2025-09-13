\def\td@version{2023/11/08, v. 1.0}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{td}[\td@version Class used for exercise sheets and booklets]

\newif\if@tdcls@livret
\@tdcls@livretfalse
\DeclareOption{livret}{\@tdcls@livrettrue}
\newcommand{\ifelse@tdcls@livret}[2]{\if@tdcls@livret#1\else#2\fi}

\newif\if@tdcls@correction
\@tdcls@correctionfalse
\DeclareOption{correction}{\@tdcls@correctiontrue}
\newcommand{\ifcorrection}[1]{\if@tdcls@correction#1\else\fi}
\newcommand{\ifnotcorrection}[1]{\if@tdcls@correction\else#1\fi}
\newcommand{\ifelsecorrection}[2]{\if@tdcls@correction#1\else#2\fi}

\let\tdcls@passedoptions\@empty
\DeclareOption*{%
  \ifx\tdcls@passedoptions\@empty\edef\tdcls@passedoptions{\CurrentOption}%
  \else\edef\tdcls@passedoptions{\tdcls@passedoptions,\CurrentOption}%
  \fi%
}

\ProcessOptions\relax

\ifelse@tdcls@livret{
  \LoadClass[twoside,\tdcls@passedoptions]{book}%
}{
  \LoadClass[\tdcls@passedoptions]{article}%
}

\RequirePackage{times}
\RequirePackage{fancyhdr}
\RequirePackage[french]{babel}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage{xparse}
\RequirePackage{ifthen}
\RequirePackage{xcolor}
\RequirePackage[framemethod=TikZ]{mdframed}
\RequirePackage[left=1.9cm, top=2.6cm, textwidth=16cm, textheight=24cm]{geometry}
\RequirePackage{lastpage}
\RequirePackage{needspace}


\gdef\text@forbidden{@ @@ @'}

\definecolor{charcoal}{RGB}{28,28,28}
\newcounter{tdcls@exercice}
\newcounter{tdcls@session}
\newcommand\insertexercisenumber{\thetdcls@exercice}
\if@tdcls@livret\gdef\insertexercisenumber{\thetdcls@session.\thetdcls@exercice} \fi


\newcommand\inserttitle{}
\newcommand\runningtitle{}
\renewcommand\title[2][\text@forbidden]{%
  \gdef\inserttitle{#2}%
  \ifthenelse{\equal{#1}{\text@forbidden}}{
    \gdef\runningtitle{#2}
  }{
    \gdef\runningtitle{#1}
  }%
}%

\newcommand\insertauthor{}
\newcommand\runningauthor{}
\renewcommand\author[2][\text@forbidden]{%
  \gdef\insertauthor{#2}%
  \ifthenelse{\equal{#1}{\text@forbidden}}{
    \gdef\runningauthor{#2}
  }{
    \gdef\runningauthor{#1}
  }%
}%

\newcommand\inserttypefeuille{}
\newcommand\runningtypefeuille{}
\newcommand\typefeuille[2][\text@forbidden]{
  \gdef\inserttypefeuille{#2}
  \ifthenelse{\equal{#1}{\text@forbidden}}{
    \gdef\runningtypefeuille{#2}
  }{
    \gdef\runningtypefeuille{#1}
  }
}
\newcommand\typeTD{\typefeuille[TD]{travaux dirigés}}
\newcommand\typeTP{\typefeuille[TP]{travaux pratiques}}
\newcommand\typeCC{\typefeuille[CC]{contrôle continu}}
\newcommand\typeCCTP{\typefeuille[CCTP]{contrôle continu de TP}}
\newcommand\typeEXAM{\typefeuille{Examen}}

\newcommand\insertdate{
  \ifnum\number\month<8{
    \advance\year by -1 \number\year/\advance\year by 1 \number\year
  }\else{
    \number\year/\advance\year by 1 \number\year
  }\fi
}
\renewcommand{\date}[1]{
  \gdef\insertdate{#1}
}

\newcommand\insertinstitution{}
\newcommand\institution[1]{
  \gdef\insertinstitution{#1}
}

\newcommand\insertlogo{}
\newcommand\logo[1]{
  \gdef\insertlogo{\includegraphics[width=\textwidth,height=25mm,keepaspectratio]{#1}}
}

\newcommand\runningcursus{}
\newcommand\insertcursus{}
\newcommand{\cursus}[2][\text@forbidden]{
  \gdef\insertcursus{#2}
  \ifthenelse{\equal{#1}{\text@forbidden}}{
    \gdef\runningcursus{#2}
  }{
    \gdef\runningcursus{#1}
  }%
}

\newcommand\insertcodeUE{}
\newcommand{\codeUE}[1]{
  \gdef\insertcodeUE{#1}
}

\newcommand\insertintituleUE{}
\newcommand{\intituleUE}[1]{
  \gdef\insertintituleUE{#1}
}

\newcommand\insertsession{}
\newcommand\runningsession{}
\newcommand\tdcls@set@session[2][\text@forbidden]{%
  \@tdcls@appendixfalse%
  \gdef\insertsession{#2}%
  \ifthenelse{\equal{#1}{\text@forbidden}}{%
    \gdef\runningsession{#2}%
  }{%
    \gdef\runningsession{#1}%
  }%
  \stepcounter{tdcls@session}%
  \setcounter{tdcls@exercice}{0}%
}%
\newcommand\tdcls@print@top{
  \begin{center}%
    \begin{tikzpicture}%
      \node[align=center, text width=\textwidth, minimum height=7mm, font=\Large] (number) {Séance \thetdcls@session\if@tdcls@appendix~---~pour aller plus loin\fi};
      \node[align=center, text width=\textwidth, anchor=north, minimum height=8mm, font=\LARGE] (title) at (number.south) {\insertsession};
      \draw ([xshift=-4cm, yshift=-2mm]title.south) -- ([xshift=4cm, yshift=-2mm]title.south);
    \end{tikzpicture}%
  \end{center}%
}
\newcommand\tdcls@print@session[2][\text@forbidden]{%
  \clearpage\ifodd\value{page}~\newpage\fi%
  \tdcls@set@session[#1]{#2}
  \tdcls@print@top
}%
\newcommand\session[2][\text@forbidden]{\tdcls@set@session[#1]{#2}}
\AtBeginDocument{\ifnotcorrection{\let\session\tdcls@print@session}}

\newif\if@tdcls@appendix
\@tdcls@appendixfalse
\newcommand\sessionappendix{%
  \@tdcls@appendixtrue%
  \ifnotcorrection{%
    \clearpage%
    \tdcls@print@top%
  }
}

\newenvironment{exercice}[1][\text@forbidden]{%
  \ifcorrection{
    \clearpage
    \tdcls@print@top
  }
  \needspace{3\baselineskip}%
  \par\addvspace{5mm}%
  \refstepcounter{tdcls@exercice}%
  \noindent\textbf{Exercice \insertexercisenumber\ifthenelse{\equal{#1}{\text@forbidden}}{}{~(#1)}.}\par\vspace{2mm}%
}{\par\vspace{1mm}}


%Environnement question

\newlist{question}{enumerate}{1}
\setlist[question, 1]{%
  label={\bf\thetdcls@exercice\alph*.}, % Format des labels des questions
  ref={\thetdcls@exercice\alph*}, % Format de la référence (Exercice.Question)
  leftmargin=15mm,
  resume % Permet de continuer la numérotation à travers les environnements
}

\newcommand\resetquestion{\restartlist{question}}

%Environnement correction

\ifelsecorrection{
  \newmdenv[
    backgroundcolor=charcoal!5,
    linewidth=1pt,
    linecolor=charcoal!50,
    roundcorner=10pt,
    innerleftmargin=10pt,
    innerrightmargin=10pt,
    innertopmargin=10pt,
    innerbottommargin=10pt
  ]{graybox}
  \newenvironment{correction}{%
    \needspace{5\baselineskip}%
    \begin{graybox}%
      \noindent\textbf{Correction}\par\vspace{2mm}%
  }{
    \end{graybox}
    \par\vspace{1mm}
  }
}{
  \newsavebox{\ignorebox}
  \newenvironment{correction}{
    \begin{lrbox}{\ignorebox}\begin{minipage}{\textwidth}
  }{
    \end{minipage}\end{lrbox}
  }
}


\newcommand{\maketitlepage}{
  \newpage  
  \newgeometry{top=2.5cm,bottom=2.5cm,left=2cm,right=2cm}
  \thispagestyle{empty}
  \begin{titlepage}
    \begin{minipage}{.4\textwidth}
      \centering
      \insertlogo
    \end{minipage}
   \hfill
    \begin{minipage}{.4\textwidth}
      \textbf{\color{charcoal!70}\insertcursus}
    \end{minipage}
 
    \vspace{4cm}
 
    \begin{center}
      \Huge
      \rule{\linewidth}{0.8mm}\\[5mm]
      \textsc{\insertintituleUE}
      \rule{\linewidth}{0.8mm}\\[7mm]
      \LARGE
      Livret de \inserttypefeuille\\[3mm]
      \insertdate
    \end{center}
    
    \vfill
 
    \begin{minipage}{.5\textwidth}
      \textbf{\color{charcoal!70}\insertauthor}
    \end{minipage}
  \end{titlepage}
  \restoregeometry
  \newpage  
}


\renewcommand{\maketitle}{
  \begingroup%
  \newpage%
  \large%
  \par\parindent0pt\insertcursus                       \hfill \insertinstitution%
  \par\parindent0pt\insertcodeUE~---~\insertintituleUE \hfill \insertdate%
  \vskip 2em%
  \begin{center}%
    \LARGE
    \emph{Feuille de \inserttypefeuille~n° \thetdcls@session}
    \par%
    \vspace{3mm}%
    \Large
    \emph{\inserttitle}\par%
    \ifcorrection{\textbf{\textcolor{red}{\LARGE ---~CORRECTION~---}}}
    \vskip 1.5em%
  \end{center}%
  \par\vskip 1.5em
  \endgroup
}






\pagestyle{fancy}
\fancyhead{}
\ifelse@tdcls@livret{
  \fancyhead[LE]{{\small Séance \thetdcls@session}}
  \fancyhead[CE]{}
  \fancyhead[RE]{{\small \insertinstitution}}
  \fancyhead[OL]{{\small \runningcursus}}
  \fancyhead[OC]{}
  \fancyhead[OR]{{\small \runningsession}}
  \fancyfoot[LE]{{\small \thepage/\pageref{LastPage}}}
  \fancyfoot[CE]{}
  \fancyfoot[RE]{{\small \insertcodeUE}}
  \fancyfoot[OL]{{\small \insertintituleUE}}
  \fancyfoot[OC]{}
  \fancyfoot[OR]{{\small \thepage/\pageref{LastPage}}}
}{
  \fancyfoot[L]{{\scriptsize\@intitule\ -- \insertinstitution}}
  \fancyfoot[C]{\scriptsize\Type@Feuille \@feuille\ -- \runningtitle}
  \fancyfoot[R]{{\scriptsize\thepage/\pageref{LastPage}}}
}
\renewcommand{\footrulewidth}{.4pt}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\headwidth}{\hsize}

\endinput

%%% Local Variables: 
%%% mode: latex
%%% TeX-master: t
%%% End: 
