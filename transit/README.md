# What's here

## `transcrypt.sh`
Purpose: To serve as an encryption/decryption connector between applications and persistent storage (such as a database). Retrieval of values based on exact matching depends on convergent encryption, thus the use of a context value. See this documentation for more info: https://www.vaultproject.io/docs/secrets/transit/

### Usage

```
$ export VAULT_ADDR=http://myvault.com:8200
$ export VAULT_TOKEN=f210025a-2a50-e5be-2f5e-65aa5245068b

$ PAYLOAD='Randomness in a can.'  \
ACTION=encrypt TRANSIT_KEY=bar \
TRANSIT_PATH=transit \
CONTEXT='user@mycompany.com' \
sh transcrypt.sh
$ vault:v1:edrphWAzMO5qRH/Y/ZinSGjB6oKwL0H2l4gY4jhMAOqi66ybviDGnpSkWlQ0nFhZEg==

$ PAYLOAD=vault:v1:edrphWAzMO5qRH/Y/ZinSGjB6oKwL0H2l4gY4jhMAOqi66ybviDGnpSkWlQ0nFhZEg==  \
ACTION=decrypt \
TRANSIT_KEY=bar \
TRANSIT_PATH=transit \
CONTEXT='user@mycompany.com' \
sh transcrypt.sh
$ Randomness in a can.
```
