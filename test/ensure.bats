#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/../lib/helpers.bash"

@test "ensure includes the given command on success" {
  result="$(ensure "echo '2^8' | bc")"
  [[ "$result" =~ "echo '2^8' | bc" ]]
}

@test "ensure doesn't include the command's output on success" {
  result="$(ensure "echo '2^8' | bc")"
  [[ ! "$result" =~ "256" ]]
}

@test "ensure doesn't include info on success" {
  run ensure "test -f non_existant_file" "touch non_existant_file"
  [[ ! "$result" =~ "touch non_existant_file" ]]
}

@test "ensure includes 'done' on success" {
  result="$(ensure "echo '2^8' | bc")"
  [[ "$result" =~ "done" ]]
}

@test "ensure fails when the command fails" {
  run ensure "test -f non_existant_file"
  [ "$status" -ne 0 ]
}

@test "ensure includes the given command on failure" {
  run ensure "test -f non_existant_file"
  [[ "$output" =~ "test -f non_existant_file" ]]
}

@test "ensure doesn't include the command's output on failure" {
  run ensure "car non_existant_file"
  [[ ! "$output" =~ "cat: non_existant_file" ]]
}

@test "ensure includes info on failure" {
  run ensure "test -f non_existant_file" "touch non_existant_file"
  [[ "$output" =~ "touch non_existant_file" ]]
}

@test "ensure includes 'error' on failure" {
  run ensure "test -f non_existant_file"
  [[ "$output" =~ "error" ]]
}

# vim: ft=sh
