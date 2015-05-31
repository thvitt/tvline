Thorsten's Powerline Inspired Prompt Theme for ZSH
--------------------------------------------------

This is derived from [agnoster's theme](https://gist.github.com/3712874).

In order for this theme to render correctly, you will need a
[Powerline-patched font](https://gist.github.com/1595572).

In addition, it is currently only tested on a gnome-terminal with
TERM=xterm-256color and a black-on-white theme, and there might be dependencies
on oh-my-zsh in it.

![Example Screenshot](demo.png?raw=true)

# Goals

The aim of this theme is to only show you *relevant* information. Like most
prompts, it will only show git information when in a git working directory.
However, it goes a step further: everything from the current user and
hostname to whether the last call exited with an error to whether background
jobs are running in this shell will all be displayed automatically when
appropriate.

There are a few modifications to agnoster's:

* Space optimized – most whitespace removed
* RPROMPT support – much of the information moves to the right side (which hides automatically when typing longer commands)
* path is left-truncated if the left prompt would be too long
* more details in the optional status (number of bg jobs etc.)
* more info in the git prompt, modified version of [scripts by Seth House](http://eseth.org/2010/git-in-zsh.html)

# Reference

## Left prompt

1. context, i.e. user@host: white on black. Only if user ≠ $DEFAULT_USER or in a ssh session
2. current dir, truncated left if ≥ 30 characters. black on light gray  

## Right prompt

1. Status info, if applicable:

    * `✘‹number›` if exit code of last command ≠ 0
    * `⚡` if root
    * `⚙«number›` number of background jobs

2. Git info, if applicable:

    * background green = clean repo, yellow = dirty repo
    * branch name, prefixed with  if this is a remote-tracking branch
    * `↑n` = _n_ commits ahead of upstream branch
    * `↓n` = _n_ commits behind upstream branch
    * `☰ n` = there are _n_ stashes
    * `✎` = there are unstaged changes to tracked files
    * `+` = there are uncommitted changes in the index

    There is also an action format for when you're in a merge etc.

3. Python virtualenv

    * virtuelenv name in white on blue
