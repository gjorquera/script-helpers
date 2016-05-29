#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/../lib/helpers.bash"

@test "title includes the given argument" {
  result="$(title "my custom title")"
  [[ "$result" =~ "my custom title" ]]
}

# vim: ft=sh
