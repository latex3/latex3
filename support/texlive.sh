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
tlmgr install luatex l3build

# Required to build plain and LaTeX formats:
# TeX90 plain for unpacking, pdfLaTeX, LuaLaTeX and XeTeX for tests
tlmgr install latex-bin tex xetex
  
# Install (u)pLaTeX
tlmgr install platex uplatex

# Assuming a 'basic' font set up, metafont is required to avoid
# warnings with some packages and errors with others
tlmgr install metafont mfware

# Set up graphics
tlmgr install graphics graphics-def

# Contrib packages for testing
#
# The packages themselves are done with --no-depends to avoid
# picking up l3kernel, etc.
#
# fontspec comes first as other packages tested have it as a dep
tlmgr install fontspec
tlmgr install luaotfload

# Other contrib packages: done as a block to avoid multiple calls to tlmgr
# Dependencies other than the core l3build set up, metafont, fontspec and the
# 'graphics stack' (itself needed by fontspec) are listed below
tlmgr install --no-depends \
  chemformula \
  ctex        \
  mhchem      \
  siunitx     \
  unicode-math
tlmgr install cjk
tlmgr install   \
  adobemapping  \
  amsfonts      \
  amsmath       \
  chemgreek     \
  cjkpunct      \
  ctablestack   \
  ec            \
  environ       \
  etoolbox      \
  fandol        \
  filehook      \
  iftex         \
  lm-math       \
  lualatex-math \
  luatexbase    \
  luatexja      \
  ms            \
  pgf           \
  tools         \
  trimspaces    \
  ucharcat      \
  ulem          \
  units         \
  xcolor        \
  xecjk         \
  xkeyval       \
  xunicode      \
  zhmetrics     \
  zhnumber

# For the doc target
tlmgr install \
  booktabs    \
  colortbl    \
  csquotes    \
  dvips       \
  enumitem    \
  fancyvrb    \
  hyperref    \
  listings    \
  makeindex   \
  mathpazo    \
  palatino    \
  psnfss      \
  symbol      \
  times       \
  underscore  \
  url         \
  zapfding

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
