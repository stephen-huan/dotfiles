# [Karabiner](https://pqrs.org/osx/karabiner/index.html)

Karabiner is a kernel extension, so it can modify keybindings at a low level.
However, its configuration is through a JSON file,
and the syntax is slightly verbose.
To make it more usable, I created an transpiler from skhd-style syntax
to karabiner syntax. Check the 
[karabiner.py](../bin/pybin/karabiner.py) file.
`SOURCE` is a file where `karabiner.py` will add rules onto,
and will put those generated rules into `karabiner.json`, 
which is the file actually interpreted by karabiner. `RULES`
is a skhd-style syntax file, and an example can be found
[here](../.config/karabiner/rulesrc)
which utilizes all the implemented features:
any series of modifiers and then a valid karabiner key
can be mapped into another sequence of modifiers and a valid karabiner key,
mapping to multiple different keys can be done with a comma,
and having different behavior when held or tapped can be done. 

Simply run `python karabiner.py` when the variables are set properly
to compile `RULES` and `SOURCE` into `OUTPUT`.
