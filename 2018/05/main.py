#!/usr/bin/env python3

import sys
from functools import reduce
from typing import Optional, List, NamedTuple

lines = tuple(map(lambda s: s.strip(), filter(lambda l: len(l) > 0, sys.stdin)))

def process_step(polymer):
    next_polymer = ''

    i = 0
    while i < len(polymer):
        if i + 1 < len(polymer):
            current_unit, next_unit = polymer[i], polymer[i + 1]
            if next_unit.upper() == current_unit.upper() and \
                ((current_unit.islower() and next_unit.isupper()) or (current_unit.isupper() and next_unit.islower())):
                next_polymer += ''
                i += 2
            else:
                next_polymer += current_unit
                i += 1
        else:
            next_polymer += polymer[i]
            i += 1
    return next_polymer


def do_iterative_reaction(polymer: str):
    next_polymer = None
    while True:
        prev_len = len(polymer)
        polymer = process_step(polymer)
        new_len = len(polymer)
        if new_len == prev_len:
            return polymer


def remove_unit(polymer: str, unit: str):
    return polymer.replace(unit.upper(), '').replace(unit.lower(), '')


length_of_polymer = len(do_iterative_reaction(lines[0]))
print(f'Length of last polymer; Part 1: {length_of_polymer}')


polymer = lines[0]
units_to_remove = set(polymer.lower())
shortest_polymer_length = min(
        map(
            len,
            map(
                do_iterative_reaction,
                map(lambda unit: remove_unit(polymer, unit), units_to_remove)
            )
        )
    )

print(f'Length of shortest polymer; Part 2: {shortest_polymer_length}')
