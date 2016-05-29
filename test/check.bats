#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/../lib/helpers.bash"

@test "check includes the given command on success" {
  result="$(check "echo '2^8' | bc")"
  [[ "$result" =~ "echo '2^8' | bc" ]]
}

@test "check doesn't include the command's output on success" {
  result="$(check "echo '2^8' | bc")"
  [[ ! "$result" =~ "256" ]]
}

@test "check doesn't include info on success" {
  run check "test -f non_existant_file" "touch non_existant_file"
  [[ ! "$result" =~ "touch non_existant_file" ]]
}

@test "check includes 'done' on success" {
  result="$(check "echo '2^8' | bc")"
  [[ "$result" =~ "done" ]]
}

@test "check fails when the command fails" {
  run check "test -f non_existant_file"
  [ "$status" -ne 0 ]
}

@test "check includes the given command on failure" {
  run check "test -f non_existant_file"
  [[ "$output" =~ "test -f non_existant_file" ]]
}

@test "check doesn't include the command's output on failure" {
  run check "car non_existant_file"
  [[ ! "$output" =~ "cat: non_existant_file" ]]
}

@test "check includes info on failure" {
  run check "test -f non_existant_file" "touch non_existant_file"
  [[ "$output" =~ "touch non_existant_file" ]]
}

@test "check includes 'error' on failure" {
  run check "test -f non_existant_file"
  [[ "$output" =~ "error" ]]
}

# vim: ft=sh
