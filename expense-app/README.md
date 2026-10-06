# 💰 Expense Tracker Web Application

A 3-tier enterprise web application deployed on AWS EC2 instances, consisting of an Nginx-powered web frontend, a Node.js REST API backend, and a MySQL relational database.

---

## 🏗️ Architecture Overview

The application follows a standard decoupled 3-tier architecture:

```text
[ Client Browser ]
        │
        ▼ (HTTP :80)
┌────────────────────────────────────────────────────────┐
│  1. Frontend Server (Nginx)                            │
│  - Serves static UI files                              │
│  - Reverse-proxies /api/ requests to Backend (:8080)   │
└───────────────────────┬────────────────────────────────┘
                        │
                        ▼ (TCP :8080)
┌───────────────────────┴────────────────────────────────┐
│  2. Backend Server (Node.js v20 / systemd)             │
│  - Processes business logic and REST endpoints         │
│  - Connects to MySQL using DB_HOST environment variable│
└───────────────────────────────────┬────────────────────┘
                                    │
                                    ▼ (MySQL :3306)
┌───────────────────────────────────┴────────────────────┐
│  3. Database Server (MySQL 8.0)                        │
│  - Stores transactions and expense records             │
└────────────────────────────────────────────────────────┘
```
![User Key](/diagrams/3-tier-expense.png)

---

## 🔐 AWS Infrastructure & Security Groups

Create three EC2 instances (RHEL/CentOS/Amazon Linux using `dnf`) and configure your Inbound Security Group rules as follows:

| Server | Component | Required Inbound Port | Allowed Source | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Frontend** | Nginx | `80` (HTTP) | `0.0.0.0/0` (Anywhere) | Public web traffic |
| **Backend** | Node.js | `8080` (Custom TCP) | Frontend Private IP | API requests from Nginx |
| **Database** | MySQL | `3306` (MySQL) | Backend Private IP | Database queries from Backend |
| **All Servers** | SSH | `22` (SSH) | Your IP | Remote server management |

> ⚠️ **Best Practice:** Never expose ports `8080` or `3306` to the public internet (`0.0.0.0/0`). Restrict them to the private IPs of the upstream instances.

---

## 🚀 Deployment Workflow

Deploy the services in this exact order to prevent dependency and connection failures:

### 1. Database Tier (`database.md`)
* Install and enable **MySQL 8.0**.
* Secure root credentials (`ExpenseApp@1`).
* Ensure MySQL is actively listening on port `3306`.
* 📖 **Full Guide:** [database.md](./database.md)

### 2. Backend Tier (`backend.md`)
* Install **NodeJS 20** and set up the dedicated `expense` service user.
* Configure `DB_HOST` in `/etc/systemd/system/backend.service` with the **Database Private IP**.
* Install the MySQL client on the backend node and inject `/app/schema/backend.sql` into MySQL.
* Start the `backend` systemd service on port `8080`.
* 📖 **Full Guide:** [backend.md](./backend.md)

### 3. Frontend Tier (`frontend.md`)
* Install **Nginx** and deploy the static frontend build to `/usr/share/nginx/html`.
* Configure the reverse proxy at `/etc/nginx/default.d/expense.conf` pointing `/api/` to `http://<BACKEND-PRIVATE-IP>:8080/`.
* Restart Nginx and verify browser access.
* 📖 **Full Guide:** [frontend.md](./frontend.md)

---

## 🧪 End-to-End Verification

Once all three layers are deployed, run these checks to confirm total system connectivity:

1. **Backend to Database:**
   ```bash
   telnet <DATABASE-PRIVATE-IP> 3306
   ```
2. **Frontend to Backend:**
    ```
    telnet <BACKEND-PRIVATE-IP> 8080
    ``` 

![User Key](/diagrams/3-tier-architecture.png)

# 🌐 Domain & DNS Setup Guide

Follow these steps to connect your custom domain (purchased from any registrar like GoDaddy, Namecheap, etc.) to AWS Route 53 (Hosted Zones):

