# Load Balancer

A load balancer is a system that spreads incoming network traffic across multiple backend servers to prevent any single server from getting overloaded, improving reliability, speed, and uptime

### Create EC2 instance in aws and copy the public IP address login to the server using MobaXterm rename as load balancer

**Need root user to install the nginx server**

```
sudo su -
```
Install Nginx
```
dnf install nginx -y 
```
Open the Nginx configuration file
```
vim /etc/nginx/nginx.conf
```
Add the backend/frontend servers in the upstream section
```
http {
    upstream frontend {
        server frontend-1.vijaydev.me;
		server frontend-2.vijaydev.me;
    } }
```
Configure the load balancer to forward requests to the upstream servers
```
    server {
        listen 80;

        location / {
            proxy_pass http://frontend;
        }
    }
```
Save the configuration and exit

Enable nginx
```
systemctl enable nginx
```
Start nginx
```
systemctl start nginx
```

## Troubleshooting steps for Load Balancer

Check the Nginx service status
```
systemctl status nginx
```
To Check Nginx Configuration
```
nginx -t
```
**Check Backend/Frontend Connectivity**

Test whether the load balancer can reach the frontend servers
```
curl http://frontend-1.vijaydev.me
```
Check Nginx Logs

**For errors**
```
tail -f /var/log/nginx/error.log
```
**For access requests**
```
tail -f /var/log/nginx/access.log
```

To Check Domain Resolution
```
nslookup <own domain name> (Ex: nslookup vijaydev.me)
```
