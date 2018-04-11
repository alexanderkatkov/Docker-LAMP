FROM ubuntu

LABEL maintainer="alexander.katkov@outlook.com"
LABEL maintainer="Alex Katkov"

# Prepare system
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove -y 

# Install base applications
RUN apt-get install -y \
    git \
    curl \
    dialog \
    build-essential \
    zip \
    unzip \
    sendmail \
    supervisor 

RUN apt-get install -y language-pack-en

# Allow adding custom repository
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common

# Provision Apache
RUN LANG=en_US.UTF-8 add-apt-repository ppa:ondrej/apache2
RUN apt-get update
RUN apt-get install -y apache2
RUN chown -R www-data:www-data /var/www
RUN chmod -R 775 /var/www
# Enabling necessary Apache modules 
RUN a2enmod headers
RUN a2enmod rewrite

RUN service apache2 restart

# Provision PHP
RUN LANG=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get -y install php7.1-cli \ 
php7.1-common \
php7.1-mysql \
php7.1-pgsql \
php7.1-sqlite3 \
php7.1-gd \
php7.1-apcu \
php7.1-mcrypt \
php7.1-gmp \
php7.1-curl \
php7.1-imap \
php7.1-memcached \
php7.1-imagick \
php7.1-intl \
php7.1-xdebug \
php7.1-json \
php7.1-mbstring \
php7.1-zip \
php7.1-xml \
php-pear

RUN apt-get -y install libapache2-mod-php7.1
RUN service apache2 restart

# Install mesendmail & it's depencies for MailHog integration
RUN apt-get -y install golang-go
RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x /usr/local/bin/mhsendmail

RUN service apache2 restart

# Expose ports
EXPOSE 80 443

# Start Apache2 service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/apache2ctl"]