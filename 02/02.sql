create table scoring(them char, you char, part1 int, part2 int);

insert into scoring values
  ('A','X',4,3), ('A','Y',8,4), ('A','Z',3,8),
  ('B','X',1,1), ('B','Y',5,5), ('B','Z',9,9),
  ('C','X',7,2), ('C','Y',2,6), ('C','Z',6,7);

with plays(them, you) as (
  select line[1], line[-1] from input
)
select
  sum(part1) as part1,
  sum(part2) as part2
from
  plays
join
  scoring
on (plays.them == scoring.them AND plays.you == scoring.you);