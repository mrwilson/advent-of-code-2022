create or replace table signals as
    select rowid as datastream, unnest(str_split(line,'')) as char from input;

prepare find_group as
    with stream(datastream, group) as (
        select
            datastream, string_agg(char, '')
        over (
            partition by datastream rows between current row and ($1 - 1) following
        )
        from signals
    ),
    groups(datastream, char, group_id) as (
        select
            datastream, unnest(str_split(group,'')), row_number()
        over (
            partition by datastream
        )
        from
            stream
        where
            length(group) == $1
    )
    select distinct
        datastream, min(group_id + $1 - 1)
    over
        (partition by datastream)
    from
        groups
    group by
        datastream, group_id
    having
        count(distinct char) == $1
;