/* clang++ -O3 far.cpp -o far
 * A simple utility that reformats paragraphs to a fixed width.
 * 1. Minimize the variance of the lengths of each line...
 * 2. ... subject to the constraint that the number of lines is optimal
 * 3. Ignore the last line, while making sure it's shorter than average
 * That's it! Runs in O(NK) where N = # characters and K = width
 */
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <unordered_set>
#include <cassert>
#include <limits>
using namespace std;

// renames
#define append push_back
#define last back()
#define mp make_pair
#define fi first
#define se second
#define el '\n'
#define arg const &
#define list vector
// change to long if you run out of memory
typedef long long ll;
typedef string str;
typedef list<ll> li;
typedef list<string> ls;
typedef pair<ll, ll> pi;
// misc
#define For(x, n) for (auto &x : n)
#define print(x) cout << (x) << '\n'
#define len(l) ((int) l.size())
#define in(x, s) (s.find(x) != s.end())

// globals
const ll INF = numeric_limits<ll>::max(); // infinity, but not really
// characters allowed to be in a prefix
const unordered_set<char> PREFIX = {' ', '>', ':', '-', '*',
  '|', '#', '$', '%', '"', '\''};

// fraction methods
inline ll det(pi arg x, pi arg y) { return x.fi*y.se - x.se*y.fi; }    // ad-bc
inline pi mul(pi arg x, pi arg y) { return mp(x.fi*y.fi, x.se*y.se); } // x*y
inline pi sub(pi arg x, pi arg y) { return mp(det(x, y), x.se*y.se); } // x - y
inline bool cmp(pi arg x, pi arg y) { return det(x, y) < 0; }          // x < y

pair<li, ll> get_lines(ls arg para, ll WIDTH) {
  /* Compute optimal line lengths with forward greedy. */
  ll i, num, x, v, chars; i = 0; num = 0; chars = 0;
  li lines = {0};
  while (i < len(para)) {
    x = 0; v = len(para[i]); num++;
    while (v <= WIDTH and i + 1 < len(para)) {
      i++; x = v; v += 1 + len(para[i]);
      lines.append(num);
    }
    chars += x;
    if (v <= WIDTH) {
      i++; chars += v - x;
      lines.append(num);
    }
  }
  return mp(lines, chars);
}

list<pi> vardp(ls arg para, li arg lines, ll WIDTH) {
  /* Computes the minimum variance, constrained to use optimal lines.
   * Minimizing variance is equivalent to minimizing the sum of squares,
   * if the number of lines is constrained. */
  list<pi> dp = {mp(0, 0)}; ll i, j, x, v, k, kj, sum_x2, sum_x2j;
  for (i = 1; i < len(para) + 1; i++) {
    k = 0; x = 0; sum_x2 = INF;
    for (j = i - 1; j >= 0; j--) {
      v = x + (x != 0) + len(para[j]);
      if (v <= WIDTH) {
        x = v;
        kj = dp[j].fi; sum_x2j = dp[j].se;
        sum_x2j += x*x;
        if (sum_x2j < sum_x2 and lines[j] + 1 == lines[i]) {
          k = j; sum_x2 = sum_x2j;
        }
      }
      else {
        break;
      }
    }
    dp.append(mp(k, sum_x2));
  }
  return dp;
}

ll process_dp(ls arg para, li arg lines, ll chars, list<pi> arg dp, ll WIDTH) {
  /* Finds an ending index to minimize variance, ignoring the last line. */
  // if the paragraph is less than three lines long, don't ignore the last line
  if (lines.last <= 3) {
    return len(para);
  }
  ll i, x, kl, kg; pi bestl, bestg, mean, var;
  // find best last line starting point, initialize best to infinity (1/0)
  // maintain two solutions: last line shorter than average, last line greater
  bestl = mp(1, 0); bestg = mp(1, 0); kl = 0; kg = 0; x = 0;
  for (i = len(para) - 1; i >= 0; i--) {
    x += (x != 0) + len(para[i]);
    if (x > WIDTH) {
      break;
    }
    // Var[X] = E[X^2] - E[X]^2
    mean = mp(chars - x, lines[i]);
    var = sub(mp(dp[i].se, lines[i]), mul(mean, mean));
    if (lines[i] + 1 == lines.last) {
      if (det(mp(x, 1), mean) <= 0) {
        if (cmp(var, bestl)) {
          bestl = var; kl = i;
        }
      }
      else {
        if (cmp(var, bestg)) {
          bestg = var; kg = i;
        }
      }
    }
  }
  // use shorter last line if it exists, otherwise default to greater
  return (bestl.se != 0) ? kl : kg;
}

pair<ls, str> parse_prefix(ls arg lines, ll WIDTH) {
  /* Parses lines into a list of tokens, taking into account prefixes. */
  // find prefix, where a prefix is defined as a series
  // of the same character, if the character is in PREFIX
  ls para; str prefix; ll ch; bool end = false;
  for (ch = 0; ch < len(lines[0]); ch++) {
    if (not in (lines[0][ch], PREFIX)) {
      break;
    }
    For(line, lines) {
      if (ch >= len(line) or line[ch] != lines[0][ch]) {
        end = true;
        break;
      }
    }
    if (end) {
      break;
    }
    else {
      prefix += lines[0][ch];
    }
  }
  // remove prefix from each line and load into tokens
  WIDTH -= len(prefix);
  For(line, lines) {
    istringstream ss(line.substr(len(prefix)));
    if (len(line) != 0) {
      str token;
      while (ss >> token) {
        if (len(token) > WIDTH) {
          print("AssertionError: word too long: " + token);
        }
        assert(len(token) <= WIDTH);
        para.append(token);
      }
    }
  }
  return mp(para, prefix);
}

void process(ls arg lines, ll WIDTH) {
  /* Processes lines into a final paragraph and prints it out. */
  ls para; str prefix; list<pi> dp; ll i, j, k, chars; li line_lengths, out;
  tie(para, prefix) = parse_prefix(lines, WIDTH);    // process prefix
  WIDTH -= len(prefix);                              // don't include prefix
  tie(line_lengths, chars) = get_lines(para, WIDTH); // generate line lengths
  dp = vardp(para, line_lengths, WIDTH);             // run dynamic programming
  k = process_dp(para, line_lengths, chars, dp, WIDTH); // process output

  // generate indexes in reverse order
  out = {k};
  while (out.last > 0) {
    out.append(dp[out.last].fi);
  }
  // print out each line, given by contiguous segments of the paragraph
  for (i = len(out) - 1; i > 0; i--) {
    cout << prefix;
    for (j = out[i]; j < out[i - 1] - 1; j++) {
      cout << para[j] << ' ';
    }
    print(para[out[i - 1] - 1]);
  }
  // print last line, if it exists
  if (k < len(para)) {
    cout << prefix;
    for (i = k; i < len(para) - 1; i++) {
      cout << para[i] << ' ';
    }
    print(para.last);
  }
}

int main(int argc, char* argv[]) {
  ios::sync_with_stdio(false); cin.tie(NULL); // fast cin

  // read command line arguments - one parameter, WIDTH
  ll WIDTH = (argc > 1) ? (ll) stoi(argv[1]) : 79;

  // read input into paragraph blocks, maintaing empty lines
  ls lines;
  for (str line; getline(cin, line);) {
    if (len(line) > 0) {
      lines.append(line);
    }
    else {
      if (len(lines) > 0) {
        process(lines, WIDTH);
      }
      lines.clear();
      cout << el;
    }
  }
  if (len(lines) > 0) {
    process(lines, WIDTH);
  }

  return 0;
}

