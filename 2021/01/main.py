lines = [int(l.rstrip()) for l in open("./input.txt", "r").readlines()]


inc_count = 0
for line_no in range(len(lines) - 1):
    if lines[line_no + 1] > lines[line_no]:
        inc_count += 1
print(inc_count)


sliding_inc_count = 0
sliding_sums = []
for line_no in range(2, len(lines)):
    sliding_sums.append(lines[line_no - 2] + lines[line_no - 1] + lines[line_no])
for sliding_line_no in range(len(sliding_sums) - 1):
    if sliding_sums[sliding_line_no + 1] > sliding_sums[sliding_line_no]:
        sliding_inc_count += 1
print(sliding_inc_count)
