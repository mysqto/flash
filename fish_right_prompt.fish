
function flash_git_is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function flash_git_branch_name
  command git symbolic-ref --short HEAD
end

function flash_git_remote_branch_name
  command git rev-parse --abbrev-ref --symbolic-full-name @\{u\}
end

function flash_git_is_touched
  test -n (echo (command git status --porcelain))
end

function flash_is_pwd_git_repo
  test -d .git; or git rev-parse --git-dir > /dev/null ^&1
end

function git_untracked
  command git status -s | awk '{if ($1 == "??") print $2}' | wc -l | tr -d '[:space:]'
end

function git_modified
  command git status -s | awk '{if ($1 == "M") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_added
  command git status -s | awk '{if ($1 == "A") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_deleted
  command git status -s | awk '{if ($1 == "D") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_renamed
  command git status -s | awk '{if ($1 == "R") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_copied
  command git status -s | awk '{if ($1 == "C") print $2}' | wc -l | tr -d '[:space:]'
end

function  git_updated_but_unmerged
  command git status -s | awk '{if ($1 == "U") print $2}' | wc -l | tr -d '[:space:]'
end

function git_ahead_behind
  set -l ahead_behind (git rev-list --count --left-right (flash_git_branch_name)...(flash_git_remote_branch_name))
  set -l ahead (echo $ahead_behind | awk '{print $1}')
  set -l behind (echo $ahead_behind | awk '{print $2}')
  echo ↑$ahead↓$behind
end

function git_status
command echo \[(git_ahead_behind)\|\*(git_modified)\|\+(git_added)\|\-(git_deleted)\|\?(git_untracked)\]
end

function fish_right_prompt
  set -l code $status

  function status::color -S
    test $code -ne 0; and echo (flash_snd); or echo (flash_fst)
  end

  if test $CMD_DURATION -gt 1000
    printf (flash_dim)" ~"(printf "%.1fs " (math "$CMD_DURATION / 1000"))(flash_off)
  end

  if flash_is_pwd_git_repo
    if flash_git_is_stashed
      echo (flash_dim)"<"(flash_off)
    end
    printf (begin
      flash_git_is_touched
        and echo (flash_fst)"(*"(flash_snd)(flash_git_branch_name)(git_status)(flash_fst)")"(flash_off)
        or echo (flash_snd)"("(flash_fst)(flash_git_branch_name)\[(git_ahead_behind)\](flash_snd)")"(flash_off)
    end)(flash_off)
  end

  printf " "(flash_trd)(date +%H(status::color):(flash_dim)%M(status::color):(flash_trd)%S)(flash_snd)" "(flash_off)

  if test $code -ne 0
    echo (flash_fst)"≡ "(flash_snd)"$code"(flash_off)
  end
end
