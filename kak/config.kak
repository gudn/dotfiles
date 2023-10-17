# Options
set-option global indentwidth 2
set-option global tabstop %opt{indentwidth}
set-option global aligntab false
set-option global scrolloff 2,0

# Appearance
colorscheme tomorrow-night
set-option global scrolloff 2,2
set-option -add global ui_options terminal_assistant=none
add-highlighter global/ number-lines -hlcursor
add-highlighter global/ show-matching

# Editing
auto-pairs-enable
require-module byline

hook global BufWritePre .* %{ nop %sh{
  dir=$(dirname "$kak_buffile")
  [ -d "$dir" ] || mkdir --parents "$dir"
} }
