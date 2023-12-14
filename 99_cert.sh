#!/bin/bash
set -e

if [ -f "/certs/server.crt" ] && [ -f "/certs/server.key" ]; then
  cp /certs/server.crt /certs/server.key /var/lib/postgresql/data/
  chown postgres:postgres /var/lib/postgresql/data/server.crt
  chown postgres:postgres /var/lib/postgresql/data/server.key
  chmod 600 /var/lib/postgresql/data/server.key

  sed -i -e '/ssl\s*=/s/^.*$/ssl = on/' /var/lib/postgresql/data/postgresql.conf || true
  sed -i -e "/ssl_cert_file\s*=/s/^.*$/ssl_cert_file = 'server.crt'/" /var/lib/postgresql/data/postgresql.conf || true
  sed -i -e "/ssl_key_file\s*=/s/^.*$/ssl_key_file = 'server.key'/" /var/lib/postgresql/data/postgresql.conf || true
  sed -i -e "/ssl_ciphers\s*=/s/^.*$/ssl_ciphers = 'HIGH:MEDIUM:+3DES:!aNULL' # allowed SSL ciphers/" /var/lib/postgresql/data/postgresql.conf || true
fi
