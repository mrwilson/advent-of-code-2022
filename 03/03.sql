create or replace table items as (
    with pouches(rucksack, front, back) as (
        select
            rowid,
            array_slice(line, 0, length(line)/2),
            array_slice(line, length(line)/2+1, NULL)
        from
            input
    )
    select rucksack, 'front' as pouch, unnest(str_split(front, '')) as item from pouches
    union all
    select rucksack, 'back' as pouch, unnest(str_split(back, '')) as item from pouches
);

create or replace macro letter_to_value(letter) as
    case
        when letter between 'a' and 'z' then ascii(letter)-96
        else ascii(letter)-38
    end;

-- Part 1
with duplicates(rucksack, item) as (
    select
        distinct one.rucksack, one.item
    from
        items one
    join
        items two
    on (one.rucksack == two.rucksack and one.pouch != two.pouch and one.item == two.item)
) select 'part1', sum(letter_to_value(item)) from duplicates;

-- Part 2
with unique_per_elf(rucksack, item) as (
    select distinct rucksack, item from items
),
duplicates(item) as (
    select item from unique_per_elf group by rucksack/3, item having count(*) == 3
)
select 'part2', sum(letter_to_value(item)) from duplicates;