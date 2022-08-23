#!/bin/sh

echo "${1}" > VERSION
sed -i -e "/version: .\+/s/.*/  version: ${1}/" openapi.yaml
