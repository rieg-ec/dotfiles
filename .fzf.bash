# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

eval "$(fzf --bash)"

# ctrl-d in ctrl-r deletes the selected history entry in place.

_fzf_history_feed() {
  local script
  script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; s/\n/\n\t/gm; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
  builtin fc -lnr -2147483648 |
    last_hist=$(HISTTIMEFORMAT='' builtin history 1) command perl -n -l0 -e "$script"
}

_fzf_delete_history_entry() {
  local snapshot="$1"
  local queue="$2"
  local hist_num="$3"
  local hf="${HISTFILE:-$HOME/.bash_history}"
  local record
  local cmd
  local line_num
  local prev

  [[ -n "$snapshot" && -n "$queue" && -n "$hist_num" ]] || return 0

  record=$(HIST_NUM="$hist_num" command perl -0ne '
    for my $entry (split /\0/, $_) {
      next if $entry eq q{};
      if ($entry =~ /^\Q$ENV{HIST_NUM}\E\t/s) {
        print $entry;
        last;
      }
    }
  ' "$snapshot")

  [[ -n "$record" ]] || return 0

  cmd=${record#*$'\t'}
  line_num=$(LC_ALL=C command grep -nFx "$cmd" "$hf" | tail -1 | cut -d: -f1)

  if [[ -n "$line_num" ]]; then
    prev=$((line_num - 1))
    if [[ "$prev" -ge 1 ]] && command gsed -n "${prev}p" "$hf" | command grep -q '^#[0-9]*$'; then
      command gsed -i "${prev},${line_num}d" "$hf"
    else
      command gsed -i "${line_num}d" "$hf"
    fi
  fi

  HIST_NUM="$hist_num" command perl -0ne '
    for my $entry (split /\0/, $_) {
      next if $entry eq q{};
      next if $entry =~ /^\Q$ENV{HIST_NUM}\E\t/s;
      print $entry, "\0";
    }
  ' "$snapshot" > "${snapshot}.tmp" && command mv "${snapshot}.tmp" "$snapshot"

  printf '%s\n' "$hist_num" >> "$queue"
}
export -f _fzf_delete_history_entry

_fzf_apply_history_deletes() {
  local queue="$1"
  local hist_num

  [[ -s "$queue" ]] || return 0

  while IFS= read -r hist_num; do
    [[ -n "$hist_num" ]] || continue
    builtin history -d "$hist_num"
  done < <(command sort -rn "$queue" | command uniq)
}

__fzf_history__() {
  local output
  local bind_opts
  local snapshot
  local queue
  local status

  snapshot=$(mktemp "${TMPDIR:-/tmp}/fzf-history.XXXXXX") || return 1
  queue=$(mktemp "${TMPDIR:-/tmp}/fzf-history-delete.XXXXXX") || {
    command rm -f "$snapshot"
    return 1
  }

  _fzf_history_feed > "$snapshot"

  bind_opts=$(cat <<'EOF'
--header "ctrl-d: delete from history" --bind "ctrl-d:execute-silent(bash -c '_fzf_delete_history_entry \"$@\"' _ \"$FZF_HISTORY_SNAPSHOT\" \"$FZF_HISTORY_QUEUE\" {1})+reload(cat \"$FZF_HISTORY_SNAPSHOT\")"
EOF
)

  output=$(set +o pipefail
    command cat "$snapshot" |
      FZF_HISTORY_SNAPSHOT="$snapshot" \
      FZF_HISTORY_QUEUE="$queue" \
      FZF_DEFAULT_OPTS="$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --highlight-line ${bind_opts} ${FZF_CTRL_R_OPTS-} +m --read0")" \
      FZF_DEFAULT_OPTS_FILE='' \
      $(__fzfcmd) --query "$READLINE_LINE")
  status=$?

  _fzf_apply_history_deletes "$queue"
  command rm -f "$snapshot" "$queue"

  (( status == 0 )) || return "$status"

  READLINE_LINE=$(command perl -pe 's/^\d*\t//' <<< "$output")
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}
