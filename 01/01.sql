-- Append a dummy null to the end of the table
-- to avoid special-casing the final elf
insert into input VALUES(NULL);

-- Identify the boundaries between each elf
with breaks(line) as (
  select rowid from input where column0 is null
),

-- Turn boundaries into pairs of (top, bottom)
-- indices in the table
bounds(top, bottom) as (
  select line, lag(line, 1, 0) over () from breaks
),

-- Join and sum over the pairs of (top, bottom)
-- to find total calories per elf
elves(top, calories) as (
  select
    bounds.top, sum(column0)
  from
    bounds
  join
    input
  on
    input.rowid between bounds.bottom and bounds.top
  group by 1
)

-- What's the most calories held by a single elf?
select 'part 1', max(calories) from elves

union all

-- What's the total calories held by the elves with
-- the top 3 most calories?
select 'part 2', sum(calories) from (
  select calories from elves order by calories desc limit 3
);