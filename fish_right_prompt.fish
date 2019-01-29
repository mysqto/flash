
function git_is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null 2>&1
end

function git_branch_name
  command git symbolic-ref --short HEAD
end

function git_remote_branch_name
  command git rev-parse --abbrev-ref --symbolic-full-name @\{u\}
end

function git_is_touched
  test -n (echo (env GIT_WORK_TREE=(git_root) command git status --porcelain)) > /dev/null 2>&1
end

function git_root
  set -l pwd (realpath .)
  switch $pwd
    case "*/.git*"
      echo (string replace -r "/.git*" "" -- $pwd)[1]
    case "*"
      in_git_repo; and command git rev-parse --show-toplevel
  end
end

function in_git_repo
  test -d .git; or git rev-parse --git-dir > /dev/null 2>&1
end

function git_untracked
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "??") print $2}' | wc -l | tr -d '[:space:]'
end

function git_modified
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "M") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_added
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "A") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_deleted
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "D") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_renamed
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "R") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_copied
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "C") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_updated_but_unmerged
  command env GIT_WORK_TREE=(git_root) git status -s | awk '{if ($1 == "U") print $2}' | wc -l | tr -d '[:space:]'
end

function git_remote
  command env GIT_WORK_TREE=(git_root) git remote -v | head -1 | awk '{print $1}'
end

function git_ahead_behind
  set -l ahead_behind (env GIT_WORK_TREE=(git_root) git rev-list --count --left-right (git_branch_name)...(git_remote)/(git_branch_name))
  set -l ahead (echo $ahead_behind | awk '{print $1}')
  set -l behind (echo $ahead_behind | awk '{print $2}')
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

  if test $CMD_DURATION -gt 1000
    printf (flash_dim)" ~"(printf "%.1fs " (math "$CMD_DURATION / 1000"))(flash_off)
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

  printf " "(flash_trd)(date +%H(status::color):(flash_dim)%M(status::color):(flash_trd)%S)(flash_snd)" "(flash_off)

  if test $code -ne 0
    echo (flash_fst)"≡ "(flash_snd)"$code"(flash_off)
  end
end
