#!/bin/bash

echo '################################################################'

if [ "$EXTERNAL_CONFIGURATION" != "true" ] ; then

  if [ ! -f /etc/mysql/my.cnf ] ; then
    tar cfz /etc/mysql/galera_init_conf_bkp_$(date +%Y%m%d_%H%M$).tgz /etc/mysql
    tar xfz /scripts/galera_init_conf.tgz -C /etc/mysql
    rm -rf /etc/mysql/conf.d/mysqld_safe_syslog.cnf
    rm -rf /etc/mysql/conf.d/tokudb.cnf
    rm -rf /etc/mysql/conf.d/mariadb.cnf
  fi

  if [ ! -f /etc/mysql/conf.d/mariadb.cnf ] ; then
    cp /scripts/mariadb.cnf_template /etc/mysql/conf.d/mariadb.cnf
  fi

  if [ "$MYSQL_BIND_ADDRESS" != "" ] ; then
    sed -i 's/^#*bind-address=.*/bind-address='$MYSQL_BIND_ADDRESS'/' /etc/mysql/conf.d/mariadb.cnf
  fi
  if [ "$MYSQL_BIND_PORT" != "" ] ; then
    sed -i 's/^#*port=.*/port='$MYSQL_BIND_PORT'/' /etc/mysql/conf.d/mariadb.cnf
  fi
  if [ "$SERVER_ID" != "" ] ; then
    sed -i 's/^#*server_id=.*/server_id='$SERVER_ID'/' /etc/mysql/conf.d/mariadb.cnf
  fi
  if [ "$INNODB_BUFFER_POOL_SIZE" != "" ] ; then
    sed -i 's/^innodb_buffer_pool_size *=.*/innodb_buffer_pool_size = '$INNODB_BUFFER_POOL_SIZE'/' /etc/mysql/conf.d/mariadb.cnf
  fi
  
  if [ ! -f /etc/mysql/conf.d/galera.cnf ] ; then
    cp /scripts/galera.cnf_template /etc/mysql/conf.d/galera.cnf
  fi

  if [ "$RUN_CLUSTER" = "true" ] ; then
    sed -i 's/^#wsrep_on=/wsrep_on=/' /etc/mysql/conf.d/galera.cnf 
    sed -i 's/^#wsrep_provider=/wsrep_provider=/' /etc/mysql/conf.d/galera.cnf 
    sed -i 's/^#wsrep_gtid_mode=/wsrep_gtid_mode=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#wsrep_gtid_domain_id=/wsrep_gtid_domain_id=/'  /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#log_slave_updates=/log_slave_updates=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#gtid_strict_mode/gtid_strict_mode/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#binlog_format=/binlog_format=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#default_storage_engine=/default_storage_engine=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#innodb_autoinc_lock_mode=/innodb_autoinc_lock_mode=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#wsrep_sst_method=/wsrep_sst_method=/' /etc/mysql/conf.d/galera.cnf

    sed -i 's/^#*server_id=.*/server_id='$SERVER_ID'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#*gtid-domain-id=.*/gtid-domain-id='$GTID_DOMAIN_ID'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#*wsrep_sst_auth=.*/wsrep_sst_auth='$GALERA_WSREP_SST_AUTH_USER':'$GALERA_WSREP_SST_AUTH_PASS'/' /etc/mysql/conf.d/galera.cnf

    sed -i 's/^#*wsrep_cluster_name=.*/wsrep_cluster_name='$GALERA_WSREP_CLUSTER_NAME'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#*wsrep_cluster_address=.*/wsrep_cluster_address='$GALERA_WSREP_CLUSTER_ADDRESS'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#*wsrep_provider_options=.*/wsrep_provider_options='$GALERA_WSREP_PROVIDER_OPTIONS'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#*wsrep_node_name=.*/wsrep_node_name='$GALERA_WSREP_NODE_NAME'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^#*wsrep_node_address=.*/wsrep_node_address='$GALERA_WSREP_NODE_ADDRESS'/' /etc/mysql/conf.d/galera.cnf

  else
    sed -i 's/^wsrep_on=/#wsrep_on=/' /etc/mysql/conf.d/galera.cnf 
    sed -i 's/^wsrep_provider=/#wsrep_provider=/' /etc/mysql/conf.d/galera.cnf 
    sed -i 's/^wsrep_gtid_mode=/#wsrep_gtid_mode=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_gtid_domain_id=/#wsrep_gtid_domain_id=/'  /etc/mysql/conf.d/galera.cnf
    sed -i 's/^log_slave_updates=/#log_slave_updates=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^gtid_strict_mode/#gtid_strict_mode/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^binlog_format=/#binlog_format=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^default_storage_engine=/#default_storage_engine=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^innodb_autoinc_lock_mode=/#innodb_autoinc_lock_mode=/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_sst_method=/#wsrep_sst_method=/' /etc/mysql/conf.d/galera.cnf

    sed -i 's/^server_id=.*/#server_id='$SERVER_ID'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^gtid-domain-id=.*/#gtid-domain-id='$GTID_DOMAIN_ID'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_sst_auth=.*/#wsrep_sst_auth='$GALERA_WSREP_SST_AUTH_USER':'$GALERA_WSREP_SST_AUTH_PASS'/' /etc/mysql/conf.d/galera.cnf

    sed -i 's/^wsrep_cluster_name=.*/#wsrep_cluster_name='$GALERA_WSREP_CLUSTER_NAME'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_cluster_address=.*/#wsrep_cluster_address='$GALERA_WSREP_CLUSTER_ADDRESS'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_provider_options=.*/#wsrep_provider_options='$GALERA_WSREP_PROVIDER_OPTIONS'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_node_name=.*/#wsrep_node_name='$GALERA_WSREP_NODE_NAME'/' /etc/mysql/conf.d/galera.cnf
    sed -i 's/^wsrep_node_address=.*/#wsrep_node_address='$GALERA_WSREP_NODE_ADDRESS'/' /etc/mysql/conf.d/galera.cnf
  fi
