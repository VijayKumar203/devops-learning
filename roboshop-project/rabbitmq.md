# 09-RabbitMQ 

RabbitMQ is a messaging Queue which is used by some components of the applications.

**Versions of the DB Software you will get context from the developer, Meaning we need to check with developer.**
**Developer has shared the version information as RabbitMQ-3.x**

Setup the RabbitMQ repo file. You can create file using

```
vim /etc/yum.repos.d/rabbitmq.repo
```

``` shell title=/etc/yum.repos.d/rabbitmq.repo
[modern-erlang]
name=modern-erlang-el9
baseurl=https://yum1.novemberain.com/erlang/el/9/$basearch
        https://yum2.novemberain.com/erlang/el/9/$basearch
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/rpm/el/9/$basearch
enabled=1
gpgcheck=0

[modern-erlang-noarch]
name=modern-erlang-el9-noarch
baseurl=https://yum1.novemberain.com/erlang/el/9/noarch
        https://yum2.novemberain.com/erlang/el/9/noarch
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/rpm/el/9/noarch
enabled=1
gpgcheck=0

[modern-erlang-source]
name=modern-erlang-el9-source
baseurl=https://yum1.novemberain.com/erlang/el/9/SRPMS
        https://yum2.novemberain.com/erlang/el/9/SRPMS
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/rpm/el/9/SRPMS
enabled=1
gpgcheck=0

[rabbitmq-el9]
name=rabbitmq-el9
baseurl=https://yum2.novemberain.com/rabbitmq/el/9/$basearch
        https://yum1.novemberain.com/rabbitmq/el/9/$basearch
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/rpm/el/9/$basearch
enabled=1
gpgcheck=0

[rabbitmq-el9-noarch]
name=rabbitmq-el9-noarch
baseurl=https://yum2.novemberain.com/rabbitmq/el/9/noarch
        https://yum1.novemberain.com/rabbitmq/el/9/noarch
        https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/rpm/el/9/noarch
enabled=1
gpgcheck=0
```

**Need root user to install the rabbitmq database server**
```
sudo su -
```

Install RabbitMQ 

```shell 
dnf install rabbitmq-server -y
```

Start RabbitMQ Service 

```shell 
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
```

RabbitMQ comes with a default username / password as `guest/guest`. But this user cannot be used to connect. Hence, we need to create one user for the application.

```shell 
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
```

## Troubleshooting steps for rabbitmq database server

To check the current operation state, health and log activity of database server
**Service Status**
```
systemctl status rabbitmq-server
```
To check the applications or services are on which ports
**Active Port**
```
netstat -lntp
```

To check the process status
**Process Status**
```
ps -ef | grep rabbitmq-server
```
To Check Domain Resolution
```
nslookup <own domain name> (Ex: nslookup database.vijaydev.me)
```