### Step 1: Update Name Servers at Your Domain Registrar
1. Log in to the platform where you purchased your domain.
2. Navigate to your domain management settings and locate the **Name Servers** section.
3. Keep this tab open; you will need to paste AWS name servers here shortly.

### Step 2: Create a Hosted Zone in AWS Route 53
1. Open the **AWS Management Console** and navigate to **Route 53**.
2. Click on **Hosted zones** in the left sidebar and select **Create hosted zone**.
3. Enter your exact domain name (e.g., `yourdomain.com`) in the **Domain name** field.
4. Leave the type as **Public hosted zone** and click **Create hosted zone**.

### Step 3: Link AWS to Your Domain Registrar
1. Once the hosted zone is created, look for the **NS (Name Server)** record type in the record list.
2. Copy the four AWS name server addresses provided (they usually end in `.awsdns-XX.com`, `.net`, etc.).
3. Go back to your domain purchase platform, replace the default name servers with the **four AWS name servers** you just copied, and save your changes.

> **Note:** DNS propagation can take anywhere from a few minutes up to 24 hours to take full effect globally.

# AWS Route 53 DNS Record Setup

1. Open the **AWS Console** and go to **Route 53**.
2. Select **Hosted zones** from the left menu.
3. Click on your **domain name**.
4. Click **Create record**.
5. For all records, use **Record type: A** and set the required **TTL**.

## Database Server

1. In **Record name**, enter the database name, for example:
   `mysql`
7. In **Value**, enter the **private IP address** of the database server.
13. Keep **Record type: A** and the same **TTL**.
8. Click **Create records**.
9. Example: `mysql.example.com → 10.0.2.10`

## Backend Server

1.  Click **Create record** again. In **Record name**, enter the backend name:
    `backend`
12. In **Value**, enter the **private IP address** of the backend server.
13. Keep **Record type: A** and the same **TTL**.
14. Click **Create records**.
15. Example: `backend.example.com → 10.0.1.20`

## Frontend Server

1.  Click **Create record** again. For the **root domain**, leave the **Record name** field empty.
18. In **Value**, enter the **public IP address** of the frontend server.
19. Keep **Record type: A** and the same **TTL**.
20. Click **Create records**.
21. Example: `example.com → 203.0.113.10`

## Test the DNS Records

After creating the records, test them from an environment that should be able to resolve them.
### Test Database, Backend & Frontend
```bash
nslookup mysql.example.com
nslookup backend.example.com
nslookup example.com
```
or
```bash
dig mysql.example.com
dig backend.example.com
dig example.com
```
The result should return the configured private IP when queried from the appropriate VPC/private DNS environment.


### Final Configuration

1. **Database:** Name = `mysql` | IP = **Private IP**
23. **Backend:** Name = `backend` | IP = **Private IP**
24. **Frontend:** Name = **Blank** | IP = **Public IP**
25. Use the database and backend private IPs for internal communication.
26. Use the frontend public IP so the domain can be accessed from the internet.
27. Replace all example IP addresses with your actual server IP addresses.

# Nginx, DNS, HTTP & Linux Notes

## Nginx

**Nginx** is a popular web server that can also work as a **reverse proxy** and **load balancer**.

### Important Nginx Paths

```text
/usr/share/nginx/html
    -> Default directory for frontend/static website files

/etc/nginx
    -> Main Nginx configuration directory

/etc/nginx/default.d/expense.conf
    -> Additional Nginx configuration file
```

### Basic Commands

```bash
systemctl start nginx
```
-> Starts the Nginx service.

```bash
systemctl enable nginx
```
-> Starts Nginx automatically when the server boots.

```bash
vim /etc/nginx/default.d/expense.conf
```
-> Opens the additional Nginx configuration file for editing.

```bash
nginx -t
```
-> Checks whether the Nginx configuration has errors.

---

# DNS

**DNS (Domain Name System)** converts domain names into IP addresses.

