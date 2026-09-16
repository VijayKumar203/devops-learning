# SDLC - Software Development Lifecycle
- Business Analyst
- Business
- Requirements gathering
- Planning and Designing
- Implementation
- Deployment
- Testing
- Release into public

# Waterfall
- School Management System example
- Stakeholders: Teachers, Students, Parents, Staff (Principal), Investors, Government
- Grand Final - 100 years ago (few formal tests)
- Students: they don't study from day one
- Teachers: they don't teach from day one
- Parents: they worry from day one
- 20-30% pass percentage on first attempts
- Why did 70% fail?
- Problems: 1) only study during exam time 2) teachers won't insist to study early
- Changes: Unit Tests I, II, III, IV; Quarterly; Half-yearly; Pre-Final
- Unit Test I: 20-30% pass; Unit Test II: 30-35% pass (improving)
- Grand Final pass percentage increases after multiple tests
- Slip/Daily tests: 150 practice tests, 95% pass rate (constant checking)
- Gurukul -> Waterfall; Unit tests -> Agile; Daily tests -> DevOps
- Project example: 2 years, 100cr budget
- Requirements: 1 year; Development & Testing: 6 months; Final testing: 6 months
- 100 defects found -> 10 invalid (process improvements needed)

# Agile
- Work is done in sprints
- Example features: Signup/Login, Product management, Order management, Shipping & delivery, Payment, Reviews
- Each sprint delivers some features

# Sprint 1
- Feature: Signup and Login (1 month total)
- 15 days development, 15 days testing & deployment
- Defects: 10 found, 2 invalid (improved process)
- Process improvements from sprint to sprint (Ferrari -> Honda City analogy)

# Sprint 2
- Feature: Product management
- Activities: backlog management, bug fixes
- Final product increment delivered
- Signup Form
- Enter your firstname
- Enter your lastname
- Defects: 2 found, 1 invalid

# DevOps
### DevOps is the process developing, building, deploying and testing on the same day, that can improve co-ordination between all the teams. We use multiple DevOps tools to acheive this. Configuration management, CICD, etc.
- DevOps pipeline: Development -> Build/Release (DEV & SIT deploy) -> Testing
- Ensure code developed by developer is tested and deployed on the same day
- DevOps improves coordination between development, QA, and operations
- Uses multiple tools: configuration management, CI/CD, monitoring, etc.

# What is computer ?
- Any IP-enabled device (server, PC, mobile, etc.) can be a computer
- Communication between computers happens over networks (e.g., the Internet)
- Examples by role: Server (hosts applications), PC (browsing, media, banking), Mobile (calling, apps, social media), Smart devices (TV, AC)
- Main components: CPU (processor), RAM, Storage, Operating System
![IP](/diagrams/ip.png)

# Linux
- Linux is an open-source, free operating system
- Advantages for servers: lightweight (no heavy GUI by default), very fast, minimal resource usage, stable (years of uptime)
- Built-in security (SELinux, iptables)
- Easy upgrades/patching (rolling updates)

# Windows
- Disadvantages for server use: heavy graphics overhead, higher cost, slower performance on same hardware
- Requires frequent reboots for updates (slows down performance)
- Security: requires antivirus installation
- Upgrading to new versions can be difficult and costly

# Linux Server Edition
- Open-source and free to use
- Typically command-line only (no GUI) -> very small footprint (~9MB)
- Can run for years without restart (no forced updates)
- Designed for stability and efficiency on servers
- Easy system upgrades (rolling release model)
- Popular distros: Amazon Linux, CentOS, Ubuntu Server, Red Hat Enterprise Linux

# Create Linux Server
- Launch an AWS EC2 instance (Amazon Linux, Ubuntu, etc.)
- Connect to it via SSH
- Start issuing basic Linux commands to configure the server

