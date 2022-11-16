#!/bin/bash

# An API example client. Useful for bootstrapping.

if [ -f .env/auth ]; then
  . .env/auth
fi
if [ -f .env/ingress ]; then
  . .env/ingress
fi

DNS3L_URL=https://${DNS3L_FQDN:-localhost}/api # http://dns3ld:8880/api
AUTH_URL=https://${DNS3L_FQDN:-localhost}/auth # https://auth:5554/auth

CLIENT_ID=dns3l-api
CLIENT_SECRET=${CLIENT_SECRET:-secret}
USER=${DNS3L_USER:-certbot}
PASS=${DNS3L_PASS:-password}

CERT_NAME=${1:-foo.example.com}
CA_ID=${2:-id}
CERT_URL=${DNS3L_URL}/ca/${CA_ID}/crt/${CERT_NAME}
TOKEN_URL=`curl -k -s "${AUTH_URL}/.well-known/openid-configuration" | jq -r .token_endpoint`

echo ${TOKEN_URL}

ID_TOKEN=`curl -k -s -X POST -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  -d "grant_type=password&scope=openid profile email groups offline_access&username=${USER}&password=${PASS}" \
  ${TOKEN_URL} | jq -r .id_token`

if [[ -z ${ID_TOKEN} || ${ID_TOKEN} == "null" ]]; then
  echo Oooops. Invalid token.
  exit
fi

echo ${ID_TOKEN}
echo ${ID_TOKEN} | jq -R 'split(".") | .[0] | @base64d | fromjson' # header
echo ${ID_TOKEN} | jq -R 'split(".") | .[1] | @base64d | fromjson' # payload

# Claim
#cat <<EOT | curl -k -s -X POST \
# -H 'content-type: application/json' \
# -H "Authorization: Bearer ${ID_TOKEN}" \
# -d @- ${DNS3L_URL}/ca/${CA_ID}/crt
#{ "name": "${CERT_NAME}", "wildcard": false, "san": [ ] }
#EOT

# Retrieve
curl -k -s -H "Authorization: Bearer ${ID_TOKEN}" ${CERT_URL}/pem/key
curl -k -s -H "Authorization: Bearer ${ID_TOKEN}" ${CERT_URL}/pem/fullchain
