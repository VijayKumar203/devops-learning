
# 03-Frontend

The frontend is the service in RoboShop to serve the web content over Nginx. This will have the webframe for the web application.

This is a static content and to serve static content we need a web server. This server

Developer has chosen Nginx as a web server and thus we will install Nginx Web Server. 


**You can list modules by using**

`dnf module list nginx`

**Need root user to install the frontend server**
```
sudo su -
```

Install Nginx 
```shell
dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y
```

Start & Enable Nginx service 
```shell
systemctl enable nginx 
systemctl start nginx 
```

**Try to access the service once over the browser and ensure you get some default content.**

Remove the default content that web server is serving. 

```shell
rm -rf /usr/share/nginx/html/* 
```

Download the frontend content

```shell
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
```

Extract the frontend content.

```shell
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
```

**Try to access the nginx service once more over the browser and ensure you get roboshop content.**

Create Nginx Reverse Proxy Configuration to reach backend services.

```shell 
vim /etc/nginx/nginx.conf
```

Add the following content 

```nginx configuration title=/etc/nginx/nginx.conf 
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }

        location /images/ {
          expires 5s;
          root   /usr/share/nginx/html;
          try_files $uri /images/placeholder.jpg;
        }
        location /api/catalogue/ { proxy_pass http://localhost:8080/; }
        location /api/user/ { proxy_pass http://localhost:8080/; }
        location /api/cart/ { proxy_pass http://localhost:8080/; }
        location /api/shipping/ { proxy_pass http://localhost:8080/; }
        location /api/payment/ { proxy_pass http://localhost:8080/; }

        location /health {
          stub_status on;
          access_log off;
        }

    }
}
```

**NOTE:**
Ensure you replace the `localhost` with the actual ip address of those component server. Word `localhost` is just used to avoid the failures on the Nginx Server.

Replace localhost with actual backend IP address `http://backend.vijaydev.me:8080/`

Restart Nginx Service to load the changes of the configuration.

```shell 
systemctl restart nginx 
```

## Troubleshooting steps for frontend server

To check the current operation state, health and log activity of nginx server
**Service Status**
```
systemctl status nginx
```
To check the applications or services are on which ports
**Active Port**
```
netstat -lntp
```
To check the process status
**Process Status**
```
ps -ef | grep nginx
```
**Live Logs**
```
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

To check whether the frontend and backend is connected or not

```
telnet <IP> <port> (Ex: telnet 172.31.30.23 8080) backend private IP address & backend port number
```
`ctrl + ]` and then `quit` -> To quit if ctrl + C not works

To check whether frontend is up & running or not

```
curl http://<FRONTEND-PUBLIC-IP>/health
```

To Check Domain Resolution
```
nslookup <own domain name> (Ex: nslookup frontend.vijaydev.me)
```
