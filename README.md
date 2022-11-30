# advent-of-code-2022

Yeah, I think we're back.

This year I'll be using SQL (again) but with [DuckDB](https://duckdb.org/) rather than SQLite.

We've got a neat little [TAP](https://testanything.org/)-compatible test framework using DuckDB's macros.

```sql
.read testing.sql
.read 00/00.sql

select run_all([
  assert_equals(fuel(14), 2, '14 weight needs 2 fuel'),
  assert_equals(fuel(1969), 654, '1969 weight needs 654 fuel')
]);
```

```
1..2
ok - 14 weight needs 2 fuel
ok - 1969 weight needs 654 fuel
```