function _parse_token --description "removes the first token from a line"
  # parse to determine whether to remove whitespace or not
  argparse "p/preserve" -- $argv
  # split the incoming list on space
  set l (string split " " $argv)
  # take the resulting list and remove the first element and join again
  set s (string join -- " " $l[2..-1])
  if not set -q _flag_p
    echo (string trim -- $s)
  else 
    echo $s
  end
end
