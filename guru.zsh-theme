#-------------------------------------------------------------------------------
# Guru theme for oh-my-zsh by Adam Lindberg
# (Needs Git plugin for current_branch method)
#-------------------------------------------------------------------------------


# Color shortcuts
R=$fg[red]
Y=$fg[yellow]
G=$fg[green]
M=$fg[magenta]
W=$fg[white]
B=$fg[black]
RB=$fg_bold[red]
YB=$fg_bold[yellow]
GB=$fg_bold[green]
MB=$fg_bold[magenta]
WB=$fg_bold[white]
BB=$fg_bold[black]
RESET=$reset_color

if [ "$(whoami)" = "root" ]; then
    PROMPTCOLOR="%{$RB%}" PREFIX="-!-";
else
    PROMPTCOLOR="%{$BB%}" PREFIX="---";
fi

local return_code="%(?..%{$R%}%? ↵%{$RESET%})"

GIT_PREFIX="%{$YB%}‹"
GIT_SUFFIX="%{$YB%}›"

# Get the status of the working tree (copied and modified from git.zsh)
custom_git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  # Non-staged
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  # Staged
  if $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_ADDED$STATUS"
  fi
  echo $STATUS
}

# get the name of the branch we are on (copied and modified from git.zsh)
function custom_git_prompt() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(git_prompt_ahead)$(parse_git_dirty)$(custom_git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='${PROMPTCOLOR}$PREFIX %2~ $(custom_git_prompt)%{$M%}%B»%b%{$RESET%} '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$YB%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$YB%}›%{$RESET%} "

ZSH_THEME_GIT_PROMPT_AHEAD="%{$BB%}➝"

# Staged
ZSH_THEME_GIT_PROMPT_STAGED_ADDED="%{$G%}A"
ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED="%{$G%}M"
ZSH_THEME_GIT_PROMPT_STAGED_RENAMED="%{$G%}R"
ZSH_THEME_GIT_PROMPT_STAGED_DELETED="%{$G%}D"

# Not-staged
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$R%}??"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$R%}M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$R%}D"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$R%}UU"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$R%}* "

ZSH_THEME_GIT_PROMPT_CLEAN=""