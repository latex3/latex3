# The LaTeX3 Development Repository

## Overview

The repository contains development material for LaTeX3. This includes
not only code to be developed into the LaTeX3 kernel, but also a variety
of test, documentation and more experimental material. A great deal of
the experimental LaTeX3 code can be loaded within LaTeX2e to allow
development and testing to occur.

The following directories contain experimental LaTeX3 code:

* `l3kernel`: code which is intended to eventually appear in a
  stand-alone LaTeX3 format. Most of this material is also
  usable on top of LaTeX2e when loading the `expl3` package.
* `l3backend`: code for backend (driver) level interaces across
  the `expl3` codebase.
* `l3packages`: code which is written to be used on top of
  LaTeX2e to experiment with LaTeX3 concepts. The interfaces to these
  higher-level packages are 'stable'.
* `l3experimental`: code which is written to be used on top of
  LaTeX2e to experiment with LaTeX3 concepts. The interfaces
  for these packages are still under active discussion. Parts of this code may
  eventually be migrated to `l3kernel`, while other parts are tied closely
  to LaTeX2e and are intended to support mixing LaTeX2e and LaTeX3 concepts.
* `l3trial`: material which is under very active development, for potential
  addition to `l3kernel` or `l3experimental`. Material in this directory
  may include potential replacements for existing modules, where large-scale
  changes are under-way.
* `l3leftovers`: code which has been developed in the past by The
  LaTeX3 Project but is not suitable for use in its current form.
  Parts of this code may be used as the basis for new developments
  in `l3kernel` or `l3experimental` over time.

Support material for development is found in:

* `support`, which contains files for the automated test suite which are
  'local' to the LaTeX3 repository.

Documentation is found in:

* `articles`: discussion of LaTeX3 concepts by team members for
  publication in [_TUGBoat_](http://www.tug.org/tugboat) or elsewhere.

The repository also contains the directory `xpackages`. This
contain code which is being moved (broadly) `l3experimental`.
Over time, `xpackages` is expected to be removed from the repository.
The directory `contrib` is used to test the interaction of LaTeX3
code with selected contributed packages.

## Discussion

Discussion concerning the approach, suggestions for improvements,
changes, additions, _etc._ should be addressed to the list
[LaTeX-L](https://listserv.uni-heidelberg.de/cgi-bin/wa?A0=LATEX-L).

You can subscribe to this list by sending mail to

    listserv@urz.uni-heidelberg.de

with the body containing

    subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>

## Issues

The issue tracker for LaTeX3 is currently located
[on GitHub](https://github.com/latex3/latex3/issues).

Please report specific issues with LaTeX3 code there; more general
discussion should be directed to the [LaTeX-L list](#Discussion).

## Build status

LaTeX3 uses [Travis CI](https://travis-ci.org/) as a hosted continuous
integration service. For each commit, the build status is tested using
the current release of TeX Live.

_Current build status:_
[![Build Status](https://travis-ci.org/latex3/latex3.svg?branch=master)](https://travis-ci.org/latex3/latex3)

## Development team

LaTeX3 is developed by [The LaTeX3 Project](https://latex-project.org).

## Copyright

This README file is copyright 2019 The LaTeX3 Project.
