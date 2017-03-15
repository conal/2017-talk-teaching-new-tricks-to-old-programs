---
title: *To do* items for revised *Generic parallel scan*
subst: ["&&& △","*** ×","||| ▽","+++ +","|- ⊢","<~ ⤺","k (↝)","op (⊙)","--> ⇨","+-> ➔",":*: ✖",":+: ➕",":->? ⤔","Unit ()","R ℝ","Unit 𝟙",":==> ⤇"]
---

## To do

*   Relation to known parallel scan algorithms.
    I think Sklansky did top-down and Ladner & Fischer did bottom-up.
*   Scan complexity for `Bush`.
*   Statistics summary
*   Complexity --- Master Theorem
*   Future work:
    *   Finish complexity analysis (bushes)
    *   Derive each instance from the `Traversable`-based specification.
    *   `Monoid` vs `Semigroup`, e.g., `Max` with `RPow`, `LPow`, `Bush`, and non-empty left- and right-vectors.


## Or not

*   Consider a picture with 2D layout for parallel scan, akin to FFT.
    *   Horizontal arrows to show the scan paths.
    *   Add a result column for the sub-totals.
        The extra scan is vertical.
    *   Maybe also a picture for the linear sequential algorithm, showing dependency chains.
    *   Do the circuit pictures give this information?
        If not, could they?
    *   Wide vs tall.
    *   Maybe my circuit diagrams would work fine.
*   A type closer to the original bush type.
*   Consider making `adjustl`/`bump` be a function from `And1`.
    Would the change simplify `LScan (g :.: f)`?
    I don't think so.


## Done

*   Conclusions
*   Some applications:
    *   Polynomial evaluation
    *   Parallel multi-bit adders
*   Larger tree examples
*   Move supporting code to a new Stack project under this directory.
*   Update abstract in [the README](README.md) and [meetup announcement](https://www.meetup.com/haskellhackers/events/234242974/).
*   Minimal CUDA comparison
*   Generics / tinker toys.
    Show at least some of the `LScan` instances, including product and (especially) composition.
*   Use `LPow` and `RPow` from *Generic FFT*.
*   `LVec` and `RVec`.
*   `Bush`
*   Maybe at first do simple inclusive scan for the pictures.
    We'll see later why use exclusive+fold.
*   Do functor product before composition:
    *   Show `Pair :.: LVec N8` and `LVec N8 :.: Pair`.
        Already defined and rendered in `reify-core-examples`.
*   `lproducts` with `LBin`, `RBin`, and `Bush`.
*   Change `LScan` to use `c a -> (c :*: Id) a`.
    *   Oh. I've already done it in `ShapedTypes.ScanF`.
    *   Maybe use an infix operator in place of `And1`.