fi

if [ "$DB_BACKUP_USR" -a "$DB_BACKUP_USR_PASS" ]; then
  sed -i 's/^#*MYSQL_USER=.*/MYSQL_USER='$DB_BACKUP_USR'/' /scripts/backup.sh
  sed -i 's/^#*MYSQL_PASSWORD=.*/MYSQL_PASSWORD='$DB_BACKUP_USR_PASS'/' /scripts/backup.sh
fi

chown -R mysql: /var/log/mysql 
chown -R mysql: /var/lib/mysql 

if [ ! -d /var/lib/mysql/mysql ]; then
  sed -i 's/^server_audit_/#server_audit_/' /etc/mysql/conf.d/mariadb.cnf ## this parameters have to be commented because for new db audit plugin will be installed later - se below)

  echo 'new database creation'
  NEW_DB=1
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
  echo 'new database created'

else
  NEW_DB=0
fi

if [ "$NEW_DB" = "1" ] && ( [ -f /etc/mysql/init_new_cluster ] || [ "$INIT_NEW_CLUSTER" = "true" ] || [ "$RUN_CLUSTER" != "true" ] ) ; then

  mysqld --skip-networking  --wsrep-new-cluster --socket=/var/run/mysqld/mysqld.sock &
  pid="$!"

  mysql='mysql --protocol=socket --socket=/var/run/mysqld/mysqld.sock'

  for i in {30..0}; do
 	if echo 'SELECT 1' | ${mysql[@]} &> /dev/null; then
	  break
	fi
	echo 'MySQL init process in progress...'
	sleep 1
  done

  if [ "$i" = 0 ]; then
	echo >&2 'MySQL init process failed.'
	exit 1
  fi

  if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
        mysqladmin password ${MYSQL_ROOT_PASSWORD}
	mysql+=" -p${MYSQL_ROOT_PASSWORD} "
  fi

${mysql[@]} <<-EOSQL
	-- What's done in this file shouldn't be replicated
	--  or products like mysql-fabric won't work
	SET @@SESSION.SQL_LOG_BIN=0;
	DELETE FROM mysql.user where password='' ;
	DROP DATABASE IF EXISTS test ;
        INSTALL PLUGIN server_audit SONAME 'server_audit';
	FLUSH PRIVILEGES ;
EOSQL

  if [ "$GALERA_WSREP_SST_AUTH_USER" -a "$GALERA_WSREP_SST_AUTH_PASS" ]; then
    echo "CREATE USER '$GALERA_WSREP_SST_AUTH_USER'@'localhost' IDENTIFIED BY '$GALERA_WSREP_SST_AUTH_PASS' ;" | ${mysql[@]}
    echo "GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT,PROCESS ON *.* TO '$GALERA_WSREP_SST_AUTH_USER'@'localhost';" | ${mysql[@]}
    echo "GRANT REPLICATION SLAVE ON *.* TO '$GALERA_WSREP_SST_AUTH_USER'@'localhost';" | ${mysql[@]}
    echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
  fi

  if [ "$DB_BACKUP_USR" -a "$DB_BACKUP_USR_PASS" ]; then
    echo "CREATE USER '$DB_BACKUP_USR'@'localhost' IDENTIFIED BY '$DB_BACKUP_USR_PASS';" | ${mysql[@]}
    echo "GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT, PROCESS ON *.* TO '$DB_BACKUP_USR'@'localhost';" | ${mysql[@]}
    echo "GRANT SELECT ON *.* TO '$DB_BACKUP_USR'@'localhost';" | ${mysql[@]}
    echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
  fi

  echo
  for f in /docker-entrypoint-initdb.d/*; do
	case "$f" in
		*.sh)     echo "$0: running $f"; . "$f" ;;
		*.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
		*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
		*)        echo "$0: ignoring $f" ;;
	esac

	echo
  done

  if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 'MySQL init process failed.'
    exit 1
  fi

  sed -i 's/^#server_audit_/server_audit_/' /etc/mysql/conf.d/mariadb.cnf
fi

if [ -f /etc/mysql/init_new_cluster ] ||  [ "$INIT_NEW_CLUSTER" = "true" ] ; then
  echo "New cluster initialization"
  rm -f /etc/mysql/init_new_cluster
  mysqld --wsrep-new-cluster
  echo "New cluster initialized"
else
  echo "Node starting" 
  mysqld_safe
  echo "Node started" 
fi

