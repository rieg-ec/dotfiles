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
# HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=
HISTFILESIZE=
HISTTIMEFORMAT="%F %T %z "

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

eval "$(/opt/homebrew/bin/brew shellenv)"

if command -v aws_completer >/dev/null 2>&1; then
  complete -C "$(command -v aws_completer)" aws
fi

awsl() {
  local choice action label account_name account_id role_name display_name
  local login_command="aws sso login --profile "
  local console_url

  if ! command -v fzf >/dev/null 2>&1; then
    echo "awsl: fzf is required" >&2
    return 1
  fi

  choice=$(
    {
      printf '%s\t%s\n' \
        login "AWS SSO login  ·  ${login_command}<profile>" \
        console "management  ·  ps-admin"

      while IFS=$'\t' read -r account_name account_id; do
        printf 'role\t%s  ·  terraform-exec  ·  admin\t%s\tterraform-exec\t%s-admin\n' \
          "$account_name" "$account_id" "$account_name"
        printf 'role\t%s  ·  terraform-exec-plan  ·  metadata only\t%s\tterraform-exec-plan\t%s-plan\n' \
          "$account_name" "$account_id" "$account_name"
        printf 'role\t%s  ·  OrganizationAccountAccessRole  ·  recovery admin\t%s\tOrganizationAccountAccessRole\t%s-recovery\n' \
          "$account_name" "$account_id" "$account_name"
      done <<'AWS_ACCOUNTS'
log-archive	707408839613
security	975661984664
staging	038040472188
tooling	037918101356
shared-services	286481516912
sandbox	399311815863
sbx-production	564623062795
sbx-staging	016147628637
sbx-shared-services	969325258324
AWS_ACCOUNTS
    } |
      fzf --delimiter=$'\t' --with-nth=2 --prompt='AWS > ' \
        --height=40% --layout=reverse --border
  ) || return

  IFS=$'\t' read -r action label account_id role_name display_name <<< "$choice"
  case "$action" in
    login)
      printf '%s' "$login_command" | pbcopy
      if command -v osascript >/dev/null 2>&1 &&
        osascript -e 'tell application "System Events" to keystroke "v" using command down' >/dev/null 2>&1; then
        return
      fi
      printf 'Copied to clipboard: %s\n' "$login_command"
      ;;
    console)
      console_url="https://grupalia.awsapps.com/start/#/console?account_id=765298221931&role_name=ps-admin"
      open "$console_url"
      ;;
    role)
      console_url="https://signin.aws.amazon.com/switchrole?account=${account_id}&roleName=${role_name}&displayName=${display_name}"
      open "$console_url"
      ;;
  esac
}

# =============================================================================
# PATH Configuration
# =============================================================================
export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME=$HOME/Library/Android/sdk
export BUN_INSTALL="$HOME/.bun"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/nvim/bin:$PATH"
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"

# =============================================================================
# Version Managers
# =============================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(nodenv init -)"
eval "$(rbenv init - --no-rehash bash)"
eval "$(jenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# nvim
alias n="nvim"
alias memory="bm"

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

_gpfl_completion() {
  local cur prev words cword
  _get_comp_words_by_ref -n =: cur words cword prev
  __git_complete_refs --mode=heads
}

complete -o bashdefault -o default -o nospace -F _gpfl_completion gpfl
alias gd="git diff"
alias ga="git add"

alias copy="xclip -selection clipboard"

alias pid="ps -eo pid,args"

export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,plugged} --type f"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

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

# PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
alias sed='gsed'

# opencode
export PATH=/Users/rieg/.opencode/bin:$PATH
# yolocode is an executable in ~/.local/bin so agent-deck and non-interactive
# shells can launch it without relying on alias expansion.

# `agent-deck new <tool> [path]` — add + start + attach a tracked session in one
# step, for spawning an agent in a fresh terminal split without losing deck
# tracking. <tool> is passed through as the command (claude, yolocode, ...);
# model/permission defaults come from each tool's own config. Everything else
# falls through to the real binary.
function agent-deck() {
  if [ "${1:-}" != "new" ]; then
    command agent-deck "$@"
    return
  fi
  shift
  local tool="${1:-}"
  if [ -z "$tool" ]; then
    echo "Usage: agent-deck new <tool> [path]  (e.g. agent-deck new claude)" >&2
    return 1
  fi
  local path="${2:-.}"
  local out id
  out=$(command agent-deck add --quick -json -c "$tool" "$path") || { printf '%s\n' "$out" >&2; return 1; }
  id=$(printf '%s' "$out" | sed -n 's/.*"id": *"\([^"]*\)".*/\1/p' | head -1)
  if [ -z "$id" ]; then
    printf '%s\n' "$out" >&2
    echo "agent-deck new: could not parse session id from add output" >&2
    return 1
  fi
  command agent-deck session start "$id" && command agent-deck session attach "$id"
}

function cmem() {
  cd ~/cs/dotfiles && ./bin/mem-watch --once && cat /Users/rieg/.local/state/mem-watch/latest.txt
}

optimize_video() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: optimize_video <path-to-mov>" >&2
    return 1
  fi

  local input="$1"
  local output

  if [ ! -f "$input" ]; then
    echo "File not found: $input" >&2
    return 1
  fi

  case "$input" in
    *.[Mm][Oo][Vv]) ;;
    *)
      echo "Input must be a .mov file: $input" >&2
      return 1
      ;;
  esac

  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg is required but is not installed." >&2
    return 1
  fi

  output="${input%.*}.mp4"
  if [ -e "$output" ]; then
    echo "Output already exists: $output" >&2
    return 1
  fi

  ffmpeg -hide_banner -n -i "$input" \
    -map 0:v:0 -map '0:a:0?' \
    -vf "fps=30,scale='min(1920,iw)':'min(1920,ih)':force_original_aspect_ratio=decrease:force_divisible_by=2" \
    -c:v libx264 -preset medium -crf 25 -pix_fmt yuv420p \
    -c:a aac -b:a 128k \
    -movflags +faststart "$output"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rieg/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/rieg/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rieg/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/rieg/Downloads/google-cloud-sdk/completion.bash.inc'; fi
. "$HOME/.cargo/env"

alias clauded='claude --dangerously-skip-permissions'
alias opencode='opencode2'
