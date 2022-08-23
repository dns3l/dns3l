<img align="left" width="33%" src="https://github.com/iaean/dns3l/blob/master/dns3l.svg?raw=true" alt="DNS3L"/>

is a shortcut for DNS plus SSL/TLS and a centralized [certbot][0] that claims [X.509][1] certificates from [ACME][2] CA[^1] using DNS-01 validation, manages renewal and publishes the certificates via [Apache][3]. Additionally it provides a [StepCA][4] based private ACME CA/RA. Supporting X5C handling for [TLS][5] in air gapped environments of large enterprises.

Try the [docs](docs/) for further details...

[0]: https://certbot.eff.org/
[1]: https://wikipedia.org/wiki/X.509
[2]: https://datatracker.ietf.org/doc/html/rfc8555
[3]: https://httpd.apache.org/
[4]: https://smallstep.com/docs/step-ca
[5]: https://wikipedia.org/wiki/Transport_Layer_Security

### Run

```bash
docker-compose -f stack.yml up
```

### TODO

- [ ] **S3 backup/bootstrap/restore**
- [ ] Build and publish on Dockerhub
- [ ] Generic certbot DNS plugin that supports multiple ACME DNS backends
- [ ] Go based pluggable **CLI to cover the myriads of DNS backends** [^2]
- [ ] REST API that covers the backend and connects the frontend
- [ ] Store secrets like private keys in a (HC)Vault
- [ ] JSON config
- [ ] Helm chart for K8S adepts
- [ ] (optional) PowerDNS based internal authNS

### Contribution

You are welcome! Please do not hesitate to contact us with any improvements of this work. All work should be licensed under MIT license or compatible.

[^1]: Similar [project][100] with a different scope
[^2]: [LEGO][101] gives a hint

[100]: https://github.com/grindsa/acme2certifier
[101]: https://github.com/go-acme/lego
