import json

""" Compiles the file at ~/.config/karabiner/karabiner_source.json
into a karabiner.json file, according to the rules in rulesrc
(which is formatted in notation inspired by skhd). """

SOURCE = "/Users/stephenhuan/.config/karabiner/karabiner_source.json"
OUTPUT = "/Users/stephenhuan/.config/karabiner/karabiner.json"
RULES  = "/Users/stephenhuan/.config/karabiner/rulesrc"

MODS  = {"cmd": "command", "alt": "option", "ctrl": "control", "shift": "shift"}
HYPER = ["command", "option", "control", "shift"]
ORDER = ["any"] + HYPER
MOD_DELIM, KEY_DELIM, SEP_DELIM, KEYS_DELIM = "+", "-", ":", ","

def parse_mods(mods: list) -> list:
    """ Converts a list of shorthand mods to karabiner mods. """
    if "hyper" in mods:
        mods = HYPER + [mod for mod in mods if mod != "hyper"]
    return sorted(set(MODS.get(mod, mod) for mod in mods if len(mod) > 0),
                  key=lambda x: (ORDER.index(x.split("_")[-1]), x))

def split_strip(s: str, d) -> list:
    """ Returns the string s split on the delimiter d. """
    return [x.strip() for x in s.split(d)]

def parse_key(line: str) -> tuple:
    """ A key is formatted as {mod1} + {mod2} + ... + {modk} - {key},
    where if there no mods, then the - is optional. """
    mods, key = (("-" + line) if "-" not in line else line).split(KEY_DELIM)
    mods, key = split_strip(mods, MOD_DELIM), key.strip()
    return parse_mods(mods), key

def get_rule(line: str) -> tuple:
    """ Gets the tuple (from_mod, from_key, ((to_mod, to_key), ...)) from a line.
    and a line is formated as from key : to key, to key1, ... """
    tokens = line.split(SEP_DELIM)
    from_key, to_key = tokens[0], tokens[1:]
    to_key, tap_keys = (to_key[0], "") if len(to_key) == 1 else to_key
    from_mod, from_key = parse_key(from_key)
    return {"from_mod": from_mod,
            "from_key": from_key,
            "keys": tuple(map(parse_key, to_key.split(KEYS_DELIM))),
            "tap_keys": tuple(map(parse_key, tap_keys.split(KEYS_DELIM)))
                        if len(tap_keys) > 0 else (),
           }

def format_mods(mods: list) -> str:
    """ Formats the modifiers."""
    return f" {MOD_DELIM} ".join(mods) + (f" {MOD_DELIM} " if len(mods) > 0 else "")

def format_key(key: tuple) -> str:
    """ Formats a (mod, keycode) pair"""
    return f"{format_mods(key[0])}{key[1]}"

def get_mods(mods: list) -> dict:
    """ Returns whether modifiers are mandatory or not. """
    return {"mandatory": mods} if "any" not in mods else {"optional": ["any"]}

def get_key(key: str) -> str:
    """ Returns the type of the key. """
    return "pointing_button" if "button" in key else "key_code"

def make_rule(from_mod: list, from_key: str, keys: tuple, tap_keys: tuple) -> dict:
    """ Makes a complex rule in karabiner format. """
    rules = {"description": f"{format_key((from_mod, from_key))} -> {(KEYS_DELIM + ' ').join(map(format_key, keys))}",
             "manipulators": [{"from":
                                  {"modifiers": get_mods(from_mod),
                                   get_key(from_key): from_key
                                  },
                              "to": [
                                  {"modifiers": mod,
                                   get_key(key): key,
                                  } for mod, key in keys
                              ],
                              "to_if_alone": [
                                  {"modifiers": mod,
                                   get_key(key): key,
                                  } for mod, key in tap_keys
                              ],
                              "type": "basic"}]}
    if len(tap_keys) == 0:
        del rules["manipulators"][0]["to_if_alone"]
    return rules

if __name__ == "__main__":
    with open(RULES) as f:
        rules = [make_rule(**get_rule(line)) for line in
                 map(lambda l: l.split("#")[0].strip(), f) if len(line) > 0]

    with open(SOURCE) as f:
        d = json.load(f)

    d["profiles"][0]["complex_modifications"]["rules"] += rules

    with open(OUTPUT, "w") as f:
        json.dump(d, f, sort_keys=True, indent=4)

