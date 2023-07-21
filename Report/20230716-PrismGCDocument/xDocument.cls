\ProvidesClass{xDocument}

\PassOptionsToPackage{AutoFakeBold}{xeCJK}
\LoadClass[UTF8,a4paper,cs4size,titlepage]{ctexart}

\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage[hidelinks]{hyperref}

\geometry{left=2.54cm,right=2.54cm,top=2.8cm,bottom=2.8cm}

\ctexset{section={format={\heiti\zihao{3}\centering}}}
\ctexset{subsection={format={\heiti\zihao{4}}}}
\ctexset{subsubsection={format={\heiti\zihao{-4}}}}

\fancyhf{}
\cfoot{\thepage}
\lhead{\sffamily\leftmark}
\rhead{\sffamily\@title}

%预先重定义章节层次标签在引用时的格式
\newcommand{\xreftextpart}[1]{第\ref*{part:#1}部分}
\newcommand{\xreftextchap}[1]{第\ref*{chap:#1}章}
\newcommand{\xreftextsec}[1]{第\CJKsetecglue{ }\ref*{sec:#1} 节}
\newcommand{\xreftextsubsec}[1]{第\CJKsetecglue{ }\ref*{subsec:#1} 小节}

%预先重定义页码引用的格式
\newcommand{\xreftextpage}[1]{第\CJKsetecglue{}\pageref*{#1}页}

\setlength\parskip{6pt}
\linespread{1.625}