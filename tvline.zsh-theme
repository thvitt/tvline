# vim:ft=zsh ts=2 sw=2 sts=2
#
# This is derived from agnoster's Theme - https://gist.github.com/3712874

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts
#
# Powerline characters:
#  57504 uniE0A0 Private Use
#  57505 uniE0A1 Private Use
#  57506 uniE0A2 Private Use
# █ 9608 block FULL BLOCK
#  57520 uniE0B0 Private Use
#  57521 uniE0B1 Private Use
#  57522 uniE0B2 Private Use
#  57523 uniE0B3 Private Use
#

CURRENT_BG='NONE'
CURRENT_BG_R='NONE'
SEGMENT_SEPARATOR=''
SEGMENT_SEPARATOR_R=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
	if [[ -n $1 && $1 == r ]]
	then
		shift
		rprompt_segment $@
		return
	fi
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    echo -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}
# Begin a segment for the RPROMPT
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
rprompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"

	echo -n "%{%K{$CURRENT_BG_R}%F{$1}%}$SEGMENT_SEPARATOR_R%{$bg$fg%}"
	
  CURRENT_BG_R=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black white "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

# next two functions are from http://eseth.org/2010/git-in-zsh.html
# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( "↑${ahead}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "↓${behind}" )

        hook_com[branch]="${hook_com[branch]}${(j:/:)gitstatus}"
    fi
}
# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    if [[ -n $dirty ]]; then
      prompt_segment $1 yellow black
    else
      prompt_segment $1 green black
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats '%b%u%c'
    zstyle ':vcs_info:*' actionformats '%a:%u%c'
		zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash
    vcs_info
    echo -n "${vcs_info_msg_0_}"
  fi
}

prompt_hg() {
	local rev status
	if $(hg id >/dev/null 2>&1); then
		if $(hg prompt >/dev/null 2>&1); then
			if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
				# if files are not added
				prompt_segment red white
				st='±'
			elif [[ -n $(hg prompt "{status|modified}") ]]; then
				# if any modification
				prompt_segment yellow black
				st='±'
			else
				# if working copy is clean
				prompt_segment green black
			fi
			echo -n $(hg prompt "{rev}@{branch}") $st
		else
			st=""
			rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
			branch=$(hg id -b 2>/dev/null)
			if `hg st | grep -Eq "^\?"`; then
				prompt_segment red black
				st='±'
			elif `hg st | grep -Eq "^(M|A)"`; then
				prompt_segment yellow black
				st='±'
			else
				prompt_segment green black
			fi
			echo -n "$rev@$branch" $st
		fi
	fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment $1 7 black '%30<…<%~'
}

# Virtualenv: current working virtualenv
# Turn off virtualenv's own prompt manipulation
VIRTUAL_ENV_DISABLE_PROMPT=1
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path ]]; then
    prompt_segment $1 blue white "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
	local jobs
	jobs=$(jobs -l | wc -l)
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘${RETVAL}"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $jobs -gt 0 ]] && symbols+="%{%F{cyan}%}⚙${jobs}"

  [[ -n "$symbols" ]] && prompt_segment $1 8 white "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_context
  prompt_dir
  prompt_hg
  prompt_end
}
build_rprompt() {
	RETVAL=$?
  prompt_status r
  prompt_git r
  prompt_virtualenv r
}

export PROMPT='%{%f%b%k%}$(build_prompt)'
export RPROMPT='%{%f%b%k%}$(build_rprompt)'
