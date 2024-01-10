Thanks for considering contributing to LaTeX3: feedback, fixes and ideas are
all useful. Here, we ([The LaTeX Project](https://www.latex-project.org)) have
collected together a few pointers to help things along.

## Bugs

Please log bugs using the [issues](https://github.com/latex3/latex3/issues)
system on GitHub. Handy information that you _might_
include, depending on the nature of the issue, includes

- Your version of `expl3` (from your `.log`)
- Your TeX system details (for example 'TeX Live 2017')
- Which engine(s) you are using (_e.g._ pdfTeX)
- Any additional packages that are needed to see the issue
  (noting that of course we can only help with bugs in _our own code_)

## Feature requests

Feature requests are welcome: log them in the same way as bugs, explaining
the motivation for the change.

## Code contributions

If you want to discuss a possible contribution before (or instead of)
making a pull request, drop a line to
[the team](mailto:latex-team@latex-project.org).

There are a few things you may need to bear in mind

- `l3kernel` is 'broadly' stable so any changes there are best raised
  first by mailing the team
- New functions normally get added _via_ pull requests or (for new
  modules) `l3trial`

If you are submitting a pull request, notice that

- The first line of commit messages should be a short summary (up to about
  50 chars); leave a blank line then give more detail if required
- We use Travis-CI for (light) testing so add `[ci skip]` to documentation-only
  commit messages
- We favour a single linear history so will rebase accepted pull requests
- Where a commit fixes or closes an issue, please include this information
  in the first line of the commit message [`(fixes #X)` or similar]
