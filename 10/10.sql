create or replace table crt as with recursive cpu(clock, round, register, in_progress) as (
    select 1, 0, 1, null
    union all

    select
        clock+1,
        CASE
            WHEN in_progress is not null then round+1
            WHEN instruction[1:4] == 'noop' then round+1
            ELSE round
        END,
        CASE
            WHEN in_progress is not null THEN register+in_progress
            ELSE register
        END,
        CASE
            WHEN in_progress is not null then null
            WHEN instruction[1:4] == 'addx' THEN instruction[5:]::integer
            ELSE null
        END
    from
        cpu
    left join input on
        (round == input.rowid)
    where
        instruction is not null
) select clock, register from cpu;

select 'part1', sum(clock * register) from crt where clock in (20, 60, 100, 140, 180, 220);

select
    'part2',
    (clock - 2) / 40,
    string_agg(CASE WHEN register BETWEEN (clock - 2) % 40 AND (clock)%40 THEN '#' ELSE '.' END, '')
from
    crt
group by 1,2;
