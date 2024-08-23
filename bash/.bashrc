# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

USER=rieg

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

force_color_prompt=yes
color_prompt=yes

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

if [ "$color_prompt" = yes ]; then
 PS1='\[\033[01;32m\]$USER@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\]\$ '
else
 PS1='$USER@\h:\w $(parse_git_branch)\$ '
fi


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export VISUAL=nvim
export EDITOR="$VISUAL"
export TERM=screen-256color

export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
# export LC_ALL=en_US.UTF-8

# RUBOCOP
alias rac='rubocop --auto-correct-all'
alias racr='rubocop --auto-correct-all --require rubocop-rails'

git_racr() {
  for line in $(git status -s -uno); do
    if [ $line != 'M' ] && [ $line != 'A' ] && [ $line != 'D' ] && [[ $line == *.rb ]]; then
      racr $line
    fi
  done
}

# C++
alias c14="g++ -std=c++14"

c17() {
  g++ -std=c++17 "$1";
  ./a.out < "$2";
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH="$HOME/.poetry/bin:$PATH"

# nvim
export PATH="$HOME/nvim/bin:$PATH"
alias n="nvim"

. "$HOME/.cargo/env"

export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

eval "$(rbenv init - --no-rehash bash)"
export PATH="$HOME/.rbenv/bin:$PATH"

export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH

source ~/.bash-git-completion

# GIT aliases
alias gria="git rebase -i --autosquash"
alias gri="git rebase -i"
alias gs="git status"
alias gl="git log"
alias gcf="git commit --fixup"
alias gca="git commit --amend"
alias grc="git rebase --continue"
alias gpfl="git push --force-with-lease origin"
alias gd="git diff"
alias ga="git add"

alias copy="xclip -selection clipboard"

alias pid="ps -eo pid,args"

export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,plugged} --type f"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

eval "$(pyenv virtualenv-init -)"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '$HOME/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '$HOME/Downloads/google-cloud-sdk/completion.bash.inc'; fi

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

function print_all_files() {
  directory_path="$1"
  find "$directory_path" -type f -exec bash -c 'echo -e "\n# {}\n$(cat {})"' \;
}


docker_wipe_container() {
  local container_id="$1"

  # Ensure a container ID was provided
  if [ -z "$container_id" ]; then
      echo "Please provide a Docker container ID."
      return 1
  fi

  # Get associated volume names
  local volumes=$(docker inspect --format '{{ range .Mounts }}{{ .Name }} {{ end }}' "$container_id")

  # Stop the container
  docker stop "$container_id"

  # Remove the container
  docker rm "$container_id"

  # Remove associated volumes
  for volume in $volumes; do
      if [ ! -z "$volume" ]; then
          docker volume rm "$volume"
      fi
  done

  echo "Container and associated volumes have been removed."
}

docker_prune_all() {
  docker system prune --volumes
}


dev_tunnel() {
  cloudflared tunnel --config $HOME/.cloudflared/config-dev.yml run dev
}

grupalia_tunnel() {
  cloudflared tunnel --config $HOME/.cloudflared/config-grupalia.yml run grupalia
}

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(/opt/homebrew/bin/brew shellenv)"
