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

\setlength\parskip{6pt}
\linespread{1.625}