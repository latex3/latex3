#!/usr/bin/env sh

# This script is used for testing using Travis
# It is intended to work on their VM set up: Ubuntu 12.04 LTS
# As such, the nature of the system is hard-coded
# A minimal current TL is installed adding only the packages that are
# required

# See if there is a cached verson of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile=./support/texlive.profile

  # Core requirements for the test system
  tlmgr install babel babel-english latex latex-bin latex-fonts latexconfig \
    xetex
  tlmgr install --no-depends ptex uptex
fi

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0
# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install

# Dependencies
tlmgr install \
  adobemapping  \
  amsmath       \
  cjkpunct      \
  courier       \
  ec            \
  environ       \
  etoolbox      \
  euenc         \
  filehook      \
  lm            \
  lm-math       \
  lualatex-math \
  lualibs       \
  luatexbase    \
  luatexja      \
  luaotfload    \
  ms            \
  oberdiek      \
  pdftex-def    \
  psnfss        \
  times         \
  tools         \
  trimspaces    \
  ucharcat      \
  ulem          \
  url           \
  xecjk         \
  xetex-def     \
  xkeyval       \
  xunicode      \
  zhmetrics     \
  zhnumber
tlmgr install --no-depends cjk

# Contrib packages for testing: force no deps
tlmgr install --no-depends \
  ctex        \
  fontspec    \
  siunitx     \
  unicode-math

# Other bits and pieces
mkdir -p `kpsewhich -var-value TEXMFHOME`/fonts/cid/fontforge
cp Adobe-GB1-4.cidmap `kpsewhich -var-value TEXMFHOME`/fonts/cid/fontforge
