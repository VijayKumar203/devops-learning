# Backend
Backend service is responsible for adding the given values to database. Backend service is written in NodeJS, Hence we need to install NodeJS.

**Developer has chosen NodeJs, Check with developer which version of NodeJS is needed. Developer has set a context that it can work with NodeJS >20**

Install NodeJS, By default NodeJS 16 is available, We would like to enable 20 version and install this.

### Create EC2 instance in aws and copy the public IP address login to the server using MobaXterm rename as backend server

**Need root user to install the node packages**

```
sudo su -
```
**You can list modules by using dnf module list**

```
dnf module disable nodejs -y
```

```
dnf module enable nodejs:20 -y
```

```
dnf install nodejs -y
```

Configure the application.

Add application User
```
useradd expense
```

User expense is a function / daemon user to run the application. Apart from that we don't use this user to login to server.

Also, username expense has been picked because it more suits to our project name.

We keep application in one standard location. This is a usual practice that runs in the organization.

Lets setup an app directory.

```
mkdir /app
```

Download the application code to created app directory.

```
curl -o /tmp/backend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
```
```
cd /app
```
```
unzip /tmp/backend.zip
```

Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.

Lets download the dependencies.

```
cd /app
```
```
npm install
```

We need to setup a new service in systemd so systemctl can manage this service

Setup SystemD Expense Backend Service
```
vim /etc/systemd/system/backend.service
```

```
[Unit]
Description = Backend Service

[Service]
User=expense
Environment=DB_HOST="<MYSQL-SERVER-IPADDRESS>"
ExecStart=/bin/node /app/index.js
SyslogIdentifier=backend

[Install]
WantedBy=multi-user.target
```

**NOTE: Ensure you replace < MYSQL-SERVER-IPADDRESS > with database private IP address**

Load the service.

```
systemctl daemon-reload
```

Start the service.
```
systemctl start backend
```
```
systemctl enable backend
```

For this application to work fully functional we need to load schema to the Database.

We need to load the schema. To load schema we need to install mysql client.

To have it installed we can use

```
dnf install mysql -y
```

Load Schema

```
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql
```

**In aws -> security groups edit inbound rules and allow mysql port 3306**

Restart the service.
```
systemctl restart backend
```

## Troubleshooting steps for backend server

To check the current operation state, health and log activity of nodejs server
**Service Status**
```
systemctl status backend
```
To check the applications or services are on which ports
**Active Port**
```
netstat -lntp
```
To check the process status
**Process Status**
```
ps -ef | grep node
```
**Live Logs**
```
journalctl -u backend -f
```

To check whether the backend and database is connected or not

```
telnet <IP> <port> (Ex: telnet 172.29.192.61 3306) database private IP address & database port number
```

To check whether backend is up & running or not

```
curl http://localhost:8080/health
```

To Check Domain Resolution
```
nslookup <own domain name> (Ex: nslookup backend.vijaydev.me)
```
