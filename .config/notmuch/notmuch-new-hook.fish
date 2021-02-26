#!/usr/bin/env fish

# runs on new mail

set path "$HOME/.config/notmuch"
# index new mail
notmuch new
# tag new messages with account
notmuch tag "+$argv[1]" -- tag:new
notmuch tag --input "$path/notmuch_tags"
# re-build email index
notmuch address --deduplicate=no "*" | pypy3 "$path/nodup.py" > "$path/emails.txt"
# compact for faster load and less disk space
notmuch compact 

