# Defined in - @ line 1
function pass --wraps='EDITOR=vim-private pass' --wraps='EDITOR=vim-private command pass' --description 'alias pass=EDITOR=vim-private command pass'
  EDITOR=vim-private command pass $argv;
end
