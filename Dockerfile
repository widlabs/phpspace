FROM centos:8

LABEL maintainer="wid <wid@widlabs.com>"

# init installation
RUN yum -y update && yum install -y gcc make yum-utils

# install nginx
COPY etc/yum.repos.d/nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum-config-manager --enable nginx-stable && yum install -y nginx

# install php with php-fpm
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
    && yum -y module install php:remi-7.4 \
    && yum install -y php-cli php-fpm php-xml php-gd php-gmp php-pdo php-json php-intl php-pear php-tidy php-devel php-common php-bcmath php-xmlrpc php-mysqlnd php-opcache php-mbstring

# install php-redis extensions
RUN pecl channel-update pecl.php.net \
    && echo -e "\n\n" | pecl install redis \
    && echo "extension=redis.so" > /etc/php.d/30-redis.ini

COPY docker-entrypoint.sh /
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

# nginx php-fpm integration
EXPOSE 80
STOPSIGNAL SIGTERM
COPY etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
