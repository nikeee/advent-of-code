#!/usr/bin/env python3
# Usage:
#    ./main.py < input.txt

import sys
from functools import reduce

lines = tuple(map(lambda s: s.strip(), filter(lambda l: len(l) > 0, sys.stdin)))

def compute_state(state: int, element: str) -> int:
    op = element[0]
    amount = int(element[1:])
    return state + (
        amount if op == '+' else -amount
    )

part1_solution = reduce(compute_state, lines, 0)
print(f'Part 1: {part1_solution}')

frequencies = set()
current_frequency = 0

twice_frequency = None
while twice_frequency is None:
    for line in lines:
        current_frequency = compute_state(current_frequency, line)
        if current_frequency in frequencies:
            twice_frequency = current_frequency
            break
        frequencies.add(current_frequency)

print(f'Part 2: {twice_frequency}')

