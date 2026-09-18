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

## 🌐 Domain & DNS Setup Guide

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

