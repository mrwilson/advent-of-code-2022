#!/bin/bash

source utils/run-test.sh

for DAY in $(ls -d [0-9][0-9]); do
  echo "### Day ${DAY}"
  run_test ${DAY}
  echo
done

