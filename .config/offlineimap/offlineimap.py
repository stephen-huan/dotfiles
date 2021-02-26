#!/usr/bin/env python2
import sys, subprocess, imp, os.path, time
# import gmail-oauth2-tools
path = "~/.config/offlineimap/gmail-oauth2-tools/python/oauth2.py"
oauth2 = imp.load_source("oauth2", os.path.expanduser(path))

### password and oauth functions

def get_pass(path, first_line=True):
    """ Returns a password from calling pass.
    https://wiki.archlinux.org/index.php/OfflineIMAP#Using_pass """
    try:
        lines = subprocess.check_output(["pass", path]).splitlines()
    except subprocess.CalledProcessError:
        return
    else:
        return lines[0] if first_line and len(lines) > 0 else lines

def set_pass(path, value):
    """ Inserts a value into the password store. """
    p = subprocess.Popen(["pass", "insert", "-e", path], stdin=subprocess.PIPE)
    p.communicate(input=value)

if __name__ != "__main__":
    LINES = get_pass("email/accounts.google.com/oauth2", False)

def get_oauth2(cred, email=""):
    """ Returns the oauth2 credentials. """
    for i, line in enumerate(LINES):
        if email in line.decode():
            break
    line_index = {"id": 1, "secret": 0, "refresh": i}
    line = LINES[line_index[cred]].decode()
    return (line if ":" not in line else line.split(":")[-1]).strip().encode()

def get_access_token(email):
    """ Gets an access token using gmail-oauth2-tools. """
    creds = [get_oauth2(cred, email) for cred in ["id", "secret", "refresh"]]
    response = oauth2.RefreshToken(*creds)
    return response["access_token"], response["expires_in"]

### offlineimap specific utilities

nametrans_dict = {
    "[Gmail]/All Mail": "archive",
    "[Gmail]/Drafts": "drafts",
    "[Gmail]/Sent Mail": "sent",
    "[Gmail]/Important": "important",
    "[Gmail]/Starred": "starred",
    "[Gmail]/Spam": "spam",
    "[Gmail]/Trash": "trash",
    "INBOX": "inbox",
}
nametrans_reverse = {v: k for k, v in nametrans_dict.items()}
assert len(nametrans_dict) == len(nametrans_reverse), "duplicate entries"

def nametrans(folder, d):
    """ Rename a remote folder to a local folder.
    https://www.offlineimap.org/doc/nametrans.html#nametrans """
    return d.get(folder, folder)

gmail_nametrans = lambda folder: nametrans(folder, nametrans_dict)
gmail_nametrans_reverse = lambda folder: nametrans(folder, nametrans_reverse)

folderfilter_blacklist = [
    # helpful to parse spam messages manually
    # "[Gmail]/Spam",
    "[Gmail]/Important",
    # maintain local flags
    "[Gmail]/Starred",
    # thunderbird folders, doesn't save to special [Gmail] folder 
    "Drafts",
    "Trash"
]

def gmail_folderfilter(folder):
    """ Returns True if the folder should be synced, otherwise False.
    https://www.offlineimap.org/doc/nametrans.html#folderfilter """
    return folder not in folderfilter_blacklist

if __name__ == "__main__":
    # get oauth2 access token for msmtp, based off oauth2token:
    # https://github.com/tenllado/dotfiles/tree/master/config/msmtp
    email = sys.argv[1]
    token_path  = "email/oauth/%s/token"        % email
    expire_path = "email/oauth/%s/token-expire" % email
    now = int(time.time())
    # if cached, use cached access token
    expire_time = get_pass(expire_path)
    if expire_time is not None:
        expire_time = int(expire_time)
        # more than 60 seconds from expiring 
        if expire_time - now >= 60:
            token = get_pass(token_path)
            if token is not None:
                print(token)
                sys.exit()
    # otherwise, generate token and update
    LINES = get_pass("email/accounts.google.com/oauth2", False)
    token, expire = get_access_token(email)
    set_pass(token_path, token)
    set_pass(expire_path, str(now + expire))

