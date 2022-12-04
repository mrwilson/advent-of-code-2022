create or replace table elves as (
    select
        str_split(column0,'-')[1]::INTEGER as lower1,
        str_split(column0,'-')[2]::INTEGER as upper1,
        str_split(column1,'-')[1]::INTEGER as lower2,
        str_split(column1,'-')[2]::INTEGER as upper2,
    from
        input
);

select
    count(*) filter ((lower2 - lower1) * (upper2 - upper1) <= 0) as part1,
    count(*) filter (upper1 >= lower2 and lower1 <= upper2) as part2
from
    elves;