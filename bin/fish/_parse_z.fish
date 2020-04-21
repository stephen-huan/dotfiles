function _parse_z
  # split the incoming list on space
  set l (string split " " $argv)
  # take the resulting list and remove the first element and join again
  set s (string join " " $l[2..-1])
  echo (string trim $s)
end
