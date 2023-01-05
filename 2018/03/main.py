#!/usr/bin/env python3
# Usage:
#    ./main.py < input.txt

import sys
from functools import reduce
from typing import Optional, NamedTuple

lines = tuple(map(lambda s: s.strip(), filter(lambda l: len(l) > 0, sys.stdin)))

class Claim(NamedTuple):
    id: int
    x: int
    y: int
    width: int
    height: int

def parse_claim(line: str):
    id_data, data = line.split('@')
    _, claim_id = id_data.split('#')
    pos, size = data.split(':')
    x, y = pos.split(',')
    x, y = x.strip(), y.strip()
    width, height = size.split('x')
    width, height = width.strip(), height.strip()
    return Claim(int(claim_id), int(x), int(y), int(width), int(height))

claims = tuple(map(parse_claim, lines))

FIELD_SIZE = 1000
field = [[set() for x in range(FIELD_SIZE)] for y in range(FIELD_SIZE)]

for c in claims:
    for x in range(c.x, c.x + c.width):
        for y in range(c.y, c.y + c.height):
            field[x][y].add(c)

overlaps = 0
for x in range(0, FIELD_SIZE):
    for y in range(0, FIELD_SIZE):
        if len(field[x][y]) > 1:
            overlaps += 1

print(f'Number of overlapping square inches; Part 1: {overlaps}')

overlapping_claims = set()
for x in range(0, FIELD_SIZE):
    for y in range(0, FIELD_SIZE):
        if len(field[x][y]) > 1:
            overlapping_claims.update(field[x][y])

non_overlapping_claims = tuple(filter(lambda c: c not in overlapping_claims, claims))
assert len(non_overlapping_claims) == 1

print(f'Claim ID of single claim that does not overlap; Part 2: {non_overlapping_claims[0].id}')
