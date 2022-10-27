#!/bin/bash

# An API example client. Useful for bootstrapping.

DNS3L_URL=https://localhost/api # http://dns3ld:8880/api
AUTH_URL=https://localhost/auth # https://auth:5554/auth

CLIENT_ID=dns3l-api
CLIENT_SECRET=secret
USER=certbot
PASS=password
CA_ID=id
CERT_NAME=foo.example.com

CERT_URL=${DNS3L_URL}/ca/${CA_ID}/crt/${CERT_NAME}

TOKEN_URL=`curl -k -s "${AUTH_URL}/.well-known/openid-configuration" | jq -r .token_endpoint`
# TOKEN_URL=${AUTH_URL}/token

echo ${TOKEN_URL}

ID_TOKEN=`curl -k -s -X POST -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  -d "grant_type=password&scope=openid profile email groups offline_access&username=${USER}&password=${PASS}" \
  ${TOKEN_URL} | jq -r .id_token`

echo ${ID_TOKEN}

if [[ -z ${ID_TOKEN} || ${ID_TOKEN} == "null" ]]; then
  echo Oooops. Invalid token.
  exit
fi

# Claim
cat <<EOT | curl -k -s -X POST \
 -H 'content-type: application/json' \
 -H "Authorization: Bearer ${ID_TOKEN}" \
 -d @- ${DNS3L_URL}/ca/${CA_ID}/crt
{ "name": "${CERT_NAME}", "wildcard": false, "san": [ ] }
EOT

# Retrieve
curl -k -s -H "Authorization: Bearer ${ID_TOKEN}" ${CERT_URL}/pem/key
curl -k -s -H "Authorization: Bearer ${ID_TOKEN}" ${CERT_URL}/pem/fullchain
