#### Your certificates issued by [Let's Encrypt][0].
Claim another one via:
```bash
CA_ID=Your Let's Encrypt CA provider ID
CERT_NAME=foo.example.com # FQDN as cert name

dns3l.sh --ca ${CA_ID} claim ${CERT_NAME}

```
Use [Let's Encrypt Staging][1] during developing automation.

[0]: https://letsencrypt.org/
[1]: https://letsencrypt.org/docs/staging-environment/

Pick the right data for your TLS endpoint `foo.example.com`.

* `dns3l.sh --ca ${CA_ID} key ${CERT_NAME}`: unencrypted private key for your leaf entity cert
* `dns3l.sh [--anonymous] --ca ${CA_ID} crt ${CERT_NAME}`: your leaf entity cert
* `dns3l.sh [--anonymous] --ca ${CA_ID} rootchain ${CERT_NAME}`: intermediate cert(s) and root cert for your leaf entity cert
* `dns3l.sh [--anonymous] --ca ${CA_ID} fullchain ${CERT_NAME}`: `crt` + `rootchain`

[2]: https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates

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
