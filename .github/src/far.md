# A (f)ast re-write of p(ar) - far

[[Video Guide]](https://youtu.be/H3Agto3ZSnk)
[[Source Code (C++)]](./far.cpp) [[Source Code (Python)]](./far.py)

[`par`](http://www.nicemice.net/par/) is a formatting tool that inserts line
breaks to make the length of each line less than a set number of characters,
usually 79 (terminals historically have 80 width). Unfortunately, `par` is
incredibly complicated and introduces random whitespace. So I made my own.

For `far` to make the paragraphs look good, it minimizes the variance of
each line. However, it's constrained to use the fewest number of lines
possible, so it doesn't generate really short lines. Finally, it ignores
the last line when minimizing variance and tries to make the last line
shorter than average, because a typical paragraph usually looks better
if the last line is shorter. To summarize,

1. Minimize the variance of the lengths of each line ...
2. ... subject to the constraint that the number of lines is smallest
3. Ignore the last line, while making sure it's shorter than average

`far` uses dynamic programming to minimize variance. It
tokenizes the paragraph by splitting on whitespace, and each
subproblem in the dynamic program is a suffix of this token list.

```python
Var[X] = E[X]^2 - E[X]^2 = sum(x^2 for x in X)/len(X) - (sum(X)/len(X))^2
```

The length `len(X)` is constant because of the smallest number of lines
constraint, and so is the sum because the sum of the line lengths is
determined by two things: the characters in the tokens and the number of
spaces introduced by merging two tokens (combining the words "hello" and
"world" onto the same line gives "hello world", with an additional space).
The characters stay the same, and the number of spaces is fixed if the
number of lines is fixed. Each token starts off as its own line, and each
merge reduces the number of lines by 1, so if two solutions have the same
number of lines, they must have done the same number of merges.

Thus, minimizing `Var[X]` is equivalent to minimizing the sum of squares
`sum(x^2 for x in X)` if the number of lines is fixed. Recall that we
are trying to minimize variance over the entire paragraph. The overall
paragraph has some mean value u. Each line will contribute `(x - u)^2`
to the overall paragraph's variance. So we want to minimize:

```
(x1 - u)^2 + (x2 - u)^2 + ... + (xn - u)^2
```

where xi is the length of a line and we know that `x1 + x2 + ... + xn` is
constant because of the above logic (`sum(X)` is constant). Expanding,

```
[x1^2 - 2u x1 + u^2] + [x2^2 - 2u x2 + u^2] + ... + [xn^2 - 2u xn + u^2]
u^2 is a constant, so we can discard those terms and reorganize into
[x1^2 + x2^2 + ... + xn^2] - 2u[x1 + x2 + ... + xn].
```

The last term is a constant, so minimizing the variance of the overall
paragraph is equivalent to minimizing the variance for a suffix of the
paragraph (both are minimizing the sum of squares). This is just the variance
of the subproblem, so the dynamic programming is valid since optimal
substructure holds. In practice, I skip calculating variance entirely and
simply minimize the sum of squares. I also do dynamic programming on the
variance of each _prefix_, so that I can easily ignore the last line.

That's it! The algorithm runs in `O(NK)` where N is the number of characters
in the input text and K is the desired width. Since K is usually fixed to
some small constant (79, 72, etc.), this is essentially linear in N and I
suspect most of the running time is bottlenecked by just I/O (reading the
input text and printing out the formatted text). Running with a width of
79 on a 1MB file with over 20,000 lines takes under 200 milliseconds. For
100MB, `fmt` takes around 11.9 seconds, `par` takes 15.7, and `far` takes
16.6. So `far` is slightly slower than the others, but certainly not enough
to be noticeable for "reasonable" inputs, especially if output is redirected
into a file rather than displayed to terminal.

## Examples

original paragraph:

```
xxxxx xxx xxx xxxx xxxxxxxxx xx x xxxxxxxxx x xxxx xxxx xxxxxxx xxxxxxxx xxx
xxxxxxxxx xxxxxxxx xx xx xxxxx xxxxx xxxx xx x xxxx xx xxxxxxxx xxxxxxxx xxxx
xxx xxxx xxxx xxx xxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxx xxx xxxxx xx xxxx x xxxx
xxxxxxxx xxxx xxxx xx xxxxx xxxx xxxxx xxxx xxxxxxxxx xxx xxxxxxxxxxx xxxxxx
xxx xxxxxxxxx xxxx xxxx xx x xx xxxx xxx xxxx xx xxx xxx xxxxxxxxxxx xxxx xxxxx
x xxxxx xxxxxxx xxxxxxx xx xx xxxxxx xx xxxxx
```

`fmt -w 72` (greedy algorithm):

```
xxxxx xxx xxx xxxx xxxxxxxxx xx x xxxxxxxxx x xxxx xxxx xxxxxxx xxxxxxxx
xxx xxxxxxxxx xxxxxxxx xx xx xxxxx xxxxx xxxx xx x xxxx xx xxxxxxxx
xxxxxxxx xxxx xxx xxxx xxxx xxx xxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxx xxx
xxxxx xx xxxx x xxxx xxxxxxxx xxxx xxxx xx xxxxx xxxx xxxxx xxxx
xxxxxxxxx xxx xxxxxxxxxxx xxxxxx xxx xxxxxxxxx xxxx xxxx xx x xx xxxx
xxx xxxx xx xxx xxx xxxxxxxxxxx xxxx xxxxx x xxxxx xxxxxxx xxxxxxx xx xx
xxxxxx xx xxxxx
```

`par 72` (with `PARINIT` set to `rTbgqR B=.,?'_A_a_@ Q=_s>|`):

```
xxxxx xxx xxx xxxx xxxxxxxxx xx x xxxxxxxxx x xxxx xxxx xxxxxxx xxxxxxxx
xxx xxxxxxxxx xxxxxxxx xx xx xxxxx xxxxx xxxx xx x xxxx xx xxxxxxxx
xxxxxxxx xxxx xxx xxxx xxxx xxx xxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxx
xxx xxxxx xx xxxx x xxxx xxxxxxxx xxxx xxxx xx xxxxx xxxx xxxxx xxxx
xxxxxxxxx xxx xxxxxxxxxxx xxxxxx xxx xxxxxxxxx xxxx xxxx xx x xx xxxx
xxx xxxx xx xxx xxx xxxxxxxxxxx xxxx xxxxx x xxxxx xxxxxxx xxxxxxx xx xx
xxxxxx xx xxxxx
```

`far 72`:

```
xxxxx xxx xxx xxxx xxxxxxxxx xx x xxxxxxxxx x xxxx xxxx xxxxxxx
xxxxxxxx xxx xxxxxxxxx xxxxxxxx xx xx xxxxx xxxxx xxxx xx x xxxx
xx xxxxxxxx xxxxxxxx xxxx xxx xxxx xxxx xxx xxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxx xxx xxxxx xx xxxx x xxxx xxxxxxxx xxxx xxxx xx xxxxx
xxxx xxxxx xxxx xxxxxxxxx xxx xxxxxxxxxxx xxxxxx xxx xxxxxxxxx
xxxx xxxx xx x xx xxxx xxx xxxx xx xxx xxx xxxxxxxxxxx xxxx xxxxx
x xxxxx xxxxxxx xxxxxxx xx xx xxxxxx xx xxxxx
```

Looking at the output of the greedy algorithm, because it always forms a line
if it's possible, it creates highly variable line lengths. For example, there
are many "valleys" where a line is shorter than the lines adjacent to it, like
lines 2 and lines 4, giving the overall paragraph a jagged appearance.

`par` improves on `fmt`, but still creates a single large valley. Finally,
I would argue that `far` creates the most aesthetically pleasing paragraph
because it minimizes the variance, creating the smoothest paragraph edge.

It's probably possible to modify `PARINIT` for `par` to work properly on this
example, and in general `par` works quite well, but it's hard to work through
the documentation to find precisely what to do and the recommended `PARINIT`
in the man page should work well. `far` works well "out of the box" and for
better or for worse, only has a single configuration parameter --- width.

## Uses

This program is pretty useful whenever writing plaintext in a monospace text
editor, e.g. when editing LaTeX, markdown files, college essays, and emails.
It's especially useful in `vim`, which lets you set the option `'formatprg'`
so the operator `gq` formats using the external program.
