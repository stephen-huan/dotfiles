function _preview_path --description "previews a path with either tree or bat"
  # if directory, use tree to render it
  if test -d "$argv[1]"
    tree -C $argv[1] | head -n 100
    return
  end

  # otherwise, default to bat
  bat --color always --style='changes,snip' $argv[1] | head -n 100

end
