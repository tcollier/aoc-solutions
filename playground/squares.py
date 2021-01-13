# def old_count_squares(num_squares, counts):
#     counts.add(num_squares)
#     if num_squares < 100:
#         for i in range(2, 6):
#             count_squares(num_squares + 2 * i - 1, counts)
#     return counts


# values = [i for i in old_count_squares(1, set())]
# values.sort()
# print(values)


def count_squares(valid, index):
    if index >= len(valid) or valid[index]:
        return
    valid[index] = True
    for n in range(2, 50):
        count_squares(valid, index + 2 * n - 1)


MAX_VALUE = 100
valid = [False] * (MAX_VALUE + 1)
valid[0] = True
count_squares(valid, 1)
valid_values = set([i for i, v in enumerate(valid) if v])
invalid_values = [i for i in range(len(valid)) if i not in valid_values]
invalid_values.sort()
print(invalid_values)
