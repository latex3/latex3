#!/usr/bin/env sh

# This script is used for testing using Travis
# It is intended to work on their VM set up: Ubuntu 12.04 LTS
# A minimal current TL is installed adding only the packages that are
# required

# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile=../support/texlive.profile

  cd ..
fi

# Update tlmgr itself
tlmgr update --self

# The test framework itself
tlmgr install l3build

# Required to build plain and LaTeX formats including (u)pLaTeX
tlmgr install latex-bin luahbtex platex uplatex tex xetex

# Then get the rest of required LaTeX
tlmgr install amsmath graphics tools 

# Assuming a 'basic' font set up, metafont is required to avoid
# warnings with some packages and errors with others
tlmgr install metafont mfware texlive-scripts

# Contrib packages for testing
# The deps here will include l3... but that's not worth worrying about
tlmgr install \
  chemformula \
  ctex        \
  mhchem      \
  siunitx     \
  unicode-math
# Dependencies for tests that are not auto-resolved:
# a lot for CTeX as different engine need different stuff,
# also fonts as they are not down as deps
tlmgr install \
  adobemapping  \
  alphalph      \
  amsfonts      \
  bibtex        \
  bitset        \
  catchfile     \
  cjk           \
  cjkpunct      \
  ctablestack   \
  ec            \
  epstopdf-pkg  \
  fandol        \
  lualatex-math \
  ltxcmds       \
  pdfescape     \
  pdftexcmds    \
  pgf           \
  trimspaces    \
  ucharcat      \
  xcolor        \
  xecjk         \
  luatexja      \
  xkeyval       \
  zhmetrics
  
# For the doc target
tlmgr install \
  atbegshi    \
  atveryend   \
  auxhook     \
  bigintcalc  \
  bookmark    \
  booktabs    \
  colortbl    \
  csquotes    \
  dvips       \
  enumitem    \
  etexcmds    \
  fancyvrb    \
  gettitlestring \
  hologo      \
  hycolor     \
  hyperref    \
  intcalc     \
  kvdefinekeys \
  kvoptions   \
  kvsetkeys   \
  letltxmacro \
  listings    \
  makeindex   \
  mathpazo    \
  metalogo    \
  oberdiek    \
  psnfss      \
  ragged2e    \
  refcount    \
  rerunfilecheck \
  times       \
  underscore  \
  uniquecounter

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
