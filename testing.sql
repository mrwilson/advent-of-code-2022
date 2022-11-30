create macro assert_equals(a, b, description) as (
    case
        when a == b then 'ok'
        else 'not ok'
    end
)||' - '||description;

create macro assert_not_equals(a, b, description) as (
    case
        when a != b then 'ok'
        else 'not ok'
    end
)||' - '||description;

create macro execute_tests(test) as (
    select '1..' || count(test) || '\n' || string_agg(test, '\n')
);

create macro run_all(all_tests) as (
    with tests as (
        select unnest(all_tests) as result
    )
    select execute_tests(result) from tests
);