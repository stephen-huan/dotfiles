# [neomutt](https://neomutt.org/)

`neomutt` is a mail user agent (MUA). More specifically, it lets you
read email from the terminal. It is possible to download and send mail
from mutt natively, but I prefer external programs for those functions.

A quick overview:

- downloading mail: [offlineimap](#offlineimap)
- sending mail: [msmtp](#msmtp)
- reading mail: neomutt + [neovim](/pkgs/applications/editors/neovim.md)
  (occasional full-screen reading) +
  [w3m](http://w3m.sourceforge.net/) (for html emails)
- editing mail: [neovim](/pkgs/applications/editors/neovim.md)
- indexing mail: [notmuch](#notmuch)
- encrypting mail: [gpg](https://gnupg.org/software/gpgme/index.html)
- adding attachments: [ranger](/pkgs/applications/file-managers/ranger.md)
  - determining what program to use to open attachments:
    [rifle](/pkgs/applications/file-managers/ranger.md)
- general selector: [fzf](https://github.com/junegunn/fzf)

### neomutt

[neomutt](https://neomutt.org/) is essentially a superset of regular
[mutt](https://gitlab.com/muttmua/mutt/-/wikis/home) aiming to fix
bugs, collect patches, and in general incite development of mutt. It
therefore makes sense to use neomutt rather than mutt.

### General Notes

My primary email is gmail, which has its quirks. In particular, all emails go
into "all mail" (including emails sent by you!) and the different "folders" are
more like _tags_ --- attributes of the emails in all mail. This mirrors notmuch
nicely but IMAP not so much so there will be a few oddities.

I use PGP to sign and encrypt email. For more information (and tips),
see [my website](https://stephen-huan.github.io/2021/02/21/email.html).

Lastly, I use Google's [Advanced
Protection](https://landing.google.com/advancedprotection/) program.
Surprisingly enough, one can use command-line tools to access mail even with
advanced protection on (if you authenticate with OAuth2).

With that in mind, the first step is to get mail.

## [offlineimap](https://www.offlineimap.org/)

`offlineimap` is used to download (and sync!) mail. Note that this is a
two-way operation: it will update the local repository of mail if there
are changes in the remote and _it will also update the remote if there
are local changes!_ There is a risk of deleting email permanently if you
delete locally and have offlineimap sync. Run with the `--dry-run` option
to see what offlineimap will do while testing.

offlineimap is configured with Python, unfortunately Python 2. There's a
[Python 3 fork](https://github.com/OfflineIMAP/offlineimap3) of offlineimap,
and the same author also wrote [imapfw](https://github.com/OfflineIMAP/imapfw),
a Python 3 replacement, but the project appears to be dead.

In order to authenticate, we must use OAuth2 as mentioned before. The specific
steps depends on the email provider, but in general we need a client id,
secret, and refresh token. We can redeem the refresh token for an access token,
which is what we actually use to authenticate. I store these credentials in the
lightweight PGP-based password manager [pass](./pass.md). To generate an access
token, we could use offlineimap's built-in `oauth2_refresh_token_eval` option
but for integration with `msmtp` and caching we might as well use our own
program: [offlineimap.py](../.dotfiles/config/offlineimap/offlineimap.py).

Google and Microsoft cover all my email accounts, including those which
that are not necessarily `@gmail.com` or `@hotmail.com`. For example,
my [Georgia Tech email](https://support.cc.gatech.edu/services/e-mail)
ending in `@gatech.edu` is actually provided by Outlook, so I can use
[Microsoft OAuth](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols)
to authenticate, without needing to go through
Georgia Tech's single sign-on authentication portal.

### Google OAuth

We'll be using the
[gmail-oauth2-tools](https://github.com/google/gmail-oauth2-tools)
repository as the client library.

Follow the instructions
[here](https://github.com/OfflineIMAP/offlineimap/blob/e70d3992a0e9bb0fcdf3c94e1edf25a4124dfcd2/offlineimap.conf#L918-L937).
The Google Cloud Console is pretty poorly designed, so it may
take some effort to figure out how to create a new project.

If you're getting something along the lines of `KeyError: 'access_token'` it
might be that the refresh token is invalid. This is because Google's [OAuth
policy](https://developers.google.com/identity/protocols/oauth2#expiration)
restricts the lifespan of a refresh token to 7 days if the app is configured
for external users and the publishing setting is "Testing", a common situation
one would be in for personal use. The solution is to press the "PUBLISH APP"
button on the OAuth consent screen. Although it will warn you that "Because
you're using one or more sensitive scopes, your app registration requires
verification by Google. Please prepare your app to submit for verification",
you don't actually need to verify the app, that just removes the warning screen
asking the user whether they trust the developer while getting a refresh token.

### Microsoft OAuth

We'll be using the
[msal](https://msal-python.readthedocs.io/en/latest/) client library.

Follow the instructions to [create a new application](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
and [add IMAP and SMTP permissions](https://docs.microsoft.com/en-us/exchange/client-developer/legacy-protocols/how-to-authenticate-an-imap-pop-smtp-application-by-using-oauth).
These instructions are a bit verbose, so I'll condense them here:

1. Navigate to the [Azure portal](https://portal.azure.com/)
2. Go to "Azure Active Directory", either by searching or clicking on the icon
3. Find "App registrations" in the side bar
   under "Manage" and press "New registration"
4. Under "Manage", select "Authentication". Use the "Web"
   platform with a redirect URI of "http://localhost".
5. Select "Certificates & secrets" and press "New
   client secret". Record the client id and secret.
6. Select "API Permissions". Press "Add a permission" and use "Microsoft
   Graph" with "Delegated permissions". The permissions we need are
   `offline_access` (under OpenId permissions), `User.Read` (under User),
   `IMAP.AccessAsUser.all` (under IMAP) and `SMTP.Send` (under SMTP).
7. Depending on the situation, we might need a tenant. For Georgia Tech,
   this is `gtvault.onmicrosoft.com`. This value can be found by going to
   the "Azure Active Directory" page and looking at the value of "Primary
   domain". Otherwise, this can be set to `common`.

Something strange Microsoft does is their [refresh tokens](https://docs.microsoft.com/en-us/azure/active-directory/develop/refresh-tokens):
they give a new refresh token back after every access token request, and
refresh tokens expire after 90 days. If you were authenticating through
offlineimap, you might be passing `oauth2_refresh_token` so offlineimap can
automatically request access tokens. So if you suddenly become unable to
request access tokens, it might be because of the refresh token expiration.
`offlineimap.py` will automatically save the refreshed refresh token, but
you still need to update the client secrets at least every two years (since
24 months is the longest possible expiration date for client secrets).

## [msmtp](https://marlam.de/msmtp/)

With offlineimap configured, `msmtp` works similarly. Set the authentication
protocol to `oauthbearer` and `passwordeval` to run the above `offlineimap.py`
script, passing in the email. That way both `offlineimap` and `msmtp` use the
same cached access token.

## [notmuch](https://notmuchmail.org/)

`notmuch` is an email indexer, tagger, and searcher. Add a postsync hook to
`offlineimap` so tagging happens on new mail. We can also use notmuch as
an address book by searching the addresses of the emails you've received.
