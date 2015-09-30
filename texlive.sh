#!/usr/bin/env sh

# This script is used for testing using Travis
# It is intended to work on their VM set up: Ubuntu 12.04 LTS
# As such, the nature of the system is hard-coded
# A minimal current TL is installed adding only the packages that are
# required

# See if there is a cached verson of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if command -v texlua > /dev/null; then
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

# Additional requirements for the xor test
tlmgr install courier psnfss times tools url

# Additional requirements for contrib tests:
# - siunitx
tlmgr install amsmath ec
tlmgr install --no-depends siunitx
# - fontspec
tlmgr install euenc lm luatexbase luaotfload 
tlmgr install oberdiek pdftex-def xetex-def xunicode
tlmgr install --no-depends fontspec
# - unicode-math
tlmgr install etoolbox filehook lm-math lualatex-math ucharcat
tlmgr install --no-depends unicode-math
