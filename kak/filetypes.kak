hook global WinSetOption filetype=markdown %{
  set-option window autowrap_column 80
  autowrap-enable
}

hook global WinSetOption filetype=python %{
  set-option buffer indentwidth 4
  set-option buffer tabstop 4
}

hook global WinSetOption filetype=makefile %{
  set-option buffer aligntab true
}

hook global WinSetOption filetype=go %{
  set-option buffer aligntab true
  set-option buffer tabstop 2
  set-option buffer indentwidth 2
}

hook global WinSetOption filetype=java %{
  map -docstring "sort imports" buffer user i '<a-i>p|sort<ret>;'
}
