# [Stubby](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby)

It's recommended to use Stubby and Unbound in conjunction
(Stubby for some TLS managing functionality Unbound doesn't have,
and Unbound for the caching of DNS queries).
However, I can't get Stubby to play nice with Unbound and Unbound
seems to do a well enough job on its own.

In order to get [Cloudflare DNS](https://1.1.1.1/) to work with Stubby,
it's necessary to generate TLS pinsets which can be done with the following: 
```bash
echo | openssl s_client -connect 1.1.1.1:853 2>/dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```
