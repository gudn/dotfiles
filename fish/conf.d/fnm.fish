#!/usr/bin/fish

if which fnm > /dev/null
  fnm env --shell fish | source
  fnm completions --shell fish | source
end
