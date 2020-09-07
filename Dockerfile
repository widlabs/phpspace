FROM centos:8

LABEL maintainer="wid <wid@widlabs.com>"

# init installation
RUN yum -y update
RUN yum install -y wget yum-utils dnf-utils


# install nginx
COPY etc/yum.repos.d/nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum-config-manager --enable nginx-stable
RUN yum install -y nginx

# install php with php-fpm
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf -y module install php:remi-7.4
RUN yum install -y php-cli php-fpm php-xml php-gd php-gmp php-pdo php-json php-intl php-pear php-tidy php-devel php-common php-bcmath php-xmlrpc php-mysqlnd php-opcache php-mbstring 

COPY etc/php-fpm.conf /etc/php-fpm.conf
COPY etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf

COPY docker-entrypoint.sh /
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
