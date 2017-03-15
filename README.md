# Generic parallel scan

A [talk given at the Silicon Valley Haskell meetup on October 5, 2016](https://www.meetup.com/haskellhackers/events/234242974/).

*   [Slides (PDF)](http://conal.net/talks/generic-parallel-scan.pdf)
*   Video link will appear here.


## Abstract

This talk continues a theme from [*Generic FFT*], namely elegant, *generic* construction of efficient, parallel-friendly algorithms. By "generic" (also called "polytypic"), I mean structured via very simple and general data structure building blocks. Such developments produce not just a single algorithm, but an infinite family of algorithms, one for each data structure that can be assembled from the building blocks.

This time, we'll delve into (parallel) prefix computations---known as "scans" to functional programmers. Starting with a simple definition that performs linear work and takes linear time even in a parallel setting, we then consider each of the six generic building blocks of data structures. Four have cheap and easy scans, while the remaining two (functor product and composition) provide opportunities for parallel evaluation. Among the many different scan algorithms that arise for different data types, two at least are well-known. Both perform in $O(\log n)$ parallel time (given sufficient computational resources), while one does work $O(n \log n)$ work and the other $O(n)$.

These two scan algorithms fall out "for free" from right- vs left-association of functor compositions, revealing a hidden unity in what had appeared to be very different well-known algorithms. These data types, which I call (generalized) "top-down" and "bottom-up" trees, are exactly the same as we saw give rise to the well-known FFT algorithms "decimation in time" and "decimation in frequency" (DIT & DIF). I'll also show a bushier tree type that offers a compromise between the merits of top-down and bottom-up scans. FFT for bushes appears to improve over both DIT & DIF on both axes.

As with generic FFT, the star of the show is functor composition. The generic approach is more successful for scan than for FFT, however, since it applies to all six basic building blocks and thus works for a much larger collection of data types, including products and sums.

Three years ago at our meetup, I gave a talk called [*Understanding efficient parallel scan*].
While coming to similar conclusions, the new presentation is almost entirely different:

*   Much more emphasis on examples and intuition.
*   Generic programming takes center stage throughout.
*   Shape-indexed data types (vectors, trees, bushes).
*   Dropped the CUDA comparison.
*   Postponed complexity analysis to another talk unless there's time & interest.

[*Generic FFT*]: https://github.com/conal/talk-2016-generic-fft "talk by Conal Elliott (2016)"

[*Understanding efficient parallel scan*]: https://github.com/conal/talk-2013-understanding-parallel-scan "talk by Conal Elliott (2013)"
