set __fish_opam_init "$HOME/.opam/opam-init/init.fish"

if test -f "$__fish_opam_init"
  source $__fish_opam_init > /dev/null 2> /dev/null; or true
end

set -e __fish_opam_init
