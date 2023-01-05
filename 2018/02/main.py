#!/usr/bin/env python3
# Usage:
#    ./main.py < input.txt

import sys
from functools import reduce
from typing import Optional

lines = tuple(map(lambda s: s.strip(), filter(lambda l: len(l) > 0, sys.stdin)))

two_letter_lines = set()
three_letter_lines = set()
for line in lines:
    chars = set(line)
    for char in chars:
        c = line.count(char)
        if c == 2:
            two_letter_lines.add(line)
        elif c == 3:
            three_letter_lines.add(line)

part1_solution = len(two_letter_lines) * len(three_letter_lines)
print(f'Part 1: {part1_solution}')

def is_companion_id(original: str, candidate: str) -> Optional[int]:
    if len(original) != len(candidate):
        return False

    first_different_char_index = None
    for index, char in enumerate(original):
        candidate_char = candidate[index]
        if candidate_char != char:
            if first_different_char_index is not None:
                return None
            first_different_char_index = index
    return first_different_char_index

part2_solution = None
for line in lines:
    for candidate in lines:
        if line == candidate:
            continue
        different_index = is_companion_id(line, candidate)
        if different_index is not None:
            part2_solution = line[:different_index] + line[different_index + 1:]
            break
    if part2_solution is not None:
        break

print(f'Part 2: {part2_solution}')
