#!/usr/bin/env python2
import argparse, subprocess, imp, os, time
import msal
# import gmail-oauth2-tools
path = "~/.config/offlineimap/gmail-oauth2-tools/python/oauth2.py"
oauth2 = imp.load_source("oauth2", os.path.expanduser(path))

MS_EMAILS = {"shuan7@gatech.edu"}
MS_TENANT = "gtvault.onmicrosoft.com"
MS_SCOPES = ["https://outlook.office.com/IMAP.AccessAsUser.All",
             "https://outlook.office.com/SMTP.Send",
            ]
MS_REDIRECT = "http://localhost"

### password and oauth functions

NULL = open(os.devnull, "w")
CACHE = {}

def get_pass(path, first_line=True):
    """ Returns a password from calling pass.
    https://wiki.archlinux.org/index.php/OfflineIMAP#Using_pass """
    key = (path, first_line)
    if key not in CACHE:
        try:
            out = subprocess.check_output(["pass", path], stderr=NULL)
            lines = out.splitlines()
        except subprocess.CalledProcessError:
            return
        else:
            CACHE[key] = lines[0] if first_line and len(lines) > 0 else lines
    return CACHE[key]

def set_pass(path, value):
    """ Inserts a value into the password store. """
    p = subprocess.Popen(["pass", "insert", "--multiline", path],
                         stdin=subprocess.PIPE, stdout=NULL, stderr=NULL)
    p.communicate(input=value)

def get_oauth2(cred, email=""):
    """ Returns the oauth2 credentials. """
    lines = get_pass(query(email, "path"), first_line=False)
    for i, line in enumerate(lines):
        if email in line.decode():
            break
    line_index = {"id": 1, "secret": 0, "refresh": i}
    line = lines[line_index[cred]].decode()
    # for microsoft oauth, refresh token is perodically updated
    # https://docs.microsoft.com/en-us/azure/active-directory/develop/refresh-tokens
    if cred == "refresh":
        refresh = get_pass("email/oauth/%s_refresh" % email)
        line = refresh if refresh is not None else line
    return (line if ":" not in line else line.split(":")[-1]).strip().encode()

def make_ms_client(email):
    """ Makes a microsoft client. """
    cid, secret = get_oauth2("id", email), get_oauth2("secret", email)
    authority = "https://login.microsoftonline.com/%s" % MS_TENANT
    app = msal.ConfidentialClientApplication(cid, secret, authority)
    return app

def google_refresh_token(email):
    """ Gets a refresh token using gmail-oauth2-tools. """
    cid, secret = get_oauth2("id", email), get_oauth2("secret", email)
    scope = "https://mail.google.com/"
    print("To authorize token, visit this url and follow the directions:")
    print("  %s" % oauth2.GeneratePermissionUrl(cid, scope))
    code = raw_input("Enter verification code: ")
    return oauth2.AuthorizeTokens(cid, secret, code)

def ms_refresh_token(email):
    """ Gets a refresh token using MSAL.
    Based on: https://github.com/UvA-FNWI/M365-IMAP/blob/main/get_token.py """
    app = make_ms_client(email)
    url = app.get_authorization_request_url(MS_SCOPES, request_uri=MS_REDIRECT)
    print("To authorize token, visit this url and follow the directions:")
    print("  %s" % url)
    response = raw_input("Enter response url: ")
    for token in response.split("?")[1].split("&"):
        key, value = token.split("=")
        if key == "code":
            code = value
            break
    return app.acquire_token_by_authorization_code(code, MS_SCOPES, redirect_uri=MS_REDIRECT)

def google_access_token(email):
    """ Gets an access token using gmail-oauth2-tools. """
    creds = [get_oauth2(cred, email) for cred in ["id", "secret", "refresh"]]
    response = oauth2.RefreshToken(*creds)
    return response["access_token"], response["expires_in"]

def ms_access_token(email):
    """ Gets an access token using MSAL. """
    app, refresh = make_ms_client(email), get_oauth2("refresh", email)
    response = app.acquire_token_by_refresh_token(refresh, MS_SCOPES)
    # save new refresh token, which is generated after every access token
    set_pass("email/oauth/%s_refresh" % email, response["refresh_token"])
    return response["access_token"], response["expires_in"]

