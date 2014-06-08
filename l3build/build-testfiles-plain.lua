#!/usr/bin/env texlua

-- Testing regression suite for l3build in plain

-- Identify the bundle and module
module = "l3build"
bundle = ""

maindir = "."
supportdir  = "."
testfiledir = "testfiles-plain"

installfiles = {"*.tex", "*.cfg"}
sourcefiles  = {"*.dtx", "l3build.lua", "*.ins"}
chkengines   = {"pdftex"}

dofile ("l3build.lua")
