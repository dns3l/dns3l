The [dns3l-core][2] project is implementing a fancy CLI besides the backend. Until this is released here is a quick'n'dirty user-friendly DNS3L CLI script. Utilizing [Argbash][0]. An argument parser generator for Bash...

### Usage

```bash
dns3l.sh --help
```

### Using [Argbash][0]:

```bash
curl -L https://github.com/matejak/argbash/archive/refs/tags/2.10.0.tar.gz | tar xvz
cd argbash-2.10.0/resources/; make install; argbash
# -or-
argbash-2.10.0/bin/argbash

# rebuild your script and CLI inline
argbash -i foo.sh

# generate Bash completion script for your script CLI
argbash foo.sh --type completion --strip all -o foo-completion.sh
# ...if you split your script and CLI
argbash cli.sh --type completion --strip all -o foo-completion.sh
```

[0]: https://argbash.io/
[1]: https://argbash.readthedocs.io/en/stable/guide.html#convenience-macros
[2]: https://github.com/dns3l/dns3l-core
