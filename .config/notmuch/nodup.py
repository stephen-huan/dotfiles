#!/usr/bin/env python
import sys

def get_email(line: str) -> str:
    """ Parse an email as "display name <username@domain>". """
    if "<" in line and ">" in line:
        email = line.split("<")[1][:-1]
        assert "@" in email, "not a valid email!"
        return email
    return line

order = []
count = {}
for line in sys.stdin:
    line = line.strip()
    email = get_email(line)
    if email not in count:
        # sort emails by the earliest line it occurs in
        order.append(email)
        count[email] = {line: 1}
    else:
        count[email][line] = count[email].get(line, 0) + 1

for email in order:
    print(max(count[email], key=lambda x: count[email][x]))

