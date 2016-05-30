# Scripts To Rule Them All Helpers

A simple helper script that can sourced into your project scripts to
enable easy checks and caches.

If you don't know what project scripts are, please read
[scripts-to-rule-them-all](https://github.com/github/scripts-to-rule-them-all).

## Example

This is how it looks then a project script is executed:

![screencast](images/screencast.gif)

This is the source file of the project script:

```bash
#!/usr/bin/env bash
cd "$(dirname $0)/.."
[ -f ".h" ] || curl -o ".h" -L https://git.io/vrHby; . ".h"

RAILS_ENV=${RAILS_ENV:-development}

title "Checking system dependencies..."

check "which heroku" "brew install heroku-toolbelt"
check "which identify" "brew install imagemagick"
check "which phantomjs" "brew install phantomjs"

title "Setting up pow..."

check "which pow" "brew install pow"
check "test -d $HOME/.pow" "brew info pow"
check "echo 5000 > $HOME/.pow/kipict"

title "Setting up ruby..."

check "which ruby" "brew install rbenv"
check "which bundle" "gem install bundler"
check "cached Gemfile || bundle install"

title "Setting up postgres..."

check "which psql" "brew install postgresql"
check "echo '\\l' | psql postgres" "postgres -D /opt/boxen/homebrew/var/postgres"
check "echo '\\l' | psql postgres | grep kipict_$RAILS_ENV" \
  "heroku local:run rake db:create"
check "cached db/migrate || heroku local:run rake db:migrate"

title "Setting up redis..."

check "which redis-server" "brew install redis"
check "redis-cli ping | grep PONG" "redis-server /opt/boxen/homebrew/etc/redis.conf"
```

## Helpers

### `title`

Used to group several `check`s under the same concept:

```bash
title "Checking system dependencies..."
```

### `check`

Checks if a given command is successful and prints it's status along
with a short message on error.

```bash
check "which identify"
```

```bash
check "test -d $HOME/.pow" "brew info pow"
```

### `cached`

Caches the contents of a file or directory, returning whether the
existing cache was updated or not.

It should be used inside a `check` to allow faster checks, and avoid
running time consuming commands if the file or directory used to run
that command hasn't changed.

```bash
check "cached Gemfile || bundle install"
```

```bash
check "cached db/migrate || heroku local:run rake db:migrate"
```

## Installation

Just include the following lines at the top of your script (make sure
you're using `bash` as the interpreter):

```bash
#!/usr/bin/env bash
cd "$(dirname $0)"
[ -f ".h" ] || curl -o ".h" -L https://git.io/vrHby; . ".h"
```

It's important to add the `cd "$(dirname $0)"` at the beginning because
the helpers and cache files are installed in the current working
directory.

Don't forget to add `.cache.*` and `.h` to your `.gitignore` file:

```bash
echo ".cache.*" >> .gitignore
echo ".h" >> .gitignore
```

## Update

If you want to update the helpers file, just remove the cached helpers:

```bash
rm -f path/to/script/dirname/.helpers
```
