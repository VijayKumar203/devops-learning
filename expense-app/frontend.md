# Frontend

The frontend is the service in Expense to serve the web content over Nginx. This will have the web frame for the web application.

This is a static content and to serve static content we need a web server. This server

Developer has chosen Nginx as a web server and thus we will install Nginx Web Server.

### Create EC2 instance in aws and copy the public IP address login to the server using MobaXterm rename as frontend server

Install Nginx
```
dnf install nginx -y 
```
Enable nginx
```
systemctl enable nginx
```
Start nginx
```
systemctl start nginx
```

**Try to access the service once over the browser and ensure you get some default content**

**Check frontend public ip address in browser if is not running then in the security edit inbound rules allow http port 80**

Remove the default content that web server is serving.
```
rm -rf /usr/share/nginx/html/*
```

Download the frontend content
```
curl -o /tmp/frontend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
```
Extract the frontend content.
```
cd /usr/share/nginx/html
```
```
unzip /tmp/frontend.zip
```

**Try to access the nginx service once more over the browser and ensure you get expense content.**

Create Nginx Reverse Proxy Configuration.
```
vim /etc/nginx/default.d/expense.conf
```
Add the following content
```
proxy_http_version 1.1;

location /api/ { proxy_pass http://localhost:8080/; }

location /health {
  stub_status on;
  access_log off;
}
```

**Ensure you replace the localhost with the actual ip address of backend component server. Word localhost is just used to avoid the failures on the Nginx Server.**

**Replace the localhost with backend private ip address In the security group edit inbound rules allow custom tcp port 8080**

Restart Nginx Service to load the changes of the configuration.

```
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
tail -f /var/log/nginx/error.log
```

To check whether the frontend and backend is connected or not

```
telnet <IP> <port> (Ex: telnet 172.31.30.23 8080) backend private IP address & backend port number
```

To check whether frontend is up & running or not

```
curl http://<FRONTEND-PUBLIC-IP>/health
```
