#!/usr/bin/env bash
set -euo pipefail

cd $(dirname "$0")

crt_subj=postgres
crt_name=server

openssl req -newkey rsa:2048 -nodes \
  -subj "/CN=${crt_subj}" \
  -keyout "${crt_name}.key" -out ca.csr

openssl x509 -req -days 36524 \
  -extfile pg-crt.ext -sha256 \
  -signkey "${crt_name}.key" \
  -in ca.csr -out "${crt_name}.crt"

rm ca.csr

openssl pkcs12 -export \
  -in "${crt_name}.crt" -inkey "${crt_name}.key" \
  -out "${crt_name}.pfx" \
  -passout pass:crt01pass -name "${crt_subj}"