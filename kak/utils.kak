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

define-command -params .. \
    -docstring "run shell command in async mode" async %{ evaluate-commands %sh{
     output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-async.XXXXXXXX)/fifo
     mkfifo "$output"
     ( eval "$@" > "$output" 2>&1 & ) > /dev/null 2>&1 < /dev/null

     printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
       edit! -fifo $output -scroll '*async* $@'
       hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname $output) } }
     }"
}}
