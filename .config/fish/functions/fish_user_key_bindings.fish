function fish_user_key_bindings --description "defines user keybindings"
  # ctrl shortcuts
  # binding \cj interferes with auto pipenv
  bind \co fzff
  bind \cg fzfz
  bind \ch fzfd
  bind \cf yubi_2fa
  bind \cp fzfkill
  # alt shortcuts
  bind \et fzftmux
  bind \ek _clear
  bind \ea fzfpass
end

