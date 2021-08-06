function fish_add_path -d "add path to fish_user_paths"
  for path in $argv
    test -d "$path"; and  set -U fish_user_paths "$path" $fish_user_paths
  end
end

function git_is_stashed -d "Whether current repo is stashed"
  command git rev-parse --verify --quiet refs/stash >/dev/null 2>&1
end

function git_branch_name -d "Get current working branch name"
  command git symbolic-ref --short HEAD  2> /dev/null; or git rev-parse --short HEAD 2> /dev/null
end

function git_remote_branch_name -d "Get remote branch name"
  command git rev-parse --abbrev-ref --symbolic-full-name @\{u\} 2> /dev/null
end

function git_root -d "Get root directory of git repo"
  set -l pwd (realpath .)
  switch $pwd
    case "*/.git*"
      echo (string replace -r "/.git*" "" -- $pwd)[1]
    case "*"
      in_git_repo; and command git rev-parse --show-toplevel
  end
end

function in_git_submodule -d "check current directory is in a git submodule"
  not test -z (command git rev-parse --show-superproject-working-tree  2> /dev/null)
end

function git_is_touched
  test -n (echo (env GIT_WORK_TREE=(git_root) git status --porcelain)) >/dev/null 2>&1
end

function git_remote_url -d "Get url of active remote of current git repo"
  in_git_repo; and git ls-remote --get-url (git_remote)
end

function git_remote_branch_exist -d "Check whether remote branch exists"
  test -n (git_remote_branch_name) > /dev/null 2>&1
end

function in_git_repo -d "Whether current directory in a git repo"
  test -d .git; or git rev-parse --git-dir > /dev/null 2>&1
end

function git_remote -d "Get remote of current repo"
  command env GIT_WORK_TREE=(git_root) git remote -v | head -1 | awk '{print $1}'
end

function git_untracked -d "Get file count of untracked"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "??") print $2}' | wc -l | tr -d '[:space:]'
end

function git_modified -d "Get file count of modified"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "M") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_added -d "Get file count of added"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "A") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_deleted -d "Get file count of deleted"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "D") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_renamed -d "Get file count of renamed"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "R") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_copied -d "Get file count of copied"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "C") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_updated_but_unmerged -d "Get file count of updated but unmerged"
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "U") print $2}' | wc -l | tr -d '[:space:]'
end

function git_ahead_behind
  set -l ahead '?'
  set -l behind '?'
  if git_remote_branch_exist
    set -l ahead_behind (git rev-list --count --left-right (git_branch_name)...(git_remote)/(git_branch_name) 2> /dev/null)
    if test -n "$ahead_behind"
      set ahead (echo $ahead_behind | awk '{print $1}')
      set behind (echo $ahead_behind | awk '{print $2}')
    end
  end
  echo ↑$ahead↓$behind
end

function git_status
    command echo \[(git_ahead_behind)\|\*(git_modified)\|\+(git_added)\|\-(git_deleted)\|↬(git_renamed)\|\?(git_untracked)\]
end

function fish_right_prompt
  set -l code $status

  function status::color -S
    test $code -ne 0; and echo (flash_snd); or echo (flash_fst)
  end

  if test $CMD_DURATION -gt 10
    printf (flash_blu)" ~"(printf "%.3fs " (math -s3 "$CMD_DURATION / 1000"))(flash_off)
  end

  if in_git_repo
    if git_is_stashed
      echo (flash_dim)"<"(flash_off)
    end
    printf (begin
      git_is_touched
        and echo (flash_fst)"(*"(flash_snd)(git_branch_name)(git_status)(flash_fst)")"(flash_off)
        or echo (flash_snd)"("(flash_fst)(git_branch_name)\[(git_ahead_behind)\](flash_snd)")"(flash_off)
    end)(flash_off)
  end

  printf " "(flash_trd)(date +%H(status::color):(flash_trd)%M(status::color):(flash_trd)%S)(flash_snd)" "(flash_off)

  if test $code -ne 0
    echo (flash_fst)"≡ "(flash_snd)"$code"(flash_off)
  end
end
