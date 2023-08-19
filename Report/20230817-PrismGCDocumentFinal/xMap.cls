\ProvidesClass{xMap}

\LoadClass{xStandalone}

\definecolor{ColorICE}{HTML}{CCCCFF}
\definecolor{ColorBAR}{HTML}{FFFFFF}
\definecolor{ColorEND}{HTML}{33EE88}
\definecolor{ColorDIR}{HTML}{1155DD}
\definecolor{ColorDIRARR}{HTML}{FFFFFF}
\definecolor{ColorGRA}{HTML}{CCCCCC}
\definecolor{ColorGRABUT}{HTML}{888888}
\definecolor{ColorPOR}{HTML}{333333}
\definecolor{ColorPORSY1}{HTML}{CC8888}
\definecolor{ColorPORSY2}{HTML}{88CC88}
\definecolor{ColorPORSY3}{HTML}{8888CC}
\definecolor{ColorTRP}{HTML}{00CCFF}
\definecolor{ColorDOR}{HTML}{884400}
\definecolor{ColorDOB}{HTML}{CCCC00}


\NewDocumentCommand{\Block}{mmm}
{
    \path(\fpeval{#2},\fpeval{12-(#1)-1})
    coordinate (cent);

    \fill[#3]
    ($(cent)+(-0.4,-0.4)$)
    rectangle
    ($(cent)+(+0.4,+0.4)$);
}

\NewDocumentCommand{\BlockICE}{mm}
{
    \Block{#1}{#2}{ColorICE}
}

\NewDocumentCommand{\BlockBAR}{mm}
{
    \Block{#1}{#2}{ColorBAR}
}

\NewDocumentCommand{\BlockEND}{mm}
{
    \Block{#1}{#2}{ColorEND}
}

\NewDocumentCommand{\BlockDIR}{mmm}
{
    \Block{#1}{#2}{ColorDIR}
    \ifthenelse{\equal{#3}{R}}
    {
        \path (cent) ++(0,-0.05) node[white] {\LARGE $\rightarrow$};
    }{}

    \ifthenelse{\equal{#3}{L}}
    {
        \path (cent) ++(0,-0.05) node[white] {\LARGE $\leftarrow$};
    }{}

    \ifthenelse{\equal{#3}{U}}
    {
        \path (cent) node[white] {\LARGE $\uparrow$};
    }{}

    \ifthenelse{\equal{#3}{D}}
    {
        \path (cent) node[white] {\LARGE $\downarrow$};
    }{}
}

\NewDocumentCommand{\BlockGRA}{mm}
{
    \Block{#1}{#2}{ColorGRABUT}
    \fill[ColorGRA] ($(cent)+(0.32,0.32)$) rectangle ($(cent)+(-0.32,-0.32)$);
}

\NewDocumentCommand{\BlockPOR}{mmm}
{
    \Block{#1}{#2}{ColorPOR}
    \ifthenelse{\equal{#3}{1}}
    {
        \fill[ColorPORSY1] ($(cent)+(0.35,0.35)$) rectangle ($(cent)+(-0.35,-0.35)$);
    }{}
    \ifthenelse{\equal{#3}{2}}
    {
        \fill[ColorPORSY2] ($(cent)+(0.35,0.35)$) rectangle ($(cent)+(-0.35,-0.35)$);
    }{}
    \ifthenelse{\equal{#3}{3}}
    {
        \fill[ColorPORSY3] ($(cent)+(0.35,0.35)$) rectangle ($(cent)+(-0.35,-0.35)$);
    }{}
    \fill[ColorPOR] ($(cent)+(0.25,0.25)$) rectangle ($(cent)+(-0.25,-0.25)$);
}

\NewDocumentCommand{\BlockTRP}{mm}
{
    \Block{#1}{#2}{ColorICE}
    \fill[ColorBAR] ($(cent)+(-8/48,+9/48)$) rectangle ($(cent)+(7/48,+7/48)$);
    \fill[ColorBAR] ($(cent)+(-10/48,+7/48)$) rectangle ($(cent)+(7/48,+6/48)$);
    \fill[ColorTRP] ($(cent)+(-6/48,+7/48)$) rectangle ($(cent)+(5/48,+6/48)$);
    \fill[ColorBAR] ($(cent)+(-12/48,+6/48)$) rectangle ($(cent)+(9/48,+5/48)$);
    \fill[ColorTRP] ($(cent)+(-8/48,+6/48)$) rectangle ($(cent)+(7/48,+5/48)$);
    \fill[ColorBAR] ($(cent)+(-14/48,+5/48)$) rectangle ($(cent)+(10/48,+4/48)$);
    \fill[ColorTRP] ($(cent)+(-12/48,+5/48)$) rectangle ($(cent)+(8/48,+4/48)$);
    \fill[ColorBAR] ($(cent)+(-15/48,+4/48)$) rectangle ($(cent)+(11/48,+3/48)$);
    \fill[ColorTRP] ($(cent)+(-13/48,+4/48)$) rectangle ($(cent)+(9/48,+3/48)$);
    \fill[ColorBAR] ($(cent)+(-15/48,+3/48)$) rectangle ($(cent)+(11/48,+2/48)$);
    \fill[ColorTRP] ($(cent)+(-13/48,+3/48)$) rectangle ($(cent)+(9/48,+2/48)$);
    \fill[ColorBAR] ($(cent)+(-17/48,+2/48)$) rectangle ($(cent)+(12/48,+1/48)$);
    \fill[ColorTRP] ($(cent)+(-15/48,+2/48)$) rectangle ($(cent)+(10/48,+1/48)$);
    \fill[ColorBAR] ($(cent)+(-17/48,+1/48)$) rectangle ($(cent)+(14/48,0/48)$);
    \fill[ColorTRP] ($(cent)+(-15/48,+1/48)$) rectangle ($(cent)+(10/48,0/48)$);
    \fill[ColorBAR] ($(cent)+(-18/48,0/48)$) rectangle ($(cent)+(16/48,-1/48)$);
    \fill[ColorTRP] ($(cent)+(-16/48,0/48)$) rectangle ($(cent)+(12/48,-1/48)$);
    \fill[ColorBAR] ($(cent)+(0/48,-1/48)$) rectangle ($(cent)+(17/48,-2/48)$);
    \fill[ColorTRP] ($(cent)+(-15/48,-1/48)$) rectangle ($(cent)+(15/48,-2/48)$);
    \fill[ColorBAR] ($(cent)+(0/48,-2/48)$) rectangle ($(cent)+(17/48,-3/48)$);
    \fill[ColorTRP] ($(cent)+(-14/48,-2/48)$) rectangle ($(cent)+(15/48,-3/48)$);
    \fill[ColorTRP] ($(cent)+(-13/48,-3/48)$) rectangle ($(cent)+(16/48,-4/48)$);
    \fill[ColorTRP] ($(cent)+(-12/48,-4/48)$) rectangle ($(cent)+(16/48,-5/48)$);
    \fill[ColorTRP] ($(cent)+(-11/48,-5/48)$) rectangle ($(cent)+(14/48,-6/48)$);
    \fill[ColorTRP] ($(cent)+(-10/48,-6/48)$) rectangle ($(cent)+(14/48,-7/48)$);
    \fill[ColorTRP] ($(cent)+(-9/48,-7/48)$) rectangle ($(cent)+(12/48,-8/48)$);
    \fill[ColorTRP] ($(cent)+(-9/48,-8/48)$) rectangle ($(cent)+(12/48,-9/48)$);
    \fill[ColorTRP] ($(cent)+(-8/48,-9/48)$) rectangle ($(cent)+(9/48,-10/48)$);
    \fill[ColorTRP] ($(cent)+(-6/48,-10/48)$) rectangle ($(cent)+(7/48,-11/48)$);
}

\NewDocumentCommand{\BlockMCG}{mm}
{
    \Block{#1}{#2}{ColorICE}
    \fill[ColorDOR] ($(cent)+(-0.4,-0.4)$) rectangle ($(cent)+(-0.316,0.4)$);
    \fill[ColorDOR] ($(cent)+(+0.4,-0.4)$) rectangle ($(cent)+(+0.316,0.4)$);

    \fill[ColorDOB] ($(cent)+(-0.3,-0.3)$) rectangle ($(cent)+(-0.2,0.3)$);
    \fill[ColorDOB] ($(cent)+(-0.14,-0.3)$) rectangle ($(cent)+(-0.04,0.3)$);
    \fill[ColorDOB] ($(cent)+(+0.14,-0.3)$) rectangle ($(cent)+(+0.04,0.3)$);
    \fill[ColorDOB] ($(cent)+(+0.3,-0.3)$) rectangle ($(cent)+(+0.2,0.3)$);

    \fill[ColorDOR] ($(cent)+(-0.4,-0.12)$) rectangle ($(cent)+(+0.4,-0.23)$);
    \fill[ColorDOR] ($(cent)+(-0.4,+0.12)$) rectangle ($(cent)+(+0.4,+0.23)$);
}

\NewDocumentCommand{\BlockBUT}{mm}
{
    \Block{#1}{#2}{ColorPOR}

    \fill[red!80!black] ($(cent)$) circle (0.3333);
    \fill[red] ($(cent)$) circle (0.25);
}

\definecolor{MWHI}{HTML}{FFFFFF}
\definecolor{MBLK}{HTML}{000000}
\definecolor{MBLU}{HTML}{8888FF}
\definecolor{MLBU}{HTML}{AAAAFF}
\definecolor{MDBU}{HTML}{4444FF}
\definecolor{AWHI}{HTML}{FFFFFF}
\definecolor{ABLK}{HTML}{000000}
\definecolor{ARED}{HTML}{ED1C24}
\definecolor{ADKR}{HTML}{B72A32}
\definecolor{ABRO}{HTML}{804040}

\def\PixelI{0}
\def\PixelJ{0}
\def\PixelXoffset{0}
\def\PixelYoffset{0}

\NewDocumentCommand{\Pixel}{mmm}
{
    \path(\fpeval{\PixelJ+\PixelXoffset+(#2)/25},\fpeval{(11-\PixelI)+\PixelYoffset+(16-#1-1)/25})
    coordinate (cent);

    \fill[#3]
    ($(cent)+(-0.5/25,-0.5/25)$)
    rectangle
    ($(cent)+(+0.5/25,+0.5/25)$);
}

\NewDocumentCommand{\MainCht}{mm}
{
    \renewcommand{\PixelI}{#1}
    \renewcommand{\PixelJ}{#2}
    \renewcommand{\PixelXoffset}{-0.3}
    \renewcommand{\PixelYoffset}{-0.4}
    \Pixel{0}{4}{MBLK}
    \Pixel{0}{5}{MBLK}
    \Pixel{0}{6}{MBLK}
    \Pixel{0}{7}{MBLK}
    \Pixel{0}{8}{MBLK}
    \Pixel{0}{9}{MBLK}
    \Pixel{0}{10}{MBLK}
    \Pixel{0}{11}{MBLK}
    \Pixel{1}{2}{MBLK}
    \Pixel{1}{3}{MBLK}
    \Pixel{1}{4}{MLBU}
    \Pixel{1}{5}{MLBU}
    \Pixel{1}{6}{MLBU}
    \Pixel{1}{7}{MLBU}
    \Pixel{1}{8}{MLBU}
    \Pixel{1}{9}{MLBU}
    \Pixel{1}{10}{MLBU}
    \Pixel{1}{11}{MLBU}
    \Pixel{1}{12}{MBLK}
    \Pixel{1}{13}{MBLK}
    \Pixel{2}{1}{MBLK}
    \Pixel{2}{2}{MLBU}
    \Pixel{2}{3}{MLBU}
    \Pixel{2}{4}{MBLU}
    \Pixel{2}{5}{MBLU}
    \Pixel{2}{6}{MBLU}
    \Pixel{2}{7}{MBLU}
    \Pixel{2}{8}{MBLU}
    \Pixel{2}{9}{MBLU}
    \Pixel{2}{10}{MBLU}
    \Pixel{2}{11}{MBLU}
    \Pixel{2}{12}{MLBU}
    \Pixel{2}{13}{MLBU}
    \Pixel{2}{14}{MBLK}
    \Pixel{3}{1}{MBLK}
    \Pixel{3}{2}{MBLU}
    \Pixel{3}{3}{MBLU}
    \Pixel{3}{4}{MBLU}
    \Pixel{3}{5}{MBLU}
    \Pixel{3}{6}{MBLU}
    \Pixel{3}{7}{MBLU}
    \Pixel{3}{8}{MBLU}
    \Pixel{3}{9}{MBLU}
    \Pixel{3}{10}{MBLU}
    \Pixel{3}{11}{MBLU}
    \Pixel{3}{12}{MBLU}
    \Pixel{3}{13}{MBLU}
    \Pixel{3}{14}{MBLK}
    \Pixel{4}{1}{MBLK}
    \Pixel{4}{2}{MBLU}
    \Pixel{4}{3}{MBLU}
    \Pixel{4}{4}{MBLU}
    \Pixel{4}{5}{MBLU}
    \Pixel{4}{6}{MBLU}
    \Pixel{4}{7}{MBLU}
    \Pixel{4}{8}{MBLU}
    \Pixel{4}{9}{MBLU}
    \Pixel{4}{10}{MBLU}
    \Pixel{4}{11}{MBLU}
    \Pixel{4}{12}{MBLU}
    \Pixel{4}{13}{MBLU}
    \Pixel{4}{14}{MBLK}
    \Pixel{5}{0}{MBLK}
    \Pixel{5}{1}{MBLU}
    \Pixel{5}{2}{MBLU}
    \Pixel{5}{3}{MBLU}
    \Pixel{5}{4}{MWHI}
    \Pixel{5}{5}{MBLU}
    \Pixel{5}{6}{MBLU}
    \Pixel{5}{7}{MBLU}
    \Pixel{5}{8}{MBLU}
    \Pixel{5}{9}{MBLU}
    \Pixel{5}{10}{MBLU}
    \Pixel{5}{11}{MWHI}
    \Pixel{5}{12}{MBLU}
    \Pixel{5}{13}{MBLU}
    \Pixel{5}{14}{MBLU}
    \Pixel{5}{15}{MBLK}
    \Pixel{6}{0}{MBLK}
    \Pixel{6}{1}{MLBU}
    \Pixel{6}{2}{MBLU}
    \Pixel{6}{3}{MBLU}
    \Pixel{6}{4}{MBLK}
    \Pixel{6}{5}{MBLU}
    \Pixel{6}{6}{MBLU}
    \Pixel{6}{7}{MBLU}
    \Pixel{6}{8}{MBLU}
    \Pixel{6}{9}{MBLU}
    \Pixel{6}{10}{MBLU}
    \Pixel{6}{11}{MBLK}
    \Pixel{6}{12}{MBLU}
    \Pixel{6}{13}{MBLU}
    \Pixel{6}{14}{MLBU}
    \Pixel{6}{15}{MBLK}
    \Pixel{7}{0}{MBLK}
    \Pixel{7}{1}{MBLU}
    \Pixel{7}{2}{MBLU}
    \Pixel{7}{3}{MBLU}
    \Pixel{7}{4}{MBLK}
    \Pixel{7}{5}{MBLU}
    \Pixel{7}{6}{MBLU}
    \Pixel{7}{7}{MBLU}
    \Pixel{7}{8}{MBLU}
    \Pixel{7}{9}{MBLU}
    \Pixel{7}{10}{MBLU}
    \Pixel{7}{11}{MBLK}
    \Pixel{7}{12}{MBLU}
    \Pixel{7}{13}{MBLU}
    \Pixel{7}{14}{MBLU}
    \Pixel{7}{15}{MBLK}
    \Pixel{8}{0}{MBLK}
    \Pixel{8}{1}{MBLU}
    \Pixel{8}{2}{MBLU}
    \Pixel{8}{3}{MBLU}
    \Pixel{8}{4}{MDBU}
    \Pixel{8}{5}{MBLU}
    \Pixel{8}{6}{MBLU}
    \Pixel{8}{7}{MBLU}
    \Pixel{8}{8}{MBLU}
    \Pixel{8}{9}{MBLU}
    \Pixel{8}{10}{MBLU}
    \Pixel{8}{11}{MDBU}
    \Pixel{8}{12}{MBLU}
    \Pixel{8}{13}{MBLU}
    \Pixel{8}{14}{MBLU}
    \Pixel{8}{15}{MBLK}
    \Pixel{9}{0}{MBLK}
    \Pixel{9}{1}{MDBU}
    \Pixel{9}{2}{MDBU}
    \Pixel{9}{3}{MBLU}
    \Pixel{9}{4}{MBLU}
    \Pixel{9}{5}{MBLU}
    \Pixel{9}{6}{MBLU}
    \Pixel{9}{7}{MBLU}
    \Pixel{9}{8}{MBLU}
    \Pixel{9}{9}{MBLU}
    \Pixel{9}{10}{MBLU}
    \Pixel{9}{11}{MBLU}
    \Pixel{9}{12}{MBLU}
    \Pixel{9}{13}{MBLU}
    \Pixel{9}{14}{MDBU}
    \Pixel{9}{15}{MBLK}
    \Pixel{10}{1}{MBLK}
    \Pixel{10}{2}{MBLK}
    \Pixel{10}{3}{MDBU}
    \Pixel{10}{4}{MDBU}
    \Pixel{10}{5}{MDBU}
    \Pixel{10}{6}{MDBU}
    \Pixel{10}{7}{MDBU}
    \Pixel{10}{8}{MDBU}
    \Pixel{10}{9}{MDBU}
    \Pixel{10}{10}{MDBU}
    \Pixel{10}{11}{MDBU}
    \Pixel{10}{12}{MDBU}
    \Pixel{10}{13}{MBLK}
    \Pixel{10}{14}{MBLK}
    \Pixel{11}{3}{MBLK}
    \Pixel{11}{4}{MBLK}
    \Pixel{11}{5}{MBLK}
    \Pixel{11}{6}{MBLK}
    \Pixel{11}{7}{MBLK}
    \Pixel{11}{8}{MBLK}
    \Pixel{11}{9}{MBLK}
    \Pixel{11}{10}{MBLK}
    \Pixel{11}{11}{MBLK}
    \Pixel{11}{12}{MBLK}
}

\NewDocumentCommand{\Apple}{mm}
{
    \renewcommand{\PixelI}{#1}
    \renewcommand{\PixelJ}{#2}
    \renewcommand{\PixelXoffset}{-0.3}
    \renewcommand{\PixelYoffset}{-0.3}
    \Pixel{0}{8}{ABRO}
    \Pixel{1}{8}{ABRO}
    \Pixel{2}{8}{ABRO}
    \Pixel{3}{3}{ABLK}
    \Pixel{3}{4}{ABLK}
    \Pixel{3}{5}{ABLK}
    \Pixel{3}{6}{ABLK}
    \Pixel{3}{7}{ABLK}
    \Pixel{3}{8}{ABRO}
    \Pixel{3}{9}{ABLK}
    \Pixel{3}{10}{ABLK}
    \Pixel{3}{11}{ABLK}
    \Pixel{3}{12}{ABLK}
    \Pixel{4}{2}{ABLK}
    \Pixel{4}{3}{ARED}
    \Pixel{4}{4}{ARED}
    \Pixel{4}{5}{ARED}
    \Pixel{4}{6}{ARED}
    \Pixel{4}{7}{ARED}
    \Pixel{4}{8}{ABRO}
    \Pixel{4}{9}{ARED}
    \Pixel{4}{10}{ARED}
    \Pixel{4}{11}{ARED}
    \Pixel{4}{12}{ARED}
    \Pixel{4}{13}{ABLK}
    \Pixel{5}{1}{ABLK}
    \Pixel{5}{2}{ARED}
    \Pixel{5}{3}{ARED}
    \Pixel{5}{4}{ARED}
    \Pixel{5}{5}{ARED}
    \Pixel{5}{6}{ABRO}
    \Pixel{5}{7}{ARED}
    \Pixel{5}{8}{ABRO}
    \Pixel{5}{9}{ARED}
    \Pixel{5}{10}{ABRO}
    \Pixel{5}{11}{ARED}
    \Pixel{5}{12}{ARED}
    \Pixel{5}{13}{ARED}
    \Pixel{5}{14}{ABLK}
    \Pixel{6}{1}{ABLK}
    \Pixel{6}{2}{ARED}
    \Pixel{6}{3}{ARED}
    \Pixel{6}{4}{ARED}
    \Pixel{6}{5}{ARED}
    \Pixel{6}{6}{ARED}
    \Pixel{6}{7}{ABRO}
    \Pixel{6}{8}{ABRO}
    \Pixel{6}{9}{ABRO}
    \Pixel{6}{10}{ARED}
    \Pixel{6}{11}{ARED}
    \Pixel{6}{12}{ARED}
    \Pixel{6}{13}{ARED}
    \Pixel{6}{14}{ARED}
    \Pixel{6}{15}{ABLK}
    \Pixel{7}{0}{ABLK}
    \Pixel{7}{1}{ARED}
    \Pixel{7}{2}{ARED}
    \Pixel{7}{3}{ARED}
    \Pixel{7}{4}{ARED}
    \Pixel{7}{5}{ARED}
    \Pixel{7}{6}{ARED}
    \Pixel{7}{7}{ARED}
    \Pixel{7}{8}{ARED}
    \Pixel{7}{9}{ARED}
    \Pixel{7}{10}{ARED}
    \Pixel{7}{11}{ARED}
    \Pixel{7}{12}{ARED}
    \Pixel{7}{13}{AWHI}
    \Pixel{7}{14}{ARED}
    \Pixel{7}{15}{ABLK}
    \Pixel{8}{0}{ABLK}
    \Pixel{8}{1}{ARED}
    \Pixel{8}{2}{ARED}
    \Pixel{8}{3}{ARED}
    \Pixel{8}{4}{ARED}
    \Pixel{8}{5}{ARED}
    \Pixel{8}{6}{ARED}
    \Pixel{8}{7}{ARED}
    \Pixel{8}{8}{ARED}
    \Pixel{8}{9}{ARED}
    \Pixel{8}{10}{ARED}
    \Pixel{8}{11}{ARED}
    \Pixel{8}{12}{ARED}
    \Pixel{8}{13}{AWHI}
    \Pixel{8}{14}{ARED}
    \Pixel{8}{15}{ABLK}
    \Pixel{9}{0}{ABLK}
    \Pixel{9}{1}{ARED}
    \Pixel{9}{2}{ARED}
    \Pixel{9}{3}{ARED}
    \Pixel{9}{4}{ARED}
    \Pixel{9}{5}{ARED}
    \Pixel{9}{6}{ARED}
    \Pixel{9}{7}{ARED}
    \Pixel{9}{8}{ARED}
    \Pixel{9}{9}{ARED}
    \Pixel{9}{10}{ARED}
    \Pixel{9}{11}{ARED}
    \Pixel{9}{12}{ARED}
    \Pixel{9}{13}{ARED}
    \Pixel{9}{14}{ARED}
    \Pixel{9}{15}{ABLK}
    \Pixel{10}{0}{ABLK}
    \Pixel{10}{1}{ARED}
    \Pixel{10}{2}{ARED}
    \Pixel{10}{3}{ARED}
    \Pixel{10}{4}{ARED}
    \Pixel{10}{5}{ARED}
    \Pixel{10}{6}{ARED}
    \Pixel{10}{7}{ARED}
    \Pixel{10}{8}{ARED}
    \Pixel{10}{9}{ARED}
    \Pixel{10}{10}{ARED}
    \Pixel{10}{11}{ARED}
    \Pixel{10}{12}{ARED}
    \Pixel{10}{13}{AWHI}
    \Pixel{10}{14}{ARED}
    \Pixel{10}{15}{ABLK}
    \Pixel{11}{0}{ABLK}
    \Pixel{11}{1}{ARED}
    \Pixel{11}{2}{ARED}
    \Pixel{11}{3}{ARED}
    \Pixel{11}{4}{ARED}
    \Pixel{11}{5}{ARED}
    \Pixel{11}{6}{ARED}
    \Pixel{11}{7}{ARED}
    \Pixel{11}{8}{ARED}
    \Pixel{11}{9}{ARED}
    \Pixel{11}{10}{ARED}
    \Pixel{11}{11}{ARED}
    \Pixel{11}{12}{ARED}
    \Pixel{11}{13}{ARED}
    \Pixel{11}{14}{ARED}
    \Pixel{11}{15}{ABLK}
    \Pixel{12}{0}{ABLK}
    \Pixel{12}{1}{ARED}
    \Pixel{12}{2}{ARED}
    \Pixel{12}{3}{ARED}
    \Pixel{12}{4}{ARED}
    \Pixel{12}{5}{ARED}
    \Pixel{12}{6}{ARED}
    \Pixel{12}{7}{ARED}
    \Pixel{12}{8}{ARED}
    \Pixel{12}{9}{ARED}
    \Pixel{12}{10}{ARED}
    \Pixel{12}{11}{ARED}
    \Pixel{12}{12}{ARED}
    \Pixel{12}{13}{ARED}
    \Pixel{12}{14}{ARED}
    \Pixel{12}{15}{ABLK}
    \Pixel{13}{1}{ABLK}
    \Pixel{13}{2}{ARED}
    \Pixel{13}{3}{ARED}
    \Pixel{13}{4}{ARED}
    \Pixel{13}{5}{ARED}
    \Pixel{13}{6}{ARED}
    \Pixel{13}{7}{ARED}
    \Pixel{13}{8}{ARED}
    \Pixel{13}{9}{ARED}
    \Pixel{13}{10}{ARED}
    \Pixel{13}{11}{ARED}
    \Pixel{13}{12}{ARED}
    \Pixel{13}{13}{ARED}
    \Pixel{13}{14}{ABLK}
    \Pixel{14}{2}{ABLK}
    \Pixel{14}{3}{ADKR}
    \Pixel{14}{4}{ADKR}
    \Pixel{14}{5}{ADKR}
    \Pixel{14}{6}{ADKR}
    \Pixel{14}{7}{ADKR}
    \Pixel{14}{8}{ARED}
    \Pixel{14}{9}{ARED}
    \Pixel{14}{10}{ADKR}
    \Pixel{14}{11}{ADKR}
    \Pixel{14}{12}{ADKR}
    \Pixel{14}{13}{ABLK}
    \Pixel{15}{4}{ABLK}
    \Pixel{15}{5}{ABLK}
    \Pixel{15}{6}{ABLK}
    \Pixel{15}{7}{ABLK}
    \Pixel{15}{8}{ABLK}
    \Pixel{15}{9}{ABLK}
    \Pixel{15}{10}{ABLK}
    \Pixel{15}{11}{ABLK}
}