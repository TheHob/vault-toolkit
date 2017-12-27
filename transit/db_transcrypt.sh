#!/bin/bash ./db_transcrypt.sh

## Purpose: To demonstrate storing and retrieving MySQL
#  database values that are encrypted and decrypted by
#  HashiCorp Vault.

  # Get the Vault encrypt/decrypt functions we need
  source ./transcrypt.sh


  VAULT_TOKEN=${VAULT_TOKEN}
  TRANSIT_PATH=${TRANSIT_PATH}
  TRANSIT_KEY=${TRANSIT_KEY}
  CONTEXT=$(echo ${CUSTOMER_EMAIL} |base64)
  NAME=$(PAYLOAD=${CUSTOMER_NAME} TRANSIT_PATH=${TRANSIT_PATH} TRANSIT_KEY=${TRANSIT_KEY} CONTEXT=${CONTEXT}  encrypt_payload)
  PHONE=$(PAYLOAD=${CUSTOMER_PHONE} TRANSIT_PATH=${TRANSIT_PATH} TRANSIT_KEY=${TRANSIT_KEY} CONTEXT=${CONTEXT} encrypt_payload)
  EMAIL=$(PAYLOAD=${CUSTOMER_EMAIL} TRANSIT_PATH=${TRANSIT_PATH} TRANSIT_KEY=${TRANSIT_KEY} CONTEXT=${CONTEXT} encrypt_payload)
  DB_USER=${DB_USER}
  DB_PASS=${DB_PASS}
  DB_NAME=${DB_NAME}
  DB_TABLE=${DB_TABLE}
  DB_HOST=${DB_HOST}
  GREEN='\033[0;32m'
  NC='\033[0m'



  [[ -z "$VAULT_TOKEN" ]] && echo "${GREEN}Please set your '\$VAULT_TOKEN' variable and retry.${NC}" && exit || continue

  encrypted_insert () {
  #INSERT INTO customers ( name, phone, email ) VALUES ( "$NAME", "$PHONE", "$EMAIL" );
  mysql -u${DB_USER} -p${DB_PASS} \
    -h ${DB_HOST} \
    -e "REPLACE INTO ${DB_NAME}.${DB_TABLE} \
    ( name, phone, email ) VALUES ( '${NAME}', '${PHONE}', '${EMAIL}' );" \
    2> /dev/null
  }

  encrypted_retrieve () {
    mysql -Ns -u${DB_USER} -p${DB_PASS} \
    -h ${DB_HOST} -e "SELECT ${FIELD} from ${DB_NAME}.${DB_TABLE} where name='${NAME}'" \
    2> /dev/null
  }

  decrypt_retrieved () {
    PAYLOAD=${RETRIEVED_VALUE} \
    TRANSIT_PATH=${TRANSIT_PATH} \
    TRANSIT_KEY=${TRANSIT_KEY} \
    CONTEXT=${CONTEXT} \
    decrypt_payload
  }

  # First, the raw values
  echo "\n${GREEN}Your values before encryption:${NC}"
  echo "Customer name: ${CUSTOMER_NAME}"
  echo "Customer phone: ${CUSTOMER_PHONE}"
  echo "Customer email: ${CUSTOMER_EMAIL}\n"

  # Now the encrypted values
  echo "${GREEN}Your values encrypted by Vault, but not yet inserted into the database:${NC}"
  echo "Name:  ${NAME}"
  echo "Phone: ${PHONE}"
  echo "Email: $EMAIL\n"

  # Insert values into the database
  encrypted_insert &&

# Note the database insertion that was made
echo "\n${GREEN}The following database insertion has been executed: ${NC}\n\
'REPLACE INTO test.customers ( name, phone, email ) VALUES ( '${NAME}', '${PHONE}', '${EMAIL}' );'\n"

# Let's retrieve encrypted values
echo "${GREEN}Encrypted values retrieved from the database:${NC}"
RETRIEVED_NAME=$(FIELD=name encrypted_retrieve)
RETRIEVED_PHONE=$(FIELD=phone encrypted_retrieve)
RETRIEVED_EMAIL=$(FIELD=email encrypted_retrieve)
echo "Retrieved name (encrypted): ${RETRIEVED_NAME}"
echo "Retrieved phone (encrypted): ${RETRIEVED_PHONE}"
echo "Retrieved email (encrypted): ${RETRIEVED_EMAIL}\n"

## Let's decrypt the retrieved values
echo "${GREEN}Values retrieved from the database and decrypted:${NC}"
DECRYPTED_NAME=$(RETRIEVED_VALUE=${RETRIEVED_NAME}  decrypt_retrieved)
DECRYPTED_PHONE=$(RETRIEVED_VALUE=${RETRIEVED_PHONE} decrypt_retrieved)
DECRYPTED_EMAIL=$(RETRIEVED_VALUE=${RETRIEVED_EMAIL} decrypt_retrieved)

echo "Retrieved name (decrypted): ${DECRYPTED_NAME}"
echo "Retrieved phone (decrypted): ${DECRYPTED_PHONE}"
echo "Retrieved email (decrypted): ${DECRYPTED_EMAIL}\n"
