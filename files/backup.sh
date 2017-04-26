#!/bin/bash

TIMESTAMP=$(date +%Y-%m-%d_%H%M)
BACK="/var/backup"
BACKUP_DIR="$BACK/$TIMESTAMP"
MYSQL_ERR="/var/log/mysql"
MYSQL_USER="bkp"
MYSQL_PASSWORD="bkp_pass"

usage() {
        echo "usage: $(basename $0) [option]"
        echo "option=full: do a full backup"
        echo "option=incremental: do a incremental backup"
        echo "option=innobackupex: do a full innobackupex backup (for master-slave clusters replication)"
        echo "option=help: show this help"
}

full_backup() {
        mkdir -p "$BACKUP_DIR/"
        date
        if [ ! -d $BACKUP_DIR ]
        then
                echo "ERROR: the folder $BACKUP_DIR does not exists"
                exit 1
        fi
        echo "doing full backup..."

        for db in $(/usr/bin/mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -B -s -e 'show databases' | grep -Ev 'Database|information_schema|performance_schema')
            do
                /usr/bin/mysqldump --user=$MYSQL_USER -p$MYSQL_PASSWORD "$db" | gzip > "$BACKUP_DIR/$db-$TIMESTAMP.sql.gz"
        echo $TIMESTAMP $? >> "$MYSQL_ERR/$db.err"
            done
        echo "Backup done!"

        # delete files older than 7 days.
        /usr/bin/find $BACK -maxdepth 1 -type d -mtime +7 -exec /bin/rm -r {} \;
}

incremental_backup() {

echo "To be done..."

}

innobackupex_full() {
    BACKUP_DIR="$BACKUP_DIR"_innobackupex
    mkdir -p "$BACKUP_DIR/"
    date
    if [ ! -d $BACKUP_DIR ]
    then
        echo "ERROR: the folder $BACKUP_DIR does not exists"
        exit 1
    fi
    echo "doing innobackupex backup..."
    innobackupex --user=$MYSQL_USER --password=$MYSQL_PASSWORD --no-timestamp $BACKUP_DIR
    innobackupex --user=$MYSQL_USER --password=$MYSQL_PASSWORD --apply-log $BACKUP_DIR

    tar cfz "$BACK/$TIMESTAMP"_innobackupex.tgz $BACKUP_DIR
    echo "Backup done!"
}

if [ $# -eq 0 ]
then
usage
exit 1
fi

    case $1 in
        "full")
            full_backup
            ;;
        "incremental")
        incremental_backup
            ;;
        "innobackupex")
        innobackupex_full
            ;;
        "help")
            usage
            break
            ;;
        *) echo "invalid option";;
    esac


