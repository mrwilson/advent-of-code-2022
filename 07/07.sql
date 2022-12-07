create or replace table commands as
    select rowid as id, line[6:] as dir from input where line[1:4] == '$ cd';

create or replace table current_dir as
    with recursive cwd(i, id, cwd) as (
        select 0, 0, ['']
        union all
        select
            i+1,
            commands.id,
            CASE
                WHEN commands.dir == '..' THEN cwd.cwd[:-1]
                ELSE list_concat(cwd.cwd, [commands.dir])
            END
        from
            cwd
        join
            commands
        on (commands.rowid == cwd.i+1)
    ) select * from cwd;

with recursive last_entry(id) as (
    select max(rowid) from input
),
executing_commands(cwd, top, bottom) as (
    select cwd, current_dir.id, lead(current_dir.id, 1, last_entry.id+1) over() from current_dir, last_entry
),
back_up_tree(dir, file_size) as (
    select distinct
        cwd as dir,
        regexp_extract(line, '([0-9]+) .*',1)::INTEGER as file_size
    from
        executing_commands
    join
        input on (input.rowid BETWEEN top AND bottom-1)
    where
        line SIMILAR TO '[0-9]+ .*'

    union all

    select
        dir[:-1], file_size
    from
        back_up_tree
    where
        length(dir) > 0
),
directory_sizes(size) as (
    select
        sum(file_size) as total
    from
        back_up_tree
    group by dir
)
select 'part1', sum(size) from directory_sizes where size <= 100000

union all

select
    'part2', min(size)
from
    directory_sizes,
    (select
        30000000 - (70000000 - max(size)) space
    from
        directory_sizes
    ) required
where
    size >= required.space;