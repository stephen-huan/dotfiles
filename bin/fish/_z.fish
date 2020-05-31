function _z --description "wrapper around z that removes the number"
    set lines (string split "\n" (z | tac))
    for line in $lines
        echo (_parse_token $line)
    end
end

