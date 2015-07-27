
XFSS, or: A translation of LaTeX's ‘New Font Selection Scheme’
==============================================================

LaTeX2e's NFSS is probably one of the most complex examples of TeX
programming in extreme conditions of resource scarcity; it is optimised
for memory consumption and speed. As such, it's not been written in a style
that's necessarily the most clear; abstraction to improve code clarity
would have required memory usage that simply was not possible at the time.

As an off-shoot of the LaTeX3 project, I've been translating the NFSS into
the expl3 programming language, which we're using for our new work.
There are some fantastic examples of how expl3 makes life much easier for
quite a large number of cases.

I've dubbed this translation the XFSS, but this name may change in the future.
In time, XFSS will be added to the main LaTeX3 repository, but until that time
I'm going to be working on it sporadically here to avoid lots of noise in
the official channels.

Please don't expect XFSS to necessarily do anything useful for you!
At the moment, XFSS simply functions exactly as does NFSS with a few minor
differences and removal of deprecated code paths.
In fact, there are some known problems where my translation skills have left
something to be desired.

In time I'd like to extend the code a little, but not before it's properly
documented and organised. Many of the issues I've faced in this translation
have helped inform where the expl3 code needs some polishing.

This will also form the basis for font support in the nascent LaTeX3 kernel,
but I haven't tested that yet. It's a big job because all primitives and
interfaces must be accounted for.

I'm going to be very busy over the next few months so this code might languish
for a little while. I'll try and work on it slowly, however.

Roadmap
=======

 * Complete expl3-isation, including primitives without wrappers yet
 * Feed back any relevant expl3 extensions into the official code
 * Add test suite, based initially on the LaTeX2e test files
 * Ensure it's working for the LaTeX3 format
 * Fully document and organise code
 * Extend NFSS font axes (to add ‘case’ in addition to ‘series’ and ‘shape’)
 * Incorporate relevant 3rd-party font packages (font size changing, etc.)
 * Merge xunicode and unicode-math into xfss, where possible

Somewhere in there the code will be merged into the LaTeX3 SVN repository.
Just not sure where.

--------------
Will Robertson
March 2011