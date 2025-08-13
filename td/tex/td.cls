\def\td@version{2023/11/08, v. 1.0}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{td}[\td@version]

\gdef\Type@Feuille{}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}
\DeclareOption{a4paper}{\PassOptionsToClass{a4paper}{article}}
\DeclareOption{TD}{\gdef\Type@Feuille{Feuille de travaux dirig\'es}}
\DeclareOption{EXAMEN}{\gdef\Type@Feuille{Examen}}
\DeclareOption{TP}{\gdef\Type@Feuille{Feuille de travaux pratiques}}
\DeclareOption{CC}{\gdef\Type@Feuille{Contr\^ole continu}}
\DeclareOption{CCTP}{\gdef\Type@Feuille{Contr\^ole continu de travaux pratiques}}
\DeclareOption{AUTRE}{\gdef\Type@Feuille{\@TypeFeuillePerso}} 
\DeclareOption{avecRappel}{\gdef\rappel@correction{o}}
\DeclareOption{sansRappel}{\gdef\rappel@correction{n}}

\ExecuteOptions{a4paper,TD}%,avecRappel,TD}
\ProcessOptions\relax
\LoadClass{article}

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

\newcommand\eqdef{\stackrel{\text{def}}{=}}



\newcommand{\inserttitle}{}
\newcommand{\runningtitle}{}
\gdef\text@forbidden{@ @@ @'}

\newcommand{\cursus}[1]{\gdef\@cursus{{\parindent 0pt #1}}}
\newcommand{\intitule}[1]{\gdef\@intitule{#1}}
\newcommand{\feuille}[1]{\gdef\@feuille{ \no{}#1}}
\renewcommand{\title}[2][\text@forbidden]{\renewcommand{\inserttitle}{#2}\ifthenelse{\equal{#1}{\text@forbidden}}{\renewcommand{\runningtitle}{#2}}{\renewcommand{\runningtitle}{#1}}}
\date{}




\newcommand{\ifcorrection}[1]{\ifdefined\generatecorrection#1\else\fi}
\newcommand{\ifnotcorrection}[1]{\ifdefined\generatecorrection\else#1\fi}


% En-tête et pied de page

\pagestyle{fancy}
\fancyhead{}
\fancyfoot[L]{{\tiny\@intitule\ -- Nantes Universit\'e}}
\fancyfoot[C]{\tiny\Type@Feuille \@feuille\ -- \runningtitle}
\fancyfoot[R]{{\tiny\thepage/\pageref{LastPage}}}
 
\renewcommand{\footrulewidth}{.4pt}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\headwidth}{\hsize}


% Titre

\def\annee@scolaire{\ifnum\number\month<8{\advance\year by -1 \number\year/%
    \advance\year by 1 \number\year}%
  \else%
  {\number\year/\advance\year by 1 \number\year}\fi}

\def\Affiche@BandeauCorrige{\textbf{\textcolor{red}%
    {\LARGE ---~CORRECTION~---}}}


\renewcommand{\maketitle}{
  \newpage
  \null
  {\large\@cursus \hfill Nantes Université}\par{\parindent 0pt
  {\large\@intitule \hfill \annee@scolaire}}
  \vskip 2em
  \begin{center}%
    {\LARGE\em \Type@Feuille \@feuille \par}%
    \vspace{3mm}
    {\Large\em \inserttitle \par}%
    \ifdefined\generatecorrection{\vspace{5mm}\Affiche@BandeauCorrige}\fi\par
    \vskip 1.5em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}



%Environnement exercice


\newcounter{exercice}
\setcounter{exercice}{0}

\newenvironment{exercice}[1][]{%
  \needspace{5\baselineskip}%
  \par\addvspace{10mm}%
  \newcommand\argument{#1}%
  \refstepcounter{exercice}%
  \noindent\textbf{Exercice \theexercice.~\ifdefempty{\argument}{}{(#1)}}\par\vspace{2mm}%
%  \noindent\begin{minipage}{\textwidth}%
}{\par\vspace{1mm}}


%Environnement question

\newlist{question}{enumerate}{1}
\setlist[question, 1]{%
  label=\bf\theexercice\alph*., % Format des labels des questions
  ref=\theexercice\alph*, % Format de la référence (Exercice.Question)
  leftmargin=15mm,
  resume % Permet de continuer la numérotation à travers les environnements
}

\newcommand\resetquestion{\restartlist{question}}

%Environnement correction

\newsavebox{\ignorebox}
\newmdenv[backgroundcolor=black!10,
  linewidth=0pt,
  roundcorner=10pt,
  innerleftmargin=10pt,
  innerrightmargin=10pt,
  innertopmargin=10pt,
  innerbottommargin=10pt]{graybox}


\newenvironment{correction}{%
  \needspace{5\baselineskip}%
  \begin{graybox}%
  \noindent\textbf{Correction}\par\vspace{2mm}%
}{\end{graybox}\par\vspace{1mm}}

\ifdefined\generatecorrection\else\renewenvironment{correction}{\begin{lrbox}{\ignorebox}\begin{minipage}{\textwidth}}{\end{minipage}\end{lrbox}}\fi



\endinput

%%% Local Variables: 
%%% mode: latex
%%% TeX-master: t
%%% End: 
