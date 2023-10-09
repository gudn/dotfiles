
# Configuration

# List of surrounding pairs
declare-option -docstring 'list of surrounding pairs' str-list auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›

# Auto-pairing of characters activates only when this expression does not fail.
# By default, it avoids non-nestable pairs (such as quotes), escaped pairs and word characters.
declare-option -docstring 'auto-pairing of characters activates only when this expression does not fail' str auto_close_trigger '<a-h><a-K>(\w["''`]|""|''''|``).\z<ret><a-k>[^\\]?\Q%opt{auto_opening_pair}<a-!>\E\W\z<ret>'

# Internal variables
declare-option -hidden str auto_opening_pair
declare-option -hidden int auto_inserted_pairs

# Commands
define-command auto-pairs-enable -docstring 'enable auto-pairs' %{
  remove-hooks global auto-pairs
  evaluate-commands %sh{
    set -- ${kak_opt_auto_pairs}
    while [ "$2" ]
    do
      printf 'auto-close-pair %%<%s> %%<%s>\n' "$1" "$2"
      shift 2
    done
  }
}

define-command auto-pairs-disable -docstring 'disable auto-pairs' %{
  remove-hooks global auto-pairs
}

# Internal commands ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

define-command -hidden auto-close-pair -params 2 %{
  hook -group auto-pairs global InsertChar "\Q%arg{1}" "auto-handle-inserted-opening-pair %%<%arg{1}> %%<%arg{2}>"
  hook -group auto-pairs global InsertDelete "\Q%arg{1}" "auto-handle-deleted-opening-pair %%<%arg{1}> %%<%arg{2}>"
}

# Internal hooks ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

define-command -hidden auto-handle-inserted-opening-pair -params 2 %{
  try %{
    # Test whether the commands contained in the option pass.
    # If not, it will throw an exception and execution will jump to
    # the “catch” block below.
    set-option window auto_opening_pair %arg{1}
    execute-keys -draft %opt{auto_close_trigger}

    # Action: Close pair
    execute-keys %arg{2}

    # Keep the track of inserted pairs
    auto-increment-inserted-pairs-count

    # Move back in pair (preserve selected text):
    try %{
      execute-keys -draft '<a-k>..<ret>'
      execute-keys '<a-;>H'
    } catch %{
      execute-keys '<a-;>h'
    }

    # Add insert mappings
    map -docstring 'insert closing pair or move right in pair' window insert %arg{2} "<a-;>:auto-insert-closing-pair-or-move-right-in-pair %%🐈%arg{2}🐈<ret>"
    map -docstring 'insert a new indented line in pair' window insert <ret> '<a-;>:auto-insert-new-line-in-pair<ret>'
    map -docstring 'prompt a count for new indented lines in pair' window insert <c-ret> '<a-;>:auto-prompt-insert-new-line-in-pair<ret>'

    # Enter is only available on next key.
    hook -group auto-pairs -once window InsertChar '.*' %{
      unmap window insert <ret>
      unmap window insert <c-ret>
    }

    # Clean insert mappings and remove hooks
    hook -group auto-pairs -once window WinSetOption 'auto_inserted_pairs=0' "
      unmap window insert %%🐈%arg{2}🐈
      unmap window insert <ret>
      unmap window insert <c-ret>
      remove-hooks window auto-pairs
    "

    # Clean state when moving or leaving insert mode
    hook -group auto-pairs -once window InsertMove '.*' %{
      auto-reset-inserted-pairs-count
    }

    hook -always -once window ModeChange 'pop:insert:normal' %{
      auto-reset-inserted-pairs-count
    }
  }
}

# Backspace ⇒ Erases the whole bracket
define-command -hidden auto-handle-deleted-opening-pair -params 2 %{
  try %{
    execute-keys -draft "<space>;<a-k>\Q%arg{2}<ret>"
    execute-keys '<del>'
    auto-decrement-inserted-pairs-count
  }
}

# Internal mappings ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# {closing-pair} ⇒ Insert closing pair or move right in pair
define-command -hidden auto-insert-closing-pair-or-move-right-in-pair -params 1 %{
  try %{
    execute-keys -draft "<space>;<a-k>\Q%arg{1}<ret>"
    # Move right in pair
    execute-keys '<a-;>l'
    auto-decrement-inserted-pairs-count
  } catch %{
    # Insert character with hooks
    execute-keys -with-hooks %arg{1}
  }
}

# Enter ⇒ Insert a new indented line in pair (only for the next key)
define-command -hidden auto-insert-new-line-in-pair %{
  execute-keys '<a-;>;<ret><ret><esc>KK<a-&>j<a-gt>'
  execute-keys -with-hooks A
  auto-reset-inserted-pairs-count
}

# Control+Enter ⇒ Prompt a count for new indented lines in pair (only for the next key)
define-command -hidden auto-prompt-insert-new-line-in-pair %{
  prompt count: %{
    execute-keys '<a-;>;<ret><ret><esc>KK<a-&>j<a-gt>'
    execute-keys "xHyx<a-d>%val{text}O<c-r>""<esc>"
    execute-keys -with-hooks A
    auto-reset-inserted-pairs-count
  }
}

# ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Increment and decrement inserted pairs count
define-command -hidden auto-increment-inserted-pairs-count %{
  set-option -add window auto_inserted_pairs 1
}

define-command -hidden auto-decrement-inserted-pairs-count %{
  set-option -remove window auto_inserted_pairs 1
}

define-command -hidden auto-reset-inserted-pairs-count %{
  set-option window auto_inserted_pairs 0
}
