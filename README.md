![DNS3L](dns3l.svg)

is a shortcut for DNS plus SSL/TLS and a centralized [ACME][0] client that claims [X.509][1] certificates from [ACME][2] CA using DNS-01 validation,
provides an API, CLI, UI and a pluggable DNS library, manages renewals and publishes issued certificates of multiple CA. Supporting X5C handling for [TLS][5] in air gapped environments of large enterprises...

[0]: https://certbot.eff.org/
[1]: https://wikipedia.org/wiki/X.509
[2]: https://datatracker.ietf.org/doc/html/rfc8555
[5]: https://wikipedia.org/wiki/Transport_Layer_Security

Try the [docs](docs/) for further details...

We are using this repo to manage the project, publish the [API](openapi.yaml) and simplify deployment.

We are releasing docker images and binaries for some platforms. For quick deployment there is a `docker compose` stack that provides main components:

| component | source | endpoint note |
| --- | --- | --- |
| ingress proxy | https://github.com/dns3l/ingress | `DNS3L_FQDN` default: `localhost` |
| dns3ld | https://github.com/dns3l/dns3l-core | `https://${DNS3L_FQDN}/api` |
| OIDC middleware | https://github.com/dns3l/auth | `https://${DNS3L_FQDN}/auth` |
| UI | https://github.com/dns3l/web | `https://${DNS3L_FQDN}` |
| smallstep middleware | https://github.com/dns3l/sra | not exposed |

### Run

```bash
docker compose -f stack.yml up
```

Stack uses per default `.env/..` for configuration.

See https://github.com/iaean/dns3lingress#multihomed about considerations for multi homed setups.

### Build via docker

```bash
git clone https://github.com/dns3l/dns3l
git clone https://github.com/dns3l/ingress dns3lingress
git clone https://github.com/dns3l/dns3l-core dns3lcore
git clone https://github.com/dns3l/auth dns3lauth
git clone https://github.com/dns3l/sra dns3lsra
git clone https://github.com/dns3l/web dns3lweb

cd dns3l

docker compose -f build.yml build
docker compose -f build.yml up
```

## Contribution

You are welcome! Please do not hesitate to contact us via PR, Issue or Discussion. For your PR use common [GitHub flow](https://github.com/dns3l/dns3l/wiki/GitHub-Workflow).

## License

Based on repository content we are using `apache-2.0` or `mit`.


[^1]: Similar [project][100] with a different scope
[^2]: [LEGO][101] gives a hint

[100]: https://github.com/grindsa/acme2certifier
[101]: https://github.com/go-acme/lego
