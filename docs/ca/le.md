#### Your certificates issued by [Let's Encrypt][0].
Claim another one via:
```bash
dns3l claim foo.example.com --ca letsencrypt
```
Use [Let's Encrypt Staging](letsencrypt-staging.md) during developing automation.

[0]: https://letsencrypt.org/

Pick the right data for your TLS endpoint `foo.example.com`. Find further (sometimes misleading) details [here][1].

* `cert.pem`: your leaf entity cert `foo.example.com`
* `privkey.pem`: unencrypted private key for your leaf entity cert
* `chain.pem`: intermediate cert(s) and root cert for your leaf entity cert
* `fullchain.pem`: `cert.pem` + `chain.pem`

[1]: https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates

Check that your TLS endpoint `foo.example.com` is configured properly:
```bash
echo | openssl s_client -connect foo.example.com:443 [-showcerts]
...
Certificate chain
 0 s:CN = foo.example.com
   i:C = US, O = Let's Encrypt, CN = R3
 1 s:C = US, O = Let's Encrypt, CN = R3
   i:C = US, O = Internet Security Research Group, CN = ISRG Root X1
 2 s:C = US, O = Internet Security Research Group, CN = ISRG Root X1
   i:O = Digital Signature Trust Co., CN = DST Root CA X3
...
```
Populating the leaf entity cert `#0` and intermediate cert(s) `#1` is mandatory.
Populating a root cert `#2` is recommended but optional.
