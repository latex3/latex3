# The `expl3` (LaTeX3) Development Repository

## Overview

The repository contains development material for `expl3`. This includes
not only code to be developed into the `expl3` kernel, but also a variety
of test, documentation and more experimental material. All of this code works
on top of LaTeX2e.

The following directories are present in the repository:

* `l3kernel`: code forms the `expl3` kernel and all stable code.
  With a modern LaTeX2e kernel,
  this code is loaded during format creation; when using an older LaTeX2e
  kernel, this material is accessible using the `expl3` package.
* `l3backend`: code for backend (driver) level interfaces across
  the `expl3` codebase; none of this code has public interfaces, and so
  no distinction is made between stable and experimental code.
* `l3packages`: code which is written to be used on top of LaTeX2e to explore
  interfaces; this bundle is now made up of historical material, and the
  concepts have been migrated to the LaTeX2e kernel
* `l3experimental`: code which is written to be used on top of
  LaTeX2e to experiment with code and interface concepts. The interfaces
  for these packages are still under active discussion. Parts of this code may
  eventually be migrated to `l3kernel`.
* `l3trial`: material which is under very active development, for potential
  addition to `l3kernel` or `l3experimental`. Material in this directory
  may include potential replacements for existing modules, where large-scale
  changes are under-way. This code is _not_ released to CTAN.
* `l3leftovers`: code which has been developed in the past by The LaTeX Project
  but is not suitable for use in its current form. Parts of this code may be
  used as the basis for new developments in `l3kernel` or `l3experimental` over
  time.

Support material for development is found in:

* `support`, which contains files for the automated test suite which are
  'local' to the repository.

Documentation is found in:

* `articles`: discussion of concepts by team members for
  publication in [_TUGBoat_](http://www.tug.org/tugboat) or elsewhere.

The repository also contains the directory `xpackages`. This contain code which
is being moved (broadly) `l3experimental`. Over time, `xpackages` is expected to
be removed from the repository.

## Issues

The issue tracker for `expl3` is currently located
[on GitHub](https://github.com/latex3/latex3/issues).

## Build status

We use [GitHub Actions](https://github.com/features/actions) as a hosted
continuous integration service. For each commit, the build status is tested
using the current release of TeX Live.

_Current build status:_
![build status](https://github.com/latex3/latex3/actions/workflows/main.yaml/badge.svg?branch=main)

## Development team

This code is developed by [The LaTeX Project](https://latex-project.org).

## Copyright

This README file is copyright 2021-2024 The LaTeX Project.
