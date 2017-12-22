#!/bin/bash ./transcrypt.sh

## Purpose: To serve as an encryption/decryption connector
#  between applications and persistent storage (such as a
#  database). Retrieval of values based on exact matching
#  depends on convergent encryption, thus the use of a
#  context value. See this documentation for more info:
#  https://www.vaultproject.io/docs/secrets/transit/

## Variables:
   #  VAULT_TOKEN - Token to authenticate with HashiCorp Vault.
   #  TRANSIT_PATH - Vault path on which the transit key is mounted.
   #  ACTION - Action to perform (encrypt|decrypt).
   #  TRANSIT_KEY - Name of the Vault encryption key to use. Must allow
   #  convergent encryption.
   #  PAYLOAD - Value to be encrypted or decrypted (encrypted values
   #  must include the Vault prefix, e.g 'vault:v1:vj5ddgCw77LC3...')
   #  CONTEXT - Context to use for convergent encryption. Any string works,
   #  but it must remain consistent for encryption and decryption of a given
   #  value.

VAULT_TOKEN=${VAULT_TOKEN}
TRANSIT_PATH='transit'
ACTION=${ACTION:-encrypt}
TRANSIT_KEY=${TRANSIT_KEY-'bar'}
PAYLOAD=${PAYLOAD:-'Behind the barrier.'}
CONTEXT=${CONTEXT:-'echo -n "185340909" | md5sum | awk '{print $1}' | base64'}

# Check for a Vault token
[[ -z "$VAULT_TOKEN" ]] && echo "Please set your '\$VAULT_TOKEN' variable and retry." && exit || continue

  encrypt_payload () {
    vault write -field=ciphertext $TRANSIT_PATH/encrypt/$TRANSIT_KEY \
      plaintext=`echo $PAYLOAD| base64` \
      context=`echo $CONTEXT | base64`
  }

  decrypt_payload () {
    vault write -field=plaintext $TRANSIT_PATH/decrypt/$TRANSIT_KEY \
      ciphertext=`echo $PAYLOAD` \
      context=`echo $CONTEXT | base64` |base64 -D
  }

#
#  # Encrypt or decrypt based on desired action
#  case $ACTION in
#    encrypt)
#      encrypt_payload ;;
#    decrypt)
#      decrypt_payload ;;
#    *)
#      echo "Please set ACTION=encrypt or ACTION=decrypt" ;;
#  esac
#
