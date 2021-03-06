# What's here

## `transcrypt.sh`
Purpose: To serve as an encryption/decryption connector between applications and persistent storage (such as a database). Retrieval of values based on exact matching depends on convergent encryption, thus the use of a context value. See this documentation for more info: https://www.vaultproject.io/docs/secrets/transit/

### Usage

```
$ export VAULT_ADDR=http://myvault.com:8200
$ export VAULT_TOKEN=f210025a-2a50-e5be-2f5e-65aa5245068b

$ source transcrypt.sh ;\
    PAYLOAD='Encryption in a can.' \
    TRANSIT_PATH=transit \
    TRANSIT_KEY=bar \
    CONTEXT='user@mycompany.com' \
    encrypt_payload
$ vault:v1:edrphWAzMO5qRH/Y/ZinSGjB6oKwL0H2l4gY4jhMAOqi66ybviDGnpSkWlQ0nFhZEg==

$ source transcrypt.sh ;\
    PAYLOAD=vault:v1:edrphWAzMO5qRH/Y/ZinSGjB6oKwL0H2l4gY4jhMAOqi66ybviDGnpSkWlQ0nFhZEg== \
    TRANSIT_PATH=transit \
    TRANSIT_KEY=bar \
    TRANSIT_KEY=${TRANSIT_KEY} \
    CONTEXT='user@mycompany.com' \
    decrypt_payload
$ Encryption in a can.
```

## `db_transcrypt.sh`
Purpose: To demonstrate storing and retrieving MySQL database values that are encrypted and decrypted by HashiCorp Vault. For more information, see https://www.vaultproject.io/docs/secrets/transit/

### Usage
```
TRANSIT_KEY=bar \
TRANSIT_PATH=transit \
DB_HOST=my.mysql.host \
DB_USER=my_db_user \
DB_NAME=my_db \
DB_TABLE=my_customers \
DB_PASS=mydbpass \
CUSTOMER_NAME="Bob Jones" \
CUSTOMER_PHONE="07481111111" \
CUSTOMER_EMAIL="user@mycompany.com" \
sh db_transcrypt.sh
```
