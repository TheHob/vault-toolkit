#!/bin/bash create_db.sh

## Purpose: Create a database to test database value encryption
#  in transit using HashiCorp Vault.
#  To be run on the host running MySQL.

DB_PASS='yourpassword'
cat > ./customer_data.sql <<EOF
drop database customer_data;
create database customer_data;
CREATE TABLE customer_data.customers ( name varchar(767) not null,  phone varchar(767) not null, email varchar(767) not null, constraint pk_example primary key (name) );
use customer_data;
GRANT ALL PRIVILEGES ON *.* TO 'webapp_user'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'webapp_user'@'%' IDENTIFIED BY '$DB_PASS';
EOF
