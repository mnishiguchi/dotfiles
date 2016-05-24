# Command prompt
- [Add git branch name to bash prompt](https://coderwall.com/p/fasnya/add-git-branch-name-to-bash-prompt)

## Modifying the Command Line Prompt

```bash
$ echo $PS1                 # Before
\$
$ PS1="\u@\h \$ "           # Set the PS1 variable to: `\u@\h \$`
masa@Masas-Mac $ echo $PS1  # After
\u@\h \$
```

```bash
# Robin
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=1
  git_prompt='$(__git_ps1)'
fi
PS1="===== \d \t \w$git_prompt\n\\$ "
```

```bash
# Jesse
PS1='\[\e[0;37m\]\u@\h:\[\e[0m\]\[\e[1;30m\]\w\[\e[1;31m\]$(__git_ps1)\[\e[0m\] $ '
```

## Prompt Statement (PS)

- Used to customize your prompt string in your terminal windows to display the information you want.

## The `PS1` variable

- The primary prompt variable.
- Controls what your command line prompt looks like.
- Used to specify the prompt string.
- Most distributions set PS1 to a known default value, which is suitable in most cases.
- Can be customized to display custom information on the command line.

- e.g., some system administrators require the user and the host system name to show up on the      command line as in: student@quad32 $

- This could prove useful if you are working in multiple roles and want to be always reminded of who you are and what machine you are on.

## The special characters for `PS1`

```
\u : User name
\h : Host name
\w : Current working directory
\! : History number of this command
\d : Date
```
