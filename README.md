![DNS3L](dns3l.svg)

is a shortcut for DNS plus SSL/TLS and a centralized [ACME][0] client that claims [X.509][1] certificates from [ACME][2] CA using DNS-01 validation,
provides an API, CLI, UI and a pluggable DNS library, manages renewals and publishes issued certificates of multiple CA. Supporting X5C handling for [TLS][5] in air gapped environments of large enterprises...

[0]: https://certbot.eff.org/
[1]: https://wikipedia.org/wiki/X.509
[2]: https://datatracker.ietf.org/doc/html/rfc8555
[5]: https://wikipedia.org/wiki/Transport_Layer_Security

Try the [docs](docs/) for further details...

We are using this repo to manage the project, publish the [API](openapi.yaml) and simplify deployment.

## Main components

* `dns3ld` backend
* `dns3l` CLI
* [UI](https://github.com/dns3l/web)
* [OIDC provider](https://github.com/dns3l/auth)

### Run

```bash
docker-compose -f stack.yml up
```

## Contribution

You are welcome! Please do not hesitate to contact us with any improvements of this work.

## License

Based on repository content we are using `apache-2.0` or `mit`.


[^1]: Similar [project][100] with a different scope
[^2]: [LEGO][101] gives a hint

[100]: https://github.com/grindsa/acme2certifier
[101]: https://github.com/go-acme/lego
