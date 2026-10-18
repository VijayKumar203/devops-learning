# 11-Dispatch 

Dispatch is the service which dispatches the product after purchase. It is written in GoLang, So wanted to install GoLang.

Developer has chosen GoLang, Check with developer which version of GoLang is needed.

**Need root user to install the Dispatch server**
```
sudo su -
```

Install GoLang

```shell 
dnf install golang -y
```

Configure the application.

Our application developed by the developer of our org and it is not having any RPM software just like other softwares. So we need to configure every step manually

We already discussed in Linux basics section that applications should run as nonroot user.

Add application User

```shell 
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
```

User **roboshop** is a function / daemon user to run the application. Apart from that we dont use this user to login to server.

Also, username **roboshop** has been picked because it more suits to our project name.

We keep application in one standard location. This is a usual practice that runs in the organization.

Lets setup an app directory.

```shell
mkdir /app 
```

Download the application code to created app directory.

```shell
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip 
cd /app 
unzip /tmp/dispatch.zip
```

Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.

Lets download the dependencies & build the software.

```shell 
cd /app 
go mod init dispatch
go get 
go build
```

We need to setup a new service in **systemd** so `systemctl` can manage this service

We already discussed in linux basics that advantages of systemctl managing services, Hence we are taking that approach. Which is also a standard way in the OS.

Setup SystemD Payment Service

```unit file (systemd) title=/etc/systemd/system/dispatch.service
[Unit]
Description = Dispatch Service
[Service]
User=roboshop
// highlight-start
Environment=AMQP_HOST=RABBITMQ-IP
// highlight-end
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target
```

Hint! You can create file by using **`vim /etc/systemd/system/dispatch.service`**

Load the service.

```shell 
systemctl daemon-reload
```

This above command is because we added a new service, We are telling systemd to reload so it will detect new service.

Start the service.

```shell 
systemctl enable dispatch 
systemctl start dispatch
```

## Troubleshooting steps for dispatch server

To check the current operation state, health and log activity of nodejs server
**Service Status**
```
systemctl status dispatch
```
To check the applications or services are on which ports
**Active Port**
```
netstat -lntp
```
To check the process status
**Process Status**
```
ps -ef | grep golang
```

To check whether the backend and database is connected or not

```
telnet <IP> <port> (Ex: telnet backend.vijaydev.me 27017) database private IP address & database port number
```

To check whether backend is up & running or not

```
curl http://localhost:8080/health
```

```
curl -v http://localhost:8080/health
```

To Check Domain Resolution
```
nslookup <own domain name> (Ex: nslookup backend.vijaydev.me)
```
