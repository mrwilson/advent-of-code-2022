function run_test() {
  DAY=$1

  duckdb -list -noheader -c ".read ${DAY}/${DAY}_test.sql" | sed -e 's/\\n/\n/g'
}