Thorsten's Powerline Inspired Prompt Theme for ZSH
--------------------------------------------------

This is derived from [agnoster's theme](https://gist.github.com/3712874).

In order for this theme to render correctly, you will need a
[Powerline-patched font](https://gist.github.com/1595572).

In addition, it is currently only tested on a gnome-terminal with
TERM=xterm-256color and a black-on-white theme, and there might be dependencies
on oh-my-zsh in it.

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
