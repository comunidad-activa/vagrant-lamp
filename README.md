Vagrant LAMP
============

My default LAMP development stack configuration for Vagrant.

Requirements
------------
* VirtualBox <http://www.virtualbox.com>
* Vagrant <http://www.vagrantup.com>
* Git <http://git-scm.com/>

Use
-----
### Begin
	$ git clone this repo
	$ cd vagrant-lamp
	$ vagrant up


### Connection

#### Apache 2
Apache 2 is available on <http://localhost:8080>

#### phpMyAdmin
phpMyAdmin is available on <http://localhost:8080/phpmyadmin/>
```js
	login: vagrant
	password: vagrant
```

#### MySQL
MySQL server is available on `33060` port , and on `3306` in VM.
```js
	login: vagrant
	password: vagrant
```

Technical description
-----------------
* Ubuntu 20.04 64-bit
* phpMyAdmin 4.0
* Apache 2.4.7
* PHP 7.4
* MariaDB
* NPM lts
* NodeJS lts
* Composer
* Yarn
* PM2

The root folder of the site is located in the project folder and is called the `public`. You can create your files in it.

#### Vagrant
You can connect to the virtual machine Vagrant command (password vagrant)
```js
	$ vagrant ssh
```

#### MariaDB
mysql not accessible via ssh connection (vagrant ssh)
