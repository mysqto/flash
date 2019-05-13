# Flash

<p align="center">
<img src="https://mysqto.github.io/flash/screenshot/flash.png">
</p>

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
+ Display current branch.
+ Display current time.
+ Time separator `:` changes color to red if last `$status`  was `!=` 0.
+ Display exit status for non zero codes after `≡` character.
+ Colors inspired by _The Flash_.
+ Display the number of seconds taken by the last command executed.

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/8317250/7787589/431f2efa-024f-11e5-9715-df3e1833e174.png">
</p>
