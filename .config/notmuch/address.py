#!/usr/bin/env python
# reformats notmuch address from:%s to the proper form
# https://neomutt.org/guide/advancedusage.html#query
import sys

def get_email(line: str) -> tuple:
    """ Parse an email as "display name <username@domain>". """
    if "<" in line and ">" in line:
        name, email = line.split("<")
        assert "@" in email, "not a valid email!"
        return name, email[:-1]
    return "", line

# mutt ignores the first line
print()
results = False
for line in sys.stdin:
    name, email = get_email(line.strip())
    print(f"{email}\t{name}")
    results = True

if not results:
    exit(1)

