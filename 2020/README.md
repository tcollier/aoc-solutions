## 2020

That was one hell of a year! Thankfully we had Advent of Code to get us through the home stretch.
Despite a late start (I didn't get to days 1 - 12 until the 12th), I started the latter half of the challenges on time (midnight EST) and worked with some friends over a Google Meet.

## Solution Performance

Since performance varied wildly from day to day (day 0 solutions were all in the nanoseconds range, whereas day 22's python solution took 17 seconds!), pay close attention to the unit of measure for each metric in the list below.

```
PASS [2020/01 c         ] (part1:   3.03 μs, part2:   3.41 μs, overhead:   9.68 ms)
PASS [2020/01 golang    ] (part1:  11.72 μs, part2:   4.94 μs, overhead:  18.27 ms)
PASS [2020/01 java      ] (part1:   6.86 μs, part2:  10.41 μs, overhead: 118.56 ms)
PASS [2020/01 kotlin    ] (part1:   2.89 μs, part2:   2.41 μs, overhead: 156.75 ms)
PASS [2020/01 lisp      ] (part1: 392.28 μs, part2: 143.29 μs, overhead:  31.91 ms)
PASS [2020/01 python    ] (part1:   4.70 μs, part2:  39.76 μs, overhead: 163.72 ms)
PASS [2020/01 ruby      ] (part1:  26.61 μs, part2:  19.92 μs, overhead: 258.25 ms)
PASS [2020/01 rust      ] (part1:   8.07 μs, part2:   3.54 μs, overhead:   9.24 ms)
PASS [2020/01 scala     ] (part1:   4.10 μs, part2:   4.10 μs, overhead: 493.55 ms)
PASS [2020/01 typescript] (part1:   6.02 μs, part2:  27.75 μs, overhead:  67.89 ms)
PASS [2020/02 java      ] (part1:   1.23 ms, part2: 819.67 μs, overhead: 167.67 ms)
PASS [2020/02 python    ] (part1:   4.47 ms, part2:   3.20 ms, overhead:  71.78 ms)
PASS [2020/02 ruby      ] (part1:   3.89 ms, part2:   2.22 ms, overhead: 391.27 ms)
PASS [2020/02 typescript] (part1: 393.70 μs, part2: 221.73 μs, overhead:  56.52 ms)
PASS [2020/03 python    ] (part1: 973.29 μs, part2:   1.17 ms, overhead:  63.20 ms)
PASS [2020/04 python    ] (part1:   1.30 ms, part2:   3.79 ms, overhead:  52.26 ms)
PASS [2020/05 python    ] (part1: 936.14 μs, part2: 932.05 μs, overhead:  54.02 ms)
PASS [2020/06 python    ] (part1:   1.29 ms, part2:   1.43 ms, overhead:  46.23 ms)
PASS [2020/07 python    ] (part1:   3.91 ms, part2:   3.27 ms, overhead:  45.34 ms)
PASS [2020/08 python    ] (part1: 105.00 μs, part2:  13.36 ms, overhead:  49.34 ms)
PASS [2020/09 python    ] (part1: 490.73 μs, part2:   9.63 ms, overhead:  48.83 ms)
PASS [2020/10 python    ] (part1:  17.50 μs, part2:  83.72 μs, overhead:  65.16 ms)
PASS [2020/11 python    ] (part1:   2.67 s,  part2:   2.19 s,  overhead:  45.98 ms)
PASS [2020/12 python    ] (part1: 498.46 μs, part2: 488.88 μs, overhead:  53.34 ms)
PASS [2020/13 python    ] (part1:   7.21 μs, part2: 113.24 μs, overhead:  53.38 ms)
PASS [2020/14 python    ] (part1:   2.01 ms, part2:  55.36 ms, overhead:  43.06 ms)
PASS [2020/15 java      ] (part1:   8.97 μs, part2: 452.93 ms, overhead: 406.65 ms)
PASS [2020/15 python    ] (part1: 284.34 μs, part2:   7.11 s,  overhead:  39.61 ms)
PASS [2020/15 ruby      ] (part1: 229.95 μs, part2:   4.58 s,  overhead: 292.80 ms)
PASS [2020/15 typescript] (part1:  63.69 μs, part2:   4.63 s,  overhead: 170.54 ms)
PASS [2020/16 python    ] (part1:   3.20 ms, part2:  14.78 ms, overhead:  41.05 ms)
PASS [2020/17 python    ] (part1: 147.48 ms, part2:   4.25 s,  overhead:  36.14 ms)
PASS [2020/18 python    ] (part1:  15.91 ms, part2:  17.61 ms, overhead:  47.26 ms)
PASS [2020/18 ruby      ] (part1:   2.98 ms, part2:   3.41 ms, overhead: 267.06 ms)
PASS [2020/19 python    ] (part1:   3.88 ms, part2:  17.94 ms, overhead:  49.37 ms)
PASS [2020/20 python    ] (part1:   5.23 ms, part2: 110.92 ms, overhead:  51.96 ms)
PASS [2020/21 python    ] (part1: 771.94 μs, part2: 688.27 μs, overhead:  45.58 ms)
PASS [2020/22 python    ] (part1:  89.83 μs, part2:  20.22 s,  overhead:  66.12 ms)
PASS [2020/23 java      ] (part1: 998.03 ns, part2: 253.96 ms, overhead: 116.17 ms)
PASS [2020/23 python    ] (part1:  76.40 μs, part2:  10.48 s,  overhead:  67.18 ms)
PASS [2020/24 python    ] (part1:  24.91 ms, part2: 791.53 ms, overhead:  46.57 ms)
PASS [2020/25 python    ] (part1: 281.61 ms, part2: 622.74 ns, overhead: 225.43 ms)
```
