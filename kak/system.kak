# Clipboard
hook global RegisterModified '"' %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xclip -in -selection clipboard >&- 2>&-
} }

map global user p -docstring 'Paste (After)' '<a-!>xclip -out -selection clipboard<ret>'
map global user P -docstring 'Paste (Before)' '!xclip -out -selection clipboard<ret>'
map global user R -docstring 'Replace' '|xclip -out -selection clipboard<ret>'

