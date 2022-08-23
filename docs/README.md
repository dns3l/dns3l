## Intro

Today [X.509][1] based [TLS][0] aka X5C is a crucial part of infrastructure also in popular HTTPS based microService architectures. Since a couple of years there is [ACME][3]. A standard to drive X5C automation. Established for the internet by [Let's Encrypt][4]. The well-known public ACME CA today.

But it's still not continuously integrated into current IT architectures. In best case the usual integration today is a running ACME client on each TLS consuming system bound to a (public) ACME CA like Let's Encrypt. This pattern includes drawbacks for air gapped large enterprises. Each system needs outbound HTTPS connectivity to the ACME CA. And utilizing a CA which requires authentication, their credentials needs to be spread across all systems.

Here DNS3L comes in place. It's a kind of a centralized [ACME client][5] that supports public ACME CA as well as [internal ACME CA][6] in case your treat model is sensitive regarding [Certificate Transparency][7] Logs. If not you can serendipitously use X5C from public CA without pain beyond the air gap.

[0]: https://wikipedia.org/wiki/Transport_Layer_Security
[1]: https://wikipedia.org/wiki/X.509
[2]: https://datatracker.ietf.org/doc/html/rfc8555
[3]: https://wikipedia.org/wiki/Automatic_Certificate_Management_Environment
[4]: https://letsencrypt.org/
[5]: https://certbot.eff.org/
[6]: https://smallstep.com/docs/step-ca
[7]: https://wikipedia.org/wiki/Certificate_Transparency

![DNS3L](.assets/figure1.png)

1. DNS3L | Certbot ACME client
2. private ACME CA
3. public DNS service
4. public ACME CA
5. internal DNS service
6. your apps and services
7. air gap
8. HTTPS outbound only

## DNS

(Public) DNS is used for ACME validation. And the `CommonName` of your certificate should have a proper `A` or `CNAME`. **AutoDNS** is the DNS3L feature that tries to simplifies the last part.

### ACME DNS-01 validation

For (public) ACME DNS-01 validation DNS3L tries to support initially...
* [Open Telekom Cloud (OTC)][10]
* [desec.io][11]

### AutoDNS

For (internal) AutoDNS creation DNS3L tries to support initially...
* [PowerDNS][12]
* [Infoblox][13]

[10]: https://docs.otc.t-systems.com/dns/
[11]: https://desec.io/
[12]: https://doc.powerdns.com/authoritative/
[13]: https://www.infoblox.com/products/ddi/

## Auth

The software usually runs beyond the Iron Curtain inside the enterprise. Actually we are integrating [Dex][21] OIDCP as auth backend to address modern OAuth2/OIDC patterns and to inject Active Directory/LDAP group memberships into OIDC JWS ID tokens `groups[]` scope. Other enterprise IDM backends than Active Directory/LDAP like GitLab, Atlassian, ... are supported by [Dex][21]. Local user management is (unfortunately) not supported by [Dex][21].

**Authentication** is done by the client. The client acquires an OIDC ID token from the auth backend. Our web app is using the usual [Authorization Code][22] Grant flow. DevOps CLI tools can utilize the [Resource Owner Password Credentials][23] Grant flow:

[21]: https://dexidp.io/
[22]: https://tools.ietf.org/html/rfc6749#section-4.1
[23]: https://tools.ietf.org/html/rfc6749#section-4.3

```bash
OIDC_URL="http://localhost:5556/auth/.well-known/openid-configuration"
CLIENT_ID="id"
CLIENT_SECRET="secret"
USER="foobar"
PASS="secret"

TOKEN_URL=`curl -s "${OIDC_URL}" | jq -r .token_endpoint`

ID_TOKEN=`curl -s -X POST -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  -d "grant_type=password&scope=openid profile email groups offline_access&username=${USER}&password=${PASS}" \
  ${TOKEN_URL} | jq -r .id_token`

echo ${ID_TOKEN}
```

**Authorization** is done optionally by the server. This enables multi tenant capability. The DNS3L backend receives an OIDC ID token from the client. The token is [validated][24] and based on the `groups[]` scope inside the token the server implements its authorization logic:

[24]: https://dexidp.io/docs/using-dex/#consuming-id-tokens

```json
"user": {
  "email": "kilgore@kilgore.trout",
  "email_verified": true,
  "groups": [
    "read",
    "write",
    "foo.example.com",
    "bar.example.net"
  ],
  "name": "Kilgore Trout" }
```

The main authorization logic is based on DNS root suffixes by convention. This means the user can read or manipulate everything under `.foo.example.com` and `.bar.example.net`. **You need to model the mapping between allowed root zones per user as groups inside your Active Directory/LDAP DIT**. Fine grained control between r/w per root zone per user is actually not supported.

Privilege escalation applies if `read` and `write` are both available. A valid token defaults to `write` in case authorization is disabled. To `read` otherwise. In case `email` or `name` are not set any `write` operation is denied.

## Configuration

## CLI

```
NAME:
 dns3l - CLI for dns3ld and DNS

USAGE:
 dns3l [global options] cert|dns command [command options] [arguments...]

VERSION:
 v0.1.7

COMMANDS:
 cert:     | Deal with DNS3L X.509 certificates
   ca      | List CAs utilized by DNS3L
   list    | List certs managed by DNS3L
   claim   | Obtain cert from DNS3L ACME CAs
   get     | Get cert from DNS3L
   del     | Delete cert managed by DNS3L
   csr     | Create CSR for DNS3L none ACME CAs
   push    | Push cert to DNS3L none ACME CAs
 dns:      | Deal with DNS3L DNS backends
   add     | Add A, CNAME, TXT, ... to DNS backend
   del     | Delete RR from DNS backend
   list    | List DNS backends
   query   | Query DNS backend

GLOBAL OPTIONS:
 -v, --debug     | Enable more output [$DNS3L_DEBUG]
 -c, --config    | Configuration (~/.dns3l.json) [$DNS3L_CONFIG]
 -j, --json      | Results as JSON
 -h, -?, --help  | Show help
 --version       | Print version


X.509 cert detailed usage
-------------------------

dns3l cert ca [--api=URL]
  List all certificate authorities (CA) utilized by DNS3L
Options:
  -u, --api   | DNS3L API endpoint [$DNS3L_API]
  -h, --help  | Show this message and exit

dns3l cert list [--ca=foo] [--api=URL]
  List all certificates managed by DNS3L
Options:
  -c, --ca    | Filter for a specific CA [$DNS3L_CA]
  -u, --api   | DNS3L API endpoint [$DNS3L_API]
  -h, --help  | Show this message and exit

dns3l cert claim [--ca=foo] [--wildcard=yes] [--autodns=10.1.2.3] [--api=URL] FQDN [SAN [SAN [...]]]
  Obtain a new certificate from DNS3L
Arguments:
  FQDN: FQDN as certificate name
  SAN: optional list of SAN
Options:
  -c, --ca        | Claim from a specific ACME CA [$DNS3L_CA]
  -w, --wildcard  | Create a wildcard (cannot be used with -d)
  -d, --autodns   | Create an A record (cannot be used with -w)
  -u, --api       | DNS3L API endpoint [$DNS3L_API]
  -h, --help      | Show this message and exit

dns3l cert get [--ca=foo] [--mode=full|cert|chain] [--api=URL] FQDN
  Get PEM certificate (chain) from DNS3L
Arguments:
  FQDN: FQDN as certificate name
Options:
  -c, --ca    | Get from a specific CA [$DNS3L_CA]
  -m, --mode  | Chain mode, full = cert + chain (default: full)
  -u, --api   | DNS3L API endpoint [$DNS3L_API]
  -h, --help  | Show this message and exit

dns3l cert del [--ca=foo] [--api=URL] FQDN
  Delete certificate managed by DNS3L
Arguments:
  FQDN: FQDN as certificate name
Options:
  -c, --ca    | Delete from a specific CA [$DNS3L_CA]
  -u, --api   | DNS3L API endpoint [$DNS3L_API]
  -h, --help  | Show this message and exit

dns3l cert csr [--ca=foo] [--api=URL] FQDN
  Create CSR and unencrypted private key for DNS3L none ACME CAs
Arguments:
  FQDN: FQDN as certificate name
Options:
  -c, --ca    | Create for a specific CA [$DNS3L_CA]
  -f, --force | Overwrite existing CSR/key
  -u, --api   | DNS3L API endpoint [$DNS3L_API]
  -h, --help  | Show this message and exit

dns3l cert push --ca=foo [--api=URL] FQDN CRT.pem CHN.pem
  Push certificate chain to DNS3L none ACME CA
Arguments:
  FQDN: FQDN as certificate name
  CRT.pem: Leaf cert PEM
  CHN.pem: Concatenated intermediate and root cert chain PEM
Options:
  -c, --ca    | Push to CA [$DNS3L_CA]
  -f, --force | Overwrite existing cert/chain
  -u, --api   | DNS3L API endpoint [$DNS3L_API]
  -h, --help  | Show this message and exit


DNS detailed usage
------------------

dns3l dns list
  List available DNS providers with supported RR types
Options:
  -h, --help  | Show this message and exit

dns3l dns query [--provider=infblx|otc|pdns|...] [--api=URL] FQDN
  List all RR found for FQDN
Arguments:
  FQDN: Fully qualified domain name, potential zone nesting is reflected
Options:
  -p, --provider  | DNS backend [$DNS3L_DNS]
  -u, --api       | DNS backend API endpoint [$DNS3L_DNSAPI]
  -h, --help      | Show this message and exit

dns3l dns add [--provider=infblx|otc|pdns|...] [--api=URL] FQDN TYPE DATA 
  Add resource record (DNS entry) to a backend
  If RR Type supports multiple entries DATA is added
  Use --force to change already existing DATA
Arguments:
  FQDN: Fully qualified domain name, potential zone nesting is reflected
  TYPE: A|TXT|CNAME|... Resource record type
  DATA: IP|STR|NAME IP address, string or canonical name based on TYPE
Options:
  -p, --provider  | DNS backend [$DNS3L_DNS]
  -u, --api       | DNS backend API endpoint [$DNS3L_DNSAPI]
  -f, --force     | Change existing DATA
  -h, --help      | Show this message and exit

dns3l dns del [--provider=infblx|otc|pdns|...] [--api=URL] FQDN TYPE [DATA] 
  Delete resource record (DNS entry) from a backend
  Delete DATA or complete record
Arguments:
  FQDN: Fully qualified domain name, potential zone nesting is reflected
  TYPE: A|TXT|CNAME|... Resource record type
  DATA: IP|STR|NAME IP address, string or canonical name based on TYPE
Options:
  -p, --provider  | DNS backend [$DNS3L_DNS]
  -u, --api       | DNS backend API endpoint [$DNS3L_DNSAPI]
  -h, --help      | Show this message and exit
```

## Usage
