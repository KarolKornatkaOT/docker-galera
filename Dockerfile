FROM oberthur/docker-ubuntu:16.04
MAINTAINER Krzysztof Olecki <k.olecki@oberthur.com>

ENV  MYSQL_VERSION=10.1.23 
ENV  MYSQL_REPO_VERSION=10.1

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update \
 && apt-get upgrade \
 && apt-get install software-properties-common \
 && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
 && add-apt-repository "deb [arch=amd64,i386,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/$MYSQL_REPO_VERSION/ubuntu xenial main" \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8507EFA5 \ 
 && add-apt-repository 'deb http://repo.percona.com/apt xenial main'
  
RUN mkdir /scripts

COPY files/docker-entrypoint.sh /scripts/docker-entrypoint.sh
COPY files/galera.cnf_template /scripts/galera.cnf_template
COPY files/mariadb.cnf_template /scripts/mariadb.cnf_template
COPY files/backup.sh /scripts/

RUN apt-get update \
 && apt-get upgrade 
RUN apt-get install -y mariadb-server=$MYSQL_VERSION* percona-xtrabackup-24

RUN tar cfz /scripts/galera_init_conf.tgz -C /etc/mysql .

RUN rm /etc/mysql/conf.d/mariadb.cnf /etc/mysql/conf.d/tokudb.cnf \
 && chown -R mysql: /var/lib/mysql \
 && chown -R mysql: /var/log/mysql \
 && chown -R root: /scripts \
 && chmod +x /scripts/docker-entrypoint.sh \
 && chmod +x /scripts/backup.sh 


ENTRYPOINT ["sh","/scripts/docker-entrypoint.sh"]

