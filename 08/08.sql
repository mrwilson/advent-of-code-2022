create or replace table input_size as
    select max(length(row)) as x_max, count(*) as y_max from input;

create or replace table trees as with dimensions(x, y) as (
        select
            x.range, y.range
        from
            range(0, 100) x, range(0, 100) y, input_size
        where
            x.range <= x_max and y.range <= y_max
    )
    select x, y, row[x] as height from dimensions, input where input.rowid+1 == y;

with distance_to_tree(x, y, u, r, l, d) as (
    select
        one.x,
        one.y,
        min(one.y - two.y) filter(one.y > two.y), min(two.x - one.x) filter(one.x < two.x),
        min(one.x - two.x) filter(one.x > two.x), min(two.y - one.y) filter(one.y < two.y)
    from
        trees one, trees two, input_size
    where
        (one.x == two.x or one.y == two.y) and
        (one.x, one.y) != (two.x, two.y) and
        one.x not in (1, x_max) and
        one.y not in (1, y_max) and
        one.height <= two.height
    group by
        one.x, one.y
)
select
    'part1', 2*(x_max-1) + 2*(y_max - 1) + visible_trees as answer
from
    (select count(*) as visible_trees from distance_to_tree where (u * r * l * d) is null),
    input_size

union all

select
    'part2', max(coalesce(u, y-1) * coalesce(r, x-x_max) * coalesce(l, x-1) * coalesce(d, y-y_max)) as answer
from
    distance_to_tree, input_size;