define-command open -params ..1 -docstring "open a file" %{
  prompt -shell-script-candidates "fd --type file . %arg{1}" "open: " %{
    edit %val{text}
  }
}

define-command bc -docstring "simple math with bc" %{
  prompt -init %val{selection} "bc: " %{
    set-register '"' %sh{ echo "scale=3; $kak_text" | bc -l -q }
    echo %reg{"}
  }
}

