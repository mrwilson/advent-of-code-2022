create or replace table instructions(amount int, src int, dst int);
insert into instructions select column0::int, column1::int, column2::int from input;

create table stack_per_row as select unnest(stacks()) as stack;

create table halt as select count(*) as halt from instructions;

with recursive stacks(round, stack_id, stack1, stack2) as (
  select 0, rowid+1, stack, stack from stack_per_row
union all
  select
    stacks.round+1,
    stacks.stack_id,
    CASE
      WHEN stacks.stack_id == ins.dst AND source.stack1 is not null then stacks.stack1 || reverse(source.stack1[-ins.amount:])
      WHEN stacks.stack_id == ins.src then stacks.stack1[:-ins.amount]
      ELSE stacks.stack1
    END,
    CASE
      WHEN stacks.stack_id == ins.dst AND source.stack2 is not null then stacks.stack2 || source.stack2[-ins.amount:]
      WHEN stacks.stack_id == ins.src then stacks.stack2[:-ins.amount]
      ELSE stacks.stack2
    END
  from
    stacks
  join
    halt on (stacks.round <= halt.halt)
  left join
    instructions ins on (stacks.round == ins.rowid and stacks.stack_id in (ins.src, ins.dst))
  left join
    stacks source on (source.round == stacks.round and source.stack_id = ins.src)
  left join
    stacks dst on (dst.round == stacks.round and dst.stack_id = ins.dst)
),
top_crates(part1, part2) as (
    select stack1[-1:] as part1, stack2[-1:] as part2
    from stacks, halt
    where stacks.round == halt.halt
    order by stacks.stack_id
)
select
    string_agg(part1, '') as part1,
    string_agg(part2, '') as part2
from
    top_crates;