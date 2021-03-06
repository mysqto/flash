# Flash

![Screenshot](https://mysqto.github.io/flash/screenshot/flash.png)

## Install

`fisher add mysqto/flash`

## Features

_From left to right:_

+ `$HOME` directory abbreviated to `( ⌁ )`
+ `/` root is diplayed as `( / )`
+ `$HOME` and `/` characters change color to dim gray if last `$status`  was `!=` 0.
+ Path to current working directory is abbreviated.
+ Path and prompt separator is displayed as `)`.
+ `<` character next to `(branch)` denotes the repository has [_stashed_](https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing) changes.
+ `*` next to the branch name denotes the current repository is dirty.
+ Display current git status.
+ Display current time.
+ Time separator `:` changes color to red if last `$status`  was `!=` 0.
+ Display exit status for non zero codes after `≡` character.
+ Colors inspired by _The Flash_.
+ Display the number of seconds taken by the last command executed.

![command time](https://mysqto.github.io/flash/screenshot/flash_time.png)