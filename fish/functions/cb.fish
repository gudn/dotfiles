function cb --wraps='xclip -selection c' --description 'alias cb xclip -selection c'
  xclip -selection c $argv; 
end
