"""
A simple utility that reformats paragraphs to a fixed width.
1. Minimize the variance of the lengths of each line...
2. ...subject to the constraint that the number of lines is optimal
3. Ignore the last line, while making sure it's shorter than average
That's it! Runs in O(NK) where N = # characters and K = width
"""
import sys

PREFIX = set(" >:-*|#$%'\"") # characters allowed to be in a prefix

def get_lines(par: list, width: int) -> list:
    """ Compute optimal line lengths with forward greedy. """
    lines, i, count = [0], 0, 0
    while i < len(par):
        x, v = 0, len(par[i])
        count += 1
        while i + 1 < len(par) and v <= width:
            i += 1
            x, v = v, v + 1 + len(par[i])
            lines.append(count)
        if v <= width:
            i += 1
            lines.append(count)

    return lines

def vardp(par: list, lines: list, width: int) -> list:
    """ Computes the minimum variance, constrained to use optimal lines. """
    # state (index, variance, sum of x^2 terms, sum of x)
    dp = [None]*(len(par) + 1)
    dp[0] = (0, 0, 0, 0)
    for i in range(1, len(par) + 1):
        k, best, sum_x2, sum_x, x = 0, float("inf"), 0, 0, 0
        for j in range(i - 1, -1, -1):
            # add 1 for space, if the current line isn't empty
            v = x + (x != 0) + len(par[j])
            if v <= width:
                x = v
                _, _, sum_x2j, sum_xj = dp[j]
                n = 1 + lines[j]
                sum_x2j += x*x
                sum_xj += x
                # Var[X] = E[X^2] - E[X]^2
                mean = sum_xj/n
                var = sum_x2j/n - mean*mean
                if var < best and n == lines[i]:
                    k, best, sum_x2, sum_x = j, var, sum_x2j, sum_xj
            else:
                break
        dp[i] = (k, best, sum_x2, sum_x)

    return dp

def process(par: list, width: int, prefix: str) -> str:
    """ Takes in a paragraph and returns a string with a new line width. """
    if len(par) == 0:
        return ""
    assert max(map(len, par)) <= width, "line too long"

    lines = get_lines(par, width)
    dp = vardp(par, lines, width)
    # if the paragraph is less than 3 lines long, don't ignore the last line
    if lines[-1] <= 3:
        k = len(par)
    else:
        best, k, x = [float("inf")]*2, [0]*2, 0
        for i in range(len(par) - 1, -1, -1):
            x += (x != 0) + len(par[i])
            if x > width:
                break
            b = x <= dp[i][-1]/lines[i]
            if lines[i] + 1 == lines[-1] and dp[i][1] < best[b]:
                best[b], k[b] = dp[i][1], i
        k = k[1] if best[1] != float("inf") else k[0]

    out, i = [], k
    if k < len(par):
        out.append(" ".join(par[k:]))
    while i > 0:
        j = dp[i][0]
        out.append(" ".join(par[j:i]))
        i = j
    # add prefix to each line
    return "\n".join(map(lambda x: prefix + x, out[::-1]))

def parse_prefix(lines: list) -> tuple:
    """ Parses lines into a list of tokens, taking into account prefixes. """
    # find prefix, where a prefix is defined as a series
    # of the same character, if the character is in PREFIX
    prefix = []
    smallest = min(map(len, lines))
    for ch in range(smallest):
        for line in lines:
            if line[ch] != lines[0][ch] or line[ch] not in PREFIX:
                break
        else:
            prefix.append(lines[0][ch])
            continue
        break
    prefix = "".join(prefix)

    par = []
    for line in lines:
        par += line[len(prefix):].split()

    return par, prefix

if __name__ == "__main__":
    # read command line arguments - one parameter, width
    width = int(sys.argv[1]) if len(sys.argv) > 1 else 79

    # read input into paragraph blocks, making empty lines []
    pars, lines = [], []
    for line in sys.stdin:
        if line != "\n":
            lines.append(line)
        else:
            if len(lines) > 0:
                par, prefix = parse_prefix(lines)
                pars.append((par, width - len(prefix), prefix))
            pars.append(([], width, ""))
            par, lines = [], []
    if len(lines) > 0:
        par, prefix = parse_prefix(lines)
        pars.append((par, width - len(prefix), prefix))

    print("\n".join(map(lambda x: process(*x), pars)))

