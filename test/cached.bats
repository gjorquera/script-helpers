#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/../lib/helpers.bash"

setup() {
  cd $BATS_TMPDIR
  echo "My Contents" > file
  cached file || true
}

teardown() {
  rm -f file
  rm -f .cache.*
}

@test "cached succeeds if contents aren't modified" {
  run cached file
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "cached fails if contents are modified" {
  echo "Modifications" >> file
  run cached file
  [ "$status" -ne 0 ]
  [ "$output" = "" ]
}

@test "cached fails if cache doesn't exist" {
  echo "My Contents" > uncached
  run cached uncached
  [ "$status" -ne 0 ]
  [ "$output" = "" ]
}

@test "cached fails if file doesn't exist" {
  run cached missing
  [ "$status" -ne 0 ]
  [ "$output" = "" ]
}

# vim: ft=sh
