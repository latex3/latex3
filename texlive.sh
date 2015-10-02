#!/usr/bin/env sh

# This script is used for testing using Travis
# It is intended to work on their VM set up: Ubuntu 12.04 LTS
# As such, the nature of the system is hard-coded
# A minimal current TL is installed adding only the packages that are
# required

# See if there is a cached verson of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if command -v texlua > /dev/null; then
  # Keep no backups (not required, simply makes cache bigger)
  tlmgr option -- autobackup 0
  # Update the TL install but add nothing new
  tlmgr update --self --all --no-auto-install
  exit 0
fi

wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-20*

# Set up the automated install
cat << EOF >> texlive.profile
selected_scheme scheme-minimal
TEXDIR /tmp/texlive
TEXMFCONFIG ~/.texlive2015/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /tmp/texlive/texmf-local
TEXMFSYSCONFIG /tmp/texlive/texmf-config
TEXMFSYSVAR /tmp/texlive/texmf-var
TEXMFVAR ~/.texlive2015/texmf-var
option_doc 0
option_src 0
EOF

./install-tl --profile=./texlive.profile

# Core requirements for the test system
tlmgr install babel babel-english latex latex-bin latex-fonts latexconfig xetex
tlmgr install --no-depends ptex uptex

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

