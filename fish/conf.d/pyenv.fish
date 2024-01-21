#!/usr/bin/fish

if which pyenv > /dev/null
  pyenv init fish 2>&1 | source
end
