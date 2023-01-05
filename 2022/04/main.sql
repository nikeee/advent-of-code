-- Run:
--     sqlite3 :memory: < main.sql
-- Runtime version:
--     sqlite3 --version
--     3.31.1 2020-01-27 19:55:54 3bfa9cc97da10598521b342961df8f5f68c7388fa117345eeb516eaa837balt1

create table assignments (
    first_assignment text not null,
    second_assignment text not null
);

.separator ","
.import input.txt assignments
.separator "\t"
.mode line

create table parsed_assignments as
select
    cast(substr(first_assignment, 0, instr(first_assignment, '-')) as int) as first_start,
    cast(substr(first_assignment, instr(first_assignment, '-') + 1) as int) as first_end,
    cast(substr(second_assignment, 0, instr(second_assignment, '-')) as int) as second_start,
    cast(substr(second_assignment, instr(second_assignment, '-') + 1) as int) as second_end
from assignments;


select count(*) as 'Number of contained assignments; Part 1' from parsed_assignments
where
    (first_start <= second_start and second_end <= first_end)
    or
    (second_start <= first_start and first_end <= second_end);

select count(*) as 'Number of overlapping assignments; Part 2' from parsed_assignments
where
    (first_start <= second_start and second_start <= first_end) or (second_start <= first_end and first_end <= second_end)
    or
    (first_start <= second_end and second_end <= first_end) or (second_start <= first_start and first_start <= second_end);
