# http://tcl.tk

# Detection
hook global BufCreate '.*\.tcl' %{
  set-option buffer filetype tcl
}

# Initialization

hook global WinSetOption filetype=tcl %{
    require-module tcl

    add-highlighter window/tcl ref tcl
    hook -once -always window WinSetOption filetype=.* %{
      remove-highlighter window/tcl
    }
}

provide-module tcl %<
  declare-option -hidden regex tcl_before_command_regex '(?:^|;|\[|\{)\s*'
  declare-option -hidden regex tcl_name_regex '[a-zA-Z0-9_:-]+'
  declare-option -hidden regex tcl_var_regex '(?:[^\\]|^)(\$(?:[a-zA-Z0-9_:-]+|\{.*\}))'

  add-highlighter shared/tcl regions

  add-highlighter shared/tcl/ region '(?:^|;)\s*#' '$' fill comment

  add-highlighter shared/tcl/other default-region group

  add-highlighter shared/tcl/other/ regex '\{\*\}|\+|-|\*|/|<|>' 0:operator

  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}(%opt{tcl_name_regex})\b" 1:function


  add-highlighter shared/tcl/other/ regex '\b(\+|-)?[0-9]+(\.[0-9]+)?\b' 0:value
  add-highlighter shared/tcl/other/ regex '(?i)\b(true|false|yes|no)\b' 1:value

  add-highlighter shared/tcl/other/ regex %opt{tcl_var_regex} 1:variable

  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}\b(if|switch|while|foreach|for|return|break|continue|try|catch|throw|finally|error|apply|coroutine|yield|yieldto|tailcall)\b" 1:keyword
  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}\b(proc|set|unset|package|namespace|upvar|expr|eval|global|append)\b" 1:keyword

  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}(incr|dict|array|clock|info)\b" 1:builtin
  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}(string|format|scan)\b" 1:builtin
  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}(open|close|puts|gets|glob|file)\b" 1:builtin
  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}(lappend|lassign|lindex|linsert|list|llength|lmap|load|lrange|lrepeat|lreplace|lreverse|lsearch|lset|lsort)\b" 1:builtin

  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}proc (%opt{tcl_name_regex}) \{([^\n\}]*)\}" 1:function 2:variable
  add-highlighter shared/tcl/other/ regex "%opt{tcl_before_command_regex}foreach \{([^\n\}]*)\}" 1:variable

  add-highlighter shared/tcl/dqstring region '"' '"' regions

  add-highlighter shared/tcl/dqstring/value default-region group

  add-highlighter shared/tcl/dqstring/value/ fill string

  add-highlighter shared/tcl/dqstring/value/ regex %opt{tcl_var_regex} 1:variable

  add-highlighter shared/tcl/dqstring/value/ regex '\\0[0-7]{2}|\\u[a-fA-f0-9]{4}|\\x[a-fA-F0-9]{2,}|\\[abfnrtv]' 0:value

  add-highlighter shared/tcl/dqstring/ region -recurse '\[' '\[' '\]' ref tcl
>
