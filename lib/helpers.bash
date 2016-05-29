#!/usr/bin/env bash

title() { echo -e "\033[0;34m\n${1}\n\033[0m"; }

check() {
  echo -n "$1... "
  if (exec &>/dev/null; eval $1); then
    echo -e "\033[0;32m✓ done\033[0m"
  else
    echo -e "\033[0;31m✗ error!$([ -z "$2" ] || echo "\nTry: $2")" && exit 1
  fi
}

cached() {
  [ -e "$1" ] || return 1
  local cache="$(cat ".cache.${1//\//_}" 2>/dev/null)"
  local new_cache=$(find "$1" -exec cat {} \; | shasum)
  echo "$new_cache" > ".cache.${1//\//_}" && [[ "$new_cache" == "$cache" ]]
}
