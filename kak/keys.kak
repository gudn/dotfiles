map global insert <tab> '<a-;><a-gt>'
map global insert <s-tab> '<a-;><a-lt>'

map -docstring "toggle line comment" global user c ': comment-line<ret>'
map -docstring "toggle block comment" global user C ': comment-block<ret>'
map -docstring "open a file" global user f ': open<ret>'
map -docstring "open a file near current" global user F ': open %sh{ dirname $kak_buffile }<ret>'
map -docstring "simple math with bc" global user = ': bc<ret>'
map -docstring "send to repl" global user s ': repl-send-text<ret>'
map -docstring "run async command" global user a ': async '

map global normal <esc> ";,"

hook global InsertCompletionShow .* %{
  try %{
    # this command temporarily removes cursors preceded by whitespace;
    # if there are no cursors left, it raises an error, does not
    # continue to execute the mapping commands, and the error is eaten
    # by the `try` command so no warning appears.
    execute-keys -draft 'h<a-K>\h<ret>'
    map window insert <tab> <c-n>
    map window insert <s-tab> <c-p>
    hook -once -always window InsertCompletionHide .* %{
      unmap window insert <tab> <c-n>
      unmap window insert <s-tab> <c-p>
    }
  }
}