def get_access_token(email):
    """ Gets an access token, using the cache if it is valid.
    based on oauth2token: https://github.com/tenllado/dotfiles/tree/master/config/msmtp """
    token_path = "email/oauth/%s" % email
    lines = get_pass(token_path, first_line=False)
    now = int(time.time())
    # if cached, use cached access token
    if lines is not None:
        token, expire = lines
        expire_time = int(expire.split(":")[1].strip())
        # more than 60 seconds from expiring 
        if expire_time - now >= 60:
            return token
    # otherwise, generate token and update
    token, expire = query(email, "access_token")
    set_pass(token_path, "%s\nexpire: %i" % (token, now + expire))
    return token

PROVIDER_DATA = {
    "google": {
        "path": lambda email: "email/accounts.google.com/oauth2",
        "refresh_token": google_refresh_token,
        "access_token": google_access_token,
    },
    "microsoft": {
        "path": lambda email: "email/oauth/microsoft",
        "refresh_token": ms_refresh_token,
        "access_token": ms_access_token,
    },
}

def get_provider(email):
    """ Returns the type of OAuth for the email. """
    return "microsoft" if email in MS_EMAILS else "google"

def query(email, key):
    """ Returns the desired key for the email. """
    return PROVIDER_DATA[get_provider(email)][key](email)

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
nametrans_reverse_dict = {v: k for k, v in nametrans_dict.items()}
assert len(nametrans_dict) == len(nametrans_reverse_dict), "duplicate entries"

def nametrans(folder, d):
    """ Rename a remote folder to a local folder.
    https://www.offlineimap.org/doc/nametrans.html#nametrans """
    return d.get(folder, folder)

gmail_nametrans = lambda folder: nametrans(folder, nametrans_dict)
gmail_nametrans_reverse = lambda folder: nametrans(folder, nametrans_reverse_dict)

folderfilter_blacklist = [
    # helpful to parse spam messages manually
    # "[Gmail]/Spam",
    "[Gmail]/Important",
    # maintain local flags
    "[Gmail]/Starred",
    # thunderbird folders, doesn't save to special [Gmail] folder 
    "Drafts",
    "Trash",
]

def gmail_folderfilter(folder):
    """ Returns True if the folder should be synced, otherwise False.
    https://www.offlineimap.org/doc/nametrans.html#folderfilter """
    return folder not in folderfilter_blacklist

# microsoft equivalents

ms_nametrans_dict = {
    "Archive": "archive",
    "Drafts": "drafts",
    "Sent Items": "sent",
    "Junk Email": "spam",
    "Deleted Items": "trash",
    "INBOX": "inbox",
}
ms_nametrans_reverse_dict = {v: k for k, v in ms_nametrans_dict.items()}
assert len(ms_nametrans_dict) == len(ms_nametrans_reverse_dict), "duplicate entries"

ms_nametrans = lambda folder: nametrans(folder, ms_nametrans_dict)
ms_nametrans_reverse = lambda folder: nametrans(folder, ms_nametrans_reverse_dict)

ms_folderfilter_blacklist = [
    # check whether messages end up in sent
    "Outbox",
    "Contacts",
    "Conversation History",
    "Journal",
    "Notes",
    "Tasks"
]

ms_folderfilter = lambda folder: folder not in ms_folderfilter_blacklist and \
    "Calendar" not in folder

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="oauth2 token management")
    parser.add_argument("email")
    parser.add_argument("-r", "--refresh", action="store_true",
                        help="get a refresh token instead of access")

    args = parser.parse_args()
    email = args.email

    if args.refresh:
        response = query(email, "refresh_token")
        print("Refresh Token: %s" % response["refresh_token"])
        print("Access Token: %s" % response["access_token"])
        print("Access Token Expiration Seconds: %s" % response["expires_in"])
    # get oauth2 access token for msmtp
    else:
        print(get_access_token(email))

