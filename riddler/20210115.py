import math

from functools import reduce

# def factorize(num):
#     for div in range(2, math.floor(math.sqrt(num)) + 1):
#         if num % div == 0:
#             return [div, *factorize(num // div)]
#     return [num]


# def _partition(factors: list, partition: list, partitions: set):
#     if not factors:
#         solution = [f for f in partition]
#         solution.sort()
#         partitions.add(tuple(solution))
#         return
#     next_factor = factors.pop()
#     for i in range(len(partition)):
#         if partition[i] * next_factor < 10:
#             partition[i] *= next_factor
#             _partition(factors, partition, partitions)
#             partition[i] //= next_factor
#     factors.append(next_factor)


# def partition_factors(num, num_partitions):
#     factors = factorize(num)
#     partitions = set()
#     partition = [1] * num_partitions
#     _partition(factors, partition, partitions)
#     return partitions


def _permute(factors, number, numbers):
    if not factors:
        numbers.add(str(number))
        return
    for i in range(len(factors)):
        next_factor = factors.pop(i)
        _permute(factors, number * 10 + next_factor, numbers)
        factors.insert(i, next_factor)


def permute_factors(factors):
    numbers = set()
    _permute(list(factors), 0, numbers)
    return numbers


factors = {
    294: {(6, 7, 7)},
    216: {(3, 8, 9), (4, 6, 9), (6, 6, 6)},
    135: {(3, 5, 9)},
    98: {(2, 7, 7)},
    112: {(4, 4, 7), (2, 7, 8)},
    84: {(2, 6, 7), (3, 4, 7)},
    245: {(5, 7, 7)},
    40: {(1, 5, 8), (2, 4, 5)},
    8890560: {(5, 7, 7, 7, 8, 8, 9, 9)},
    156800: {
        (1, 4, 4, 5, 5, 7, 7, 8),
        (2, 4, 4, 4, 5, 5, 7, 7),
        (1, 2, 5, 5, 7, 7, 8, 8),
        (2, 2, 4, 5, 5, 7, 7, 8),
    },
    55566: {
        (1, 1, 3, 6, 7, 7, 7, 9),
        (1, 3, 3, 3, 6, 7, 7, 7),
        (1, 1, 2, 7, 7, 7, 9, 9),
        (1, 2, 3, 3, 7, 7, 7, 9),
        (2, 3, 3, 3, 3, 7, 7, 7),
    },
}

ROWS = [294, 216, 135, 98, 112, 84, 245, 40]
COLS = [8890560, 156800, 55566]

possible_rows = [set() for _ in range(len(ROWS))]
possible_cols = [set() for _ in range(len(COLS))]

for row_num, product in enumerate(ROWS):
    for facts in factors[product]:
        for number in permute_factors(facts):
            possible_rows[row_num].add(number)

for col_num, product in enumerate(COLS):
    for facts in factors[product]:
        for number in permute_factors(facts):
            possible_cols[col_num].add(number)

changed = True
while changed:
    changed = False
    for row_num in range(len(ROWS)):
        for col_num in range(len(COLS)):
            allowed_digits = set([num[col_num] for num in possible_rows[row_num]])
            allowed_digits = allowed_digits.intersection(
                set([num[row_num] for num in possible_cols[col_num]])
            )
            remove_rows = set()
            for allowed_row in possible_rows[row_num]:
                if allowed_row[col_num] not in allowed_digits:
                    changed = True
                    remove_rows.add(allowed_row)
            possible_rows[row_num] = possible_rows[row_num].difference(remove_rows)
            remove_cols = set()
            for allowed_col in possible_cols[col_num]:
                if allowed_col[row_num] not in allowed_digits:
                    changed = True
                    remove_cols.add(allowed_col)
            possible_cols[col_num] = possible_cols[col_num].difference(remove_cols)


def validate_solution(solution):
    for i, row in enumerate(solution):
        product = (row % 10) * ((row // 10) % 10) * (row // 100)
        if product != ROWS[i]:
            return False
    ones_product = 1
    tens_product = 1
    huns_product = 1
    for row in solution:
        ones_product *= row % 10
        tens_product *= (row // 10) % 10
        huns_product *= row // 100
    if ones_product != COLS[2]:
        return False
    if tens_product != COLS[1]:
        print(tens_product, COLS[1])
        return False
    if huns_product != COLS[0]:
        return False
    return True


num_solutions = reduce(lambda a, b: a * b, [len(r) for r in possible_rows])
if num_solutions == 0:
    print("no solutions found")
elif num_solutions > 1:
    print(possible_rows)
    print("multiple solutions found")
else:
    solution = [int(r.pop()) for r in possible_rows]
    if not validate_solution(solution):
        print("invalid solution found")
    else:
        print(solution)
