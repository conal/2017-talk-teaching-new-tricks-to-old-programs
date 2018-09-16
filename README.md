# Teaching new tricks to old programs

A talk for [Lambda Jam](http://lambdajam.yowconference.com.au/) 2017 in Sydney, Australia.

*   [Slides (PDF)](http://conal.net/talks/teaching-new-tricks-to-old-programs.pdf)
*   [Video](https://www.youtube.com/watch?v=vzLK_xE9Zy8)
*   [Paper: "Compiling to Categories"](http://conal.net/papers/compiling-to-categories)

## Abstract

Many useful operations are well-defined on functions but are not computable, e.g., root-finding, optimization, exact differentiation and integration, and efficient, incremental evaluation. Sometimes these problems can be solved by means of a domain-specific embedded language (DSEL) with an implementation that maintains extra information. With extra effort, these implementations can be quite efficient, but at the cost of duplicating work of the host language compiler. Although overloading can hide some of the required change of vocabulary, the illusion is imperfect, and so code must be rewritten for the new DSLs with sometimes awkward or surprising results.

This talk presents an alternative to EDSLs, giving new interpretations to existing functional programs. The implementation is a plugin for GHC---a popular, high-quality Haskell compiler---and works by translating to a well-known, more easily generalizable form (cartesian closed categories). Each new interpretation is simply a new type and a collection of class instances for it, written in standard Haskell, with no exposure to compiler internals. To get a feel for the breadth of this technique, we'll look at interpretations including hardware circuits, automatic differentiation, incremental evaluation, satisfiability modulo theories (SMT), and interval analysis. 
