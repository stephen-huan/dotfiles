# [mutt](https://neomutt.org/)

`mutt` is a mail user agent (MUA). More specifically, it lets you read
email from the terminal. It is possible to download and send mail from
mutt natively, but I prefer external programs for those functions.

A quick overview:
- downloading mail: [offlineimap](#offlineimap)
- reading mail: mutt + [neovim](./vim.md) (occasional full-screen reading) + 
[w3m](http://w3m.sourceforge.net/) (for html emails)
- editing mail: [vim](./vim.md)
- sending mail: [msmtp](#msmtp)
- indexing mail: [notmuch](#notmuch)
- encrypting mail: [gpg](https://gnupg.org/software/gpgme/index.html)
- adding attachments: [ranger](./ranger.md)
    - determining what program to use to open attachments: [rifle](./ranger.md)
- general selector: [fzf](https://github.com/junegunn/fzf)

### neomutt

Whenever I say "mutt" I really mean "neomutt". It's not like [vim](./vim.md)
where neovim isn't _quite_ identical to vim. neomutt is essentially a superset
of regular [mutt](https://gitlab.com/muttmua/mutt/-/wikis/home) aiming to fix
bugs, collect patches, and in general incite development of mutt. It therefore
makes sense to use neomutt rather than mutt.

### General Notes

My primary email is gmail, which has its quirks. In particular, all emails go
into "all mail" (including emails sent by you!) and the different "folders" are
more like _tags_ --- attributes of the emails in all mail. This mirrors notmuch
nicely but IMAP not so much so there will be a few oddities.

I use PGP to sign and encrypt email. For more information (and tips), see this
[gist](https://gist.github.com/stephen-huan/bc6c9cf7fc9a4f806f265b2738d2b32e).

Lastly, I use Google's [Advanced
Protection](https://landing.google.com/advancedprotection/) program.
Surprisingly enough, one can use command-line tools to access mail even with
advanced protection on (if you authenticate with oauth2).

With that in mind, the first step is to get mail.

## [offlineimap](https://www.offlineimap.org/)

`offlineimap` is used to download (and sync!) mail. Note that this is a
two-way operation: it will update the local repository of mail if there
are changes in the remote and _it will also update the remote if there
are local changes!_ There is a risk of deleting email permanently if you
delete locally and have offlineimap sync. Run with the `--dry-run` option
to see what offlineimap will do while testing.

offlineimap is configured with Python, unfortunately Python 2. The same
author also wrote [imapfw](https://github.com/OfflineIMAP/imapfw),
a Python 3 replacement, but the project appears to be dead.

In order to authenticate, we must use oauth2
as mentioned before. Follow the instructions
[here](https://github.com/OfflineIMAP/offlineimap/blob/master/offlineimap.conf).
A word of warning: the Google Cloud Console is one of the worst
designed websites I've used. I am somehow always confused
despite having generated many tokens for other projects before.

That will give a client id, secret, and refresh token. I store these in the
lightweight PGP-based password manager [pass](./pass.md). To generate an access
token, we could use offlineimap's built-in `oauth2_refresh_token_eval` option
but for integration with `msmtp` and caching we might as well use our own
program: [offlineimap.py](../.config/offlineimap/offlineimap.py) along with the
[gmail-oauth2-tools](https://github.com/google/gmail-oauth2-tools) repository.

Note: if you're getting something along the lines of `KeyError:
'access_token'` it's because the refresh token is invalid. This can
occur if more than 50 refresh tokens are created, in which case
the first refresh token is invalidated. Why should this happen if
you only created 1 token? Even if we set `oauth2_access_token`,
passing `oauth2_client_id` and `oauth2_client_secret_eval` likely
has offlineimap attempt to generate a refresh token (since we don't
pass in a refresh token). If we're using an access token, offlinemap
doesn't need client_id and client_secret so don't have them set.

## [msmtp](https://marlam.de/msmtp/)

With offlineimap configured, `msmtp` works similarly. Set the authentication
protocol to `oauthbearer` and `passwordeval` to run the above `offlineimap.py`
script, passing in the email. That way both `offlineimap` and `msmtp` use the
same cached access token.

## [notmuch](https://notmuchmail.org/)

`notmuch` is an email indexer, tagger, and searcher. Add a postsync hook to
`offlineimap` so tagging happens on new mail. We can also use notmuch as
an address book by searching the addresses of the emails you've received.