# Region and Availability Zone
- AWS regions are geographic locations (e.g., us-east-1 North Virginia, first region, often lower cost)
- Each region has multiple Availability Zones (AZs) for redundancy
- EC2 = Elastic Compute Cloud (virtual server instances)
- AMI = Amazon Machine Image (pre-built OS template for EC2)
- Free tier instance types: t2.micro or t3.micro (e.g., t3.micro has 2 vCPU, 1GB RAM)

# Firewall creation
- In AWS Security Groups, create a new group as a virtual firewall
- Add Inbound rules: allow SSH (port 22) and any project-specific ports
- Add Outbound rules: typically allow all traffic (0.0.0.0/0)
- Example SSH rule: source 0.0.0.0/0 on port 22 (allows SSH from anywhere)
- Generate SSH key on your computer: `ssh-keygen -f <keyname>`
- Import the public key in AWS (EC2 Key Pairs -> Import key pair)
- Connect to EC2: `ssh -i <your-key.pem> ec2-user@<EC2-IP>` (e.g., `ssh -i daws.pem ec2-user@3.38.12.159`)
![User Key](/diagrams/user-key.png)

# Client-Server Architecture
- Servers provide services; clients (browsers/apps) consume services
- Example: facebook.com (server) and your web browser (client)
- Linux server can be accessed by SSH clients (PuTTY, MobaXterm, Terminal, Git Bash, etc.)
- Git Bash (on Windows) provides a mini-Linux shell and git client; starts in the user’s home directory
- You can run basic Linux commands in Git Bash on Windows
![SSH Keys](/diagrams/ssh-keys.png)

# Security Groups (Firewall)
- Security Groups act as virtual firewalls for EC2 instances
- Inbound rules: specify allowed incoming traffic (e.g., SSH on port 22 from 0.0.0.0/0)
- Outbound rules: specify allowed outgoing traffic (default: all to 0.0.0.0/0)
- Use SG rules to restrict which IPs/ports can access your server

# File Paths
- Absolute path example (Windows Git Bash): `/c/devops/daws-86s` (starts from drive root)
- Relative path example: `daws-86s` (relative to current directory)
- Use `pwd` to show the current directory

# Basic Commands
- `uname -a`: show system information (kernel, OS details)
- `pwd`: print current working directory
- `$` indicates normal user prompt; `#` indicates root prompt
- `ipconfig` (Windows) / `ifconfig` or `ip a` (Linux): show network IP addresses
- `sudo su -`: switch to root user (login shell)
- `sudo su`: switch to root user (retain some environment)

# Linux Directory Structure
- `/`: root of filesystem
- `/root`: home directory of root user
- `/home/<username>`: home directory of a normal user (e.g., `/home/ec2-user`)
- Paths starting with `/` are absolute; others are relative

# Basic File Commands
- `touch <file>`: create an empty file
- `cat > <file>`: create/overwrite a file with console input (Ctrl+D to end)
- `cd ..`: move up one directory
- `mv <old> <new>`: rename or move a file (e.g., `mv notes.txt aws.txt`)
- `grep "text" <file>`: search for text in a file

# SSH Client Config
- SSH config file (Windows): `C:\Users\<user>\.ssh\config`
- SSH config file (Linux/Mac): `~/.ssh/config`
- Example config contents:

- This keeps the SSH connection alive with keep-alive packets

# vim Editor
- `vim` (vi Improved) is a terminal text editor
- Open or create file: `vim <filename>`
- Modes: Insert mode (type text) vs Command mode (execute commands)
- Press `i` to insert text, `Esc` to return to command mode
- Save & exit: `:wq`
- Exit without saving: `:q!`
- Show line numbers: `:set nu`; hide them: `:set nonu`
- Search forward: `/word`; backward: `?word`
- Delete line: `dd`; copy (yank) line: `yy`; paste: `p`
- Undo: `u`; redo: `Ctrl+r`
- Remove search highlight: `:nohl`
- Find/replace example: `:%s/old/new/g` replaces all occurrences of "old" with "new"
-  Download and Text Processing
- `wget <url>`: download a file from the internet
- `curl <url>`: fetch content from a URL
- Example: `echo "https://www.facebook.com/" \| cut -d "/" -f4` outputs "www.facebook.com"
- `awk` example: `awk -F ":" '{print $1}' /etc/passwd` prints the first field (username) of each line in /etc/passwd
![Vim](/diagrams/vim.png)

