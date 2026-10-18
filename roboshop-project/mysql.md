# 07-MySQL 

Developer has chosen the database MySQL. Hence, we are trying to install it up and configure it.

**Versions of the DB Software you will get context from the developer, Meaning we need to check with developer.**
**Developer has shared the version information as MySQL-8.x**

Install MySQL Server 

**Need root user to install the mysql database server**

```
sudo su -
```

```shell 
dnf install mysql-server -y
```

Start MySQL Service 

```shell 
systemctl enable mysqld
systemctl start mysqld  
```

Next, We need to change the default root password in order to start using the database service. Use password **`RoboShop@1`** or any other as per your choice. 

```shell
mysql_secure_installation --set-root-pass RoboShop@1
```

## Troubleshooting steps for mysql database server

To check the current operation state, health and log activity of database server
**Service Status**
```
systemctl status mysqld
```
To check the applications or services are on which ports
**Active Port**
```
netstat -lntp
```

To check the process status
**Process Status**
```
ps -ef | grep mysqld
```
To Check Domain Resolution
```
nslookup <own domain name> (Ex: nslookup database.vijaydev.me)
```
