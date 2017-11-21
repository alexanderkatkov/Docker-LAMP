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
RUN apt-get -y install php-cli \ 
php-common \
php-mysql \
php-pgsql \
php-sqlite3 \
php-gd php-apcu \
php-mcrypt \
php-gmp \
php-curl \
php-imap \
php-memcached \
php-imagick \
php-intl \
php-xdebug \
php-json \
php-mbstring \
php-zip \
php-xml \
php-pear

RUN apt-get -y install libapache2-mod-php
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