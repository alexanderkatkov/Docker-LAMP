# Docker LAMP

## Includes

* Custom server Dockerfile based on latest Ubuntu LTS:
    * Apache2
    * PHP 7.1 with XDebug
    * mhsendmail for MailHog integration
* MySQL 5.7
* PhpMyAdmin
* MailHog

## Settings

Additional Apache2 modules can be added via `php-apache.Dockerfile` in `/build` folder.

PHP & Host setting can be set in `/config` folder

* PHP settings must be set in `custom-php.ini` file.
* Host settings must be set in `000-default.conf` file.

## Additional Info

### xDebug settings
* IDE Key: XDEBUG
* Port: 9000

#### launch.json for VS Code
```json
{
	"name": "XDEBUG",
	"type": "php",
	"request": "launch",
	"port": 9000,
	"localSourceRoot": "${workspaceRoot}/app/",
	"serverSourceRoot": "/var/www/"
}
```

### MailHog Access
To see emails catched by MailHog go to URL: **192.168.99.100:8025**