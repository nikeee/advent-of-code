#!/usr/bin/env python3
# Usage:
#    ./main.py < input.txt

import sys
from functools import reduce
from typing import Optional, List, NamedTuple

lines = tuple(map(lambda s: s.strip(), filter(lambda l: len(l) > 0, sys.stdin)))

# The input is not sorted by date
# Luckily, the timestamps are in ISO 6801, so we can just sort by the string value
lines = sorted(lines)

guard_sleep_times = dict()

current_guard = None
sleep_start = None
for line in lines:
    ts_data, event_data = line.split(']')
    ts_data, event_data = ts_data.strip(), event_data.strip()
    date, time = ts_data.split(' ')

    overflow = True if time[0] == 2 else False
    minute = int(time.split(':')[1])
    if overflow:
        minute = 0

    if event_data[0] == 'G':
        current_guard = int(event_data.split('#')[1].split(' ')[0])
    elif event_data[0] == 'f':
        sleep_start = minute
    elif event_data[0] == 'w':
        plan = guard_sleep_times.get(current_guard, [0] * 60)
        for m in range(sleep_start, minute):
            plan[m] += 1
        guard_sleep_times[current_guard] = plan


best_time = 0
max_sleep_minutes = -1
best_guard = None
for guard, plan in guard_sleep_times.items():
    total_asleep = sum(plan)
    if total_asleep > max_sleep_minutes:
        max_sleep_minutes = total_asleep
        best_guard = guard
        best_time = plan.index(max(plan))

print(f'Guard with most sleeping time; Part 1: {best_time * best_guard}')

max_max_asleep = -1
max_max_asleep_index = -1
best_guard = None
for guard, plan in guard_sleep_times.items():
    max_asleep = max(plan)
    if max_asleep > max_max_asleep:
        best_guard = guard
        max_max_asleep = max_asleep
        max_max_asleep_index = plan.index(max_asleep)

print(f'Guard with time slot that he slept the most; Part 2: {max_max_asleep_index * best_guard}')