# Logs
- System logs are in `/var/log/`
- Example: `cd /var/log/` then `tail -f syslog` to follow new log entries in real time

# head and tail
- `head <file>`: show first 10 lines of a file
- `tail <file>`: show last 10 lines of a file
- `head -n <N> <file>`: show first N lines
- Example: `head -n 60 aws.txt \| tail -n 10` shows lines 51-60 of aws.txt

# User Management
- `useradd <username>`: create a new user
- `groupadd <groupname>`: create a new group
- `/etc/passwd`: user account information
- `/etc/group`: group information
- `/etc/shadow`: encrypted password info (root view only)
- `usermod -g <group> <user>`: change user's primary group
- `usermod -aG <group> <user>`: add user to a supplementary group
- `id <user>`: display user's UID, GID, and group memberships
- `passwd <user>`: set/change a user's password
- `userdel <user>`: delete a user
- `gpasswd -d <user> <group>`: remove user from a group
- `groupdel <group>`: delete a group

# SSH Daemon
- SSH server config file: `/etc/ssh/sshd_config`
- `sshd -t`: test SSH configuration syntax
- `systemctl restart sshd`: restart SSH service to apply changes

# File Permissions
- Permissions values: Read = 4, Write = 2, Execute = 1
- Example format: `-rw-r--r--` (owner rw-, group r--, others r--)
- `chmod ugo+rwx <file>`: add all permissions to user, group, others
- `chmod ugo-rwx <file>`: remove all permissions
- `chmod 777 <file>`: full permissions (rwx) for all

# File Ownership
- `chown <user>:<group> <file>`: change owner and group (requires root)
- `chown -R <user>:<group> <dir>`: recursive change for a directory

# SSH Login Keys
- Public keys are stored in `/home/<user>/.ssh/authorized_keys`
- Login with private key: `ssh -i <private_key.pem> <user>@<IP>`
- Example: `ssh -i daws.pem ec2-user@3.38.12.159`
- Setup steps (user 'vijaykumar'):
1. `useradd vijaykumar`
2. Create `/home/vijaykumar/.ssh` and `chmod 700` it
3. `chown vijaykumar:vijaykumar /home/vijaykumar/.ssh`
4. `touch /home/vijaykumar/.ssh/authorized_keys` and `chmod 600`
5. Add vijaykumar's public key into `authorized_keys`
- Then connect: `ssh -i vijaykumar.pem vijaykumar@3.88.2.139`

# Sudo Access
- `/etc/sudoers`: file with sudo permissions (edit safely with `visudo`)
- Add user to wheel group: `usermod -aG wheel vijaykumar`
- Configure sudoers (or /etc/sudoers.d/) to allow wheel group to run sudo (optionally without password)

# Ports
- TCP/UDP port range: 0–65535
- Common ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), etc.

# Package Management
- RHEL/CentOS/Amazon Linux: use `dnf` (formerly `yum`)
- Ubuntu/Debian: use `apt-get`
- Install: `dnf install <package>` (or `apt-get install <package>`)
- Remove: `dnf remove <package>`
- Update: `dnf update <package>`
- List installed: `dnf list installed`
- List available: `dnf list available`
- Repo files are under `/etc/yum.repos.d/`

# Service Management
- After installing a service (e.g., nginx):
- `systemctl start <service>`: start it
- `systemctl status <service>`: check status
- `systemctl stop <service>`: stop it
- `systemctl restart <service>`: restart it
- `systemctl enable <service>`: auto-start on boot
- `systemctl disable <service>`: disable auto-start
- Example: Nginx web server accessible at `http://<EC2-IP>:80`

