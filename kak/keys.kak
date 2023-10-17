map global insert <tab> '<a-;><a-gt>'
map global insert <s-tab> '<a-;><a-lt>'

map -docstring "toggle line comment" global user c ': comment-line<ret>'
map -docstring "toggle block comment" global user C ': comment-block<ret>'
map -docstring "open a file" global user f ': open<ret>'
map -docstring "open a file near current" global user F ': open %sh{ dirname $kak_buffile }<ret>'
map -docstring "simple math with bc" global user = ': bc<ret>'

