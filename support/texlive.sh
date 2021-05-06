#!/usr/bin/env sh

# This script is used for testing using Travis
# It is intended to work on their VM set up: Ubuntu 12.04 LTS
# A minimal current TL is installed adding only the packages that are
# required

# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
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
tlmgr install amsmath tools

# Assuming a 'basic' font set up, metafont is required to avoid
# warnings with some packages and errors with others
tlmgr install metafont mfware

# Dependencies for tests that are not auto-resolved
tlmgr install bibtex lualatex-math
  
# For the doc target and testing l3doc
tlmgr install \
  alphalph    \
  amsfonts    \
  bookmark    \
  booktabs    \
  catchfile   \
  colortbl    \
  csquotes    \
  dvips       \
  ec          \
  enumitem    \
  epstopdf    \
  epstopdf-pkg \
  everysel    \
  fancyvrb    \
  hologo      \
  hyperref    \
  lipsum      \
  listings    \
  makeindex   \
  mathpazo    \
  metalogo    \
  oberdiek    \
  pgf         \
  psnfss      \
  ragged2e    \
  siunitx     \
  times       \
  underscore  \
  units

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --all --no-auto-install
