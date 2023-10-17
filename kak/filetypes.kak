hook global WinSetOption filetype=markdown %{
  set-option window autowrap_column 80
  autowrap-enable
}

hook global WinSetOption filetype=python %{
  set-option buffer indentwidth 4
  set-option buffer tabstop 4
}