```text
Human -> example.com
Computer -> IP address
```

**DNS Resolver** -> Software that finds the IP address of a domain by querying DNS servers.

**ICANN** -> Non-profit organization responsible for coordinating domain names and IP addresses.

**TLD (Top-Level Domain)** -> Last part of a domain name, such as `.com`, `.org`, `.in`.

---

## DNS Record Types

| Record | Purpose |
|---|---|
| `A` | Maps a domain to an IPv4 address |
| `AAAA` | Maps a domain to an IPv6 address |
| `CNAME` | Maps a domain to another domain name |
| `MX` | Specifies mail servers |
| `TXT` | Used for verification and other text-based information |
| `NS` | Specifies the authoritative nameservers for the domain |
| `SOA` | Contains important information about the DNS zone, such as the primary nameserver and zone details |

### TTL

**TTL (Time To Live)** -> Controls how long a DNS record is cached before it is queried again.

```text
High TTL -> Less DNS queries, useful for stable websites

Low TTL  -> Faster DNS changes, useful during migrations
```

---

# Nginx Uses

Nginx can be used as:

```text
1. Web Server
   -> Serves frontend/web files

2. Reverse Proxy
   -> Receives client requests and forwards them to backend servers

3. Load Balancer
   -> Distributes requests across multiple servers
```

---

# Forward Proxy vs Reverse Proxy

## Forward Proxy

**Forward proxy** works on behalf of the **client**.

```text
Client -> Forward Proxy -> Internet
```

Uses:

- Hides client identity
- Access restrictions
- Traffic filtering
- Company internet control

Example:

```text
Laptop -> Company Proxy -> Internet
```

The company proxy can block websites such as Facebook or Instagram.

## Reverse Proxy

**Reverse proxy** works on behalf of the **server**.

```text
Client -> Reverse Proxy -> Backend Server
```

Uses:

- Hides backend server details
- SSL/TLS termination
- Caching
- Load balancing

---

# HTTP Methods & Status Codes

**HTTP methods** define what action should be performed on a resource.

### Common Methods

```text
GET    -> Read data
POST   -> Create/send data
PUT    -> Update data
PATCH  -> Partially update data
DELETE -> Delete data
TRACE  -> Diagnostic request
CONNECT -> Establishes a tunnel
```

Example:

```text
GET /api/transactions
    -> Read transactions

POST /api/transactions
    -> Create a transaction
```

Example request data:

```json
{
  "amount": 100,
  "desc": "snacks"
}
```

---

## HTTP Status Codes

```text
1XX -> Informational
2xx -> Request successful
3xx -> Redirection
4xx -> Client-side error
5xx -> Server-side error
```

### Common Codes

```text
100 -> Continue
101 -> Switching Protocols

200 -> OK / Request successful
201 -> Resource created

300 -> Multiple Choices
301 -> Moved Permanently
302 -> Found

400 -> Bad Request
401 -> Unauthorized
402 -> Payment Required
403 -> Forbidden
404 -> Not Found

500 -> Internal Server Error
501 -> Not Implemented
502 -> Bad Gateway
503 -> Service Unavailable
504 -> Gateway Timeout
```

---

# Linux Inode, Symlink & Hard Link

**Inode** -> A Linux filesystem structure that stores information about a file, such as permissions, owner, size, and disk location.

## Symlink

**Symlink (Soft Link)** -> A shortcut that points to another file or directory.

```text
Original file -> Symlink
```

- Symlink has a different inode.
- Deleting the original file breaks the symlink.

### Create Symlink

```bash
ln -s /path/to/original /path/to/link
```

-> Creates a symbolic link to the original file/directory.

---

## Hard Link

**Hard link** -> Another name for the same file data.

- Hard link and original file use the **same inode**.
- Deleting one hard link does not remove the data while another hard link still exists.

### Create Hard Link

```bash
ln /path/to/original /path/to/link
```

-> Creates a hard link to the same file.