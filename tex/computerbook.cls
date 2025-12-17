% ============================================================
%  C O M P U T E R B O O K   C L A S S
%  AIΩN Foundation Series — Book Typesetting Framework
%  Author: James Ross (Flying Robots)
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{computerbook}[2025/12/11 v1.0 AIΩN Computational Book Class]

% ------------------------------------------------------------
% Base class
% ------------------------------------------------------------
\LoadClass[11pt,oneside]{book}
% - 11pt is a beautiful compromise for long-read books
% - oneside avoids mirrored margins for digital-first PDFs

% ------------------------------------------------------------
% Options handling (future-proofing)
% ------------------------------------------------------------
\DeclareOption*{} % Currently no custom options
\ProcessOptions\relax

% ------------------------------------------------------------
% Required packages (core)
% ------------------------------------------------------------
\RequirePackage[margin=1.1in]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}
\RequirePackage{microtype}

% ------------------------------------------------------------
% Mathematics & Symbols
% ------------------------------------------------------------
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{extpfeil} % extended arrows for rewrite rules
\RequirePackage{textcomp}

% ------------------------------------------------------------
% Graphics, TikZ, Diagrams
% ------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\RequirePackage{tikz-cd}
\RequirePackage{eso-pic} % background images

% TikZ libraries
\usetikzlibrary{
  shapes, shapes.geometric, shapes.arrows,
  arrows.meta, positioning, calc,
  decorations.pathmorphing, decorations.pathreplacing,
  fadings, backgrounds, 3d, shadows, fit
}

% ------------------------------------------------------------
% Tables
% ------------------------------------------------------------
\RequirePackage{booktabs}
\RequirePackage{tabularx}

% ------------------------------------------------------------
% Lists & text formatting
% ------------------------------------------------------------
\RequirePackage{enumitem}
\RequirePackage{newunicodechar}

% ------------------------------------------------------------
% Code listings
% ------------------------------------------------------------
\RequirePackage{listings}

% ------------------------------------------------------------
% Colored boxes (callouts, definitions)
% ------------------------------------------------------------
\RequirePackage[most]{tcolorbox}

% ------------------------------------------------------------
% Hyperlinks & References
% ------------------------------------------------------------
\RequirePackage[bookmarks=true]{hyperref}
\RequirePackage[nameinlink]{cleveref}

\hypersetup{
  colorlinks=true,
  linkcolor=blue,
  urlcolor=magenta,
  citecolor=blue
}

% ------------------------------------------------------------
% Header / Footer styling
% ------------------------------------------------------------
\RequirePackage{fancyhdr}

\fancypagestyle{plain}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \fancyfoot[C]{\thepage}
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[C]{\thepage}

% ------------------------------------------------------------
% Theorem Environments
% ------------------------------------------------------------
\theoremstyle{definition}
\newtheorem{definition}{Definition}[chapter]

\theoremstyle{plain}
\newtheorem{proposition}[definition]{Proposition}
\newtheorem{conjecture}[definition]{Conjecture}

\theoremstyle{remark}
\newtheorem{remark}[definition]{Remark}

% Cleveref names
\crefname{definition}{definition}{definitions}
\Crefname{definition}{Definition}{Definitions}
\crefname{proposition}{proposition}{propositions}
\Crefname{proposition}{Proposition}{Propositions}
\crefname{conjecture}{conjecture}{conjectures}
\Crefname{conjecture}{Conjecture}{Conjectures}
\crefname{remark}{remark}{remarks}
\Crefname{remark}{Remark}{Remarks}

% ------------------------------------------------------------
% Quiet Down LaTeX (warning suppression)
% ------------------------------------------------------------
\RequirePackage{silence}
\WarningFilter{latex}{`h' float specifier changed to `ht'}
\WarningFilter{newunicodechar}{Redefining Unicode character}
\WarningFilter{latexfont}{Font shape `U/stmry/b/n' undefined}
\WarningFilter{pdftex}{destination with the same identifier}
\WarningFilter{latex}{Overfull \hbox}

% Relax tolerances
\hbadness=10000
\vbadness=10000
\hfuzz=200pt
\vfuzz=20pt
\emergencystretch=2em
\sloppy
\tracinglostchars=0
\pdfsuppresswarningpagegroup=1

% ------------------------------------------------------------
% TOC depth
% ------------------------------------------------------------
\setcounter{tocdepth}{0}

% ------------------------------------------------------------
% Paragraph styling (modern book look)
% ------------------------------------------------------------
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.7em plus 0.2em minus 0.1em}

% ------------------------------------------------------------
% Unicode conversions for math
% ------------------------------------------------------------
% (Your full unicode map preserved — snipped here for brevity,
%  but you can paste the exact mappings from your preamble.)
%
% If you'd like, I can fully integrate your unicode table here.

% ------------------------------------------------------------
% Listings configuration
% ------------------------------------------------------------
% (Also snipped for brevity—if you want, I drop the full block here)
% You can include your exact lstset from your preamble.

% ------------------------------------------------------------
% Input search paths
% ------------------------------------------------------------
\makeatletter
\def\input@path{{./}{./tex/}}
\makeatother

% ------------------------------------------------------------
% End of class
% ------------------------------------------------------------
\endinput