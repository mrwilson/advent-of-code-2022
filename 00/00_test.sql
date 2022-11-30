.read testing.sql
.read 00/00.sql

select run_all([
  assert_equals(fuel(14), 2, '14 weight needs 2 fuel'),
  assert_equals(fuel(1969), 654, '1969 weight needs 654 fuel')
]);