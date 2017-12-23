#!/bin/bash install_mysql.sh

## Purpose: To install a test intance of a MySQL server on
#  a RHEL 7 host.  To be run as root.
#  See this article for more information:
#    https://linode.com/docs/databases/mysql/how-to-install-mysql-on-centos-7/

  yum -y update
  yum -y install wget
  wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
  sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
  yum -y update
  yum -y install mysql mysql-server
  systemctl start mysqld