# DNS
- DNS (Domain Name System) translates domain names to IP addresses
- Example: Route 53 A record maps `yourdomain.me` to an Elastic IP
![DNS](/diagrams/dns.png)

# Process Management
- `ps -ef`: list all running processes
- `ps -ef \| grep <name>`: find a specific process
- Foreground process: runs in current shell (e.g., `sleep 10`)
- Background process: add `&` (e.g., `sleep 10 &`)
- `top`: interactive monitor (shows CPU/RAM usage)
- Kill process: `kill <PID>` (graceful shutdown), `kill -9 <PID>` (force)

# Network Monitoring
- `netstat -ltnp` or `ss -ltnp`: show listening TCP ports and associated PIDs
- AWS handles physical networking; you configure security groups and firewalls on your EC2

# Linux File Links
- Soft link (symbolic): a shortcut to another file (uses filename)
- Hard link: another directory entry to the same inode
- Inode: metadata record (permissions, owner, data block pointers) for a file

# Proxy
- Forward Proxy: intermediate for clients (Client -> Forward Proxy -> Internet)
- Reverse Proxy: intermediate for servers (Client -> Reverse Proxy -> Servers)
- Nginx can act as a reverse proxy in front of backend servers

# 3-Tier Architecture
- 1-Tier (monolithic): all components on one server (like a roadside hotel doing everything)
- 2-Tier: splits roles (like a small hotel: owner issues token, cook cooks)
- 3-Tier: separated roles (like a restaurant: captain, waiter, chef)
- Software example: User (UI) -> Web Server (Frontend) -> Application Server (Backend) -> Database Server
![3-Tier Architecture 2](/diagrams/3tier.png)

# Desktop vs Web-Based Applications

## Desktop Applications
Desktop applications are installed and run directly on a local computer. They generally consume more system resources and require installation, repair, and upgrades. They may occasionally hang, and data is stored locally, so there may be no recovery if the system crashes. They also cannot be accessed from everywhere and may have limited data security.

## Web-Based Applications
Web-based applications run through a web browser and can be accessed from anywhere. They provide high security and are accessible across different locations and devices.

# Load Balancing
Load Balancing distributes incoming traffic across multiple servers to improve application performance, availability, and scalability.
**NGINX** acts as a web server/reverse proxy and distributes requests to backend application servers.
The web layer uses **HTML, CSS, and JavaScript**, while the backend can use **Java, .NET, Python, C++, Golang, or Node.js**.
The application/backend layer handles business logic and **CRUD (Create, Read, Update, Delete) operations**.

![3-Tier Architecture 1](/diagrams/3-tier.png)

# Database Tier
- Databases store data (examples: MySQL, Oracle, PostgreSQL, MongoDB, Cassandra, Redis)
- Messaging/Queue examples: ActiveMQ, Websphere MQ
- The data storage layer of an application
![Database](/diagrams/database.png)

# CRUD
- CRUD = Create, Read, Update, Delete (basic operations in database)

# AMI (Amazon Machine Image)
- AMI: a template for launching EC2 instances (contains the OS and initial configuration)
- Use an AMI ID to create new EC2 instances with pre-installed software

# Operating Systems
- Kernel = core part of OS managing hardware
- OS = Kernel + user utilities/applications
- Linux distributions: CentOS, Fedora, Ubuntu, Android, Oracle Linux, SUSE, Red Hat, etc.
- Red Hat family: Fedora (community, fast updates) -> Red Hat (enterprise support) -> CentOS/AlmaLinux (free RHEL rebuilds)
- Amazon Linux = RHEL-based (fast updates on AWS)
- Login to EC2 (Amazon Linux): `ssh ec2-user@<IP>` (for RHEL-based AMIs)

