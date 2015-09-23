wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-20*

# Set up the automated install
cat << EOF >> texlive.profile 
selected_scheme scheme-basic
TEXDIR /tmp/texlive
TEXMFCONFIG ~/.texlive2015/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /tmp/texlive/texmf-local
TEXMFSYSCONFIG /tmp/texlive/texmf-config
TEXMFSYSVAR /tmp/texlive/texmf-var
TEXMFVAR ~/.texlive2015/texmf-var
EOF

./install-tl --profile=./texlive.profile
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
tlmgr install latex luatex pdftex ptex uptex xetex
cd ..
