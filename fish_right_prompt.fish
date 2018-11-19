
function flash_git_is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function flash_git_branch_name
  command git symbolic-ref --short HEAD
end

function flash_git_is_touched
  test -n (echo (command git status --porcelain))
end

function flash_is_pwd_git_repo
  test -d .git; or git rev-parse --git-dir > /dev/null ^&1
end

function git_modified
  command git status --porcelain | grep "^M" | wc -l
end

function  git_added
  command git status --porcelain | grep "^A" | wc -l
end

function  git_deleted
  command git status --porcelain | grep "^D" | wc -l
end

function  git_renamed
  command git status --porcelain | grep "^R" | wc -l
end

function  git_copied
  command git status --porcelain | grep "^C" | wc -l
end

function  git_updated_but_unmerged
  command git status --porcelain | grep "^U" | wc -l
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
        and echo (flash_fst)"(*"(flash_snd)(flash_git_branch_name)(flash_fst)")"(flash_off)
        or echo (flash_snd)"("(flash_fst)(flash_git_branch_name)(flash_snd)")"(flash_off)
    end)(flash_off)
  end

  printf " "(flash_trd)(date +%H(status::color):(flash_dim)%M(status::color):(flash_trd)%S)(flash_snd)" "(flash_off)

  if test $code -ne 0
    echo (flash_fst)"≡ "(flash_snd)"$code"(flash_off)
  end
end
