# RoboShop E-Commerce Project

RoboShop is an e-commerce application built using multiple microservices. Each service handles a specific responsibility, such as products, users, cart, shipping, and payments.

## 1. Application Architecture

The application is divided into three tiers:

- **Frontend:** User interface of the e-commerce website.
- **App/Backend Tier:** Processes requests and handles business logic.
- **Database Tier:** Stores application data.

```text
User → Frontend → Backend Services → Databases
                                  → Message Queue
```

![Roboshop Project Overview](/diagrams/roboshop.png)

## 2. Database & Messaging Components

### MongoDB

MongoDB is a NoSQL database that stores data in flexible, JSON-like documents.  
**In RoboShop:** Stores product information for Catalogue and user data for User services. 

Example:

```json
{
  "name": "Some Food",
  "price": 123,
  "description": "Daily consumable food product",
  "expiry": "2026-12-31"
}
```

Used by: Catalogue and User services.

Documentation: [MongoDB Setup](./mongodb.md)

### MySQL

**MySQL** is a relational database management system (RDBMS). It organizes structured data into tables, rows, and columns. 
**In RoboShop:** Stores shipping-related data, including countries, cities, and distances used to calculate shipping costs.  

Documentation: [MySQL Setup](./mysql.md)

### Redis

Redis is an in-memory key-value data store used for fast data access.  
**In RoboShop:** Supports the User and Cart services with fast access to frequently needed data. 

```text
Application → Redis Cache → Database
```

Frequently accessed data can be retrieved from Redis instead of repeatedly querying the database.

Documentation: [Redis Setup](./redis.md)

### RabbitMQ
RabbitMQ is a message broker that enables asynchronous communication between services.  
**In RoboShop:** Payment sends messages through RabbitMQ, allowing Dispatch to process product dispatch separately.  

Documentation: [RabbitMQ Setup](./rabbitmq.md)

## 3. Application Components

### 1. Catalogue
Catalogue is a microservice responsible for providing the list of products displayed in the RoboShop website.  
**In RoboShop:** Retrieves product information from MongoDB and provides it to the frontend and Cart service.  
**Programming Language:** Node.js  
**Documentation:** [Catalogue Setup](./catalogue.md)

### 2. User
User is a microservice responsible for user registration and login.  
**In RoboShop:** Uses MongoDB for user data and Redis for fast access to required data.  
**Programming Language:** Node.js  
**Documentation:** [User Setup](./user.md)

### 3. Cart
Cart is a microservice responsible for managing products added to the shopping cart.  
**In RoboShop:** Uses Redis for cart data and communicates with Catalogue to retrieve product information.  
**Programming Language:** Node.js  
**Documentation:** [Cart Setup](./cart.md)

### 4. Shipping
Shipping is a microservice responsible for calculating shipping distance and cost.  
**In RoboShop:** Retrieves cart details from Cart and shipping-related location data from MySQL.  
**Programming Language:** Java  
**Build Tool:** Maven  
**Documentation:** [Shipping Setup](./shipping.md)

### 5. Payment
Payment is a microservice responsible for payment-related operations.  
**In RoboShop:** Communicates with Cart and User and uses RabbitMQ for asynchronous messaging.  
**Programming Language:** Python  
**Package Manager:** pip  
**Documentation:** [Payment Setup](./payment.md)

### 6. Dispatch
Dispatch is a microservice responsible for processing product dispatch after purchase.  
**In RoboShop:** Receives messages through RabbitMQ and processes dispatch separately from the other services.  
**Programming Language:** Golang
**Documentation:** [Dispatch Setup](./dispatch.md)

### 7. Frontend
Frontend is the web interface that customers use to browse products and interact with RoboShop.  
**In RoboShop:** Nginx serves the static website files and forwards API requests to the appropriate backend services.  
**Technologies:** HTML, CSS, JavaScript  
**Web Server:** Nginx  
**Documentation:** [Frontend Setup](./frontend.md)

### Important Configuration Notes

**Catalogue — MongoDB configuration**

Replace `<MONGODB-SERVER-IPADDRESS>` with the actual MongoDB server IP address.

**Frontend — Backend configuration**

Replace `localhost` with the actual backend address:

```text
http://backend.vijaydev.me:8080/
```

**Health check**

A health check verifies whether an application service is responding.

```bash
curl http://localhost:8080/health
```

Checks the service health endpoint.

```bash
curl -v http://localhost:8080/health
```

Displays detailed request and response information for troubleshooting.

**Check network connectivity**

```bash
telnet <IP_ADDRESS> <PORT>
```

Example:

```bash
telnet 172.31.30.23 6379
```

Checks whether a connection can be established to the specified IP and port.

To exit Telnet, press `Ctrl + ]`, then type `quit` and press Enter.

**Vim command**

```vim
:%d
```

Deletes all lines in the file currently open in Vim.

## 4. Java and Maven

**Java** is a programming language. **Maven** is a build tool used to compile, test, and package Java applications.

**Important Files and Terms**

```text
.java              → Java source code
pom.xml            → Maven project configuration and dependencies
.class             → Compiled Java bytecode
.jar               → Java archive
.war               → Web application archive
.ear               → Enterprise application archive
```

A Java program can be compiled using:

```bash
javac HelloWorld.java
```

This generates `HelloWorld.class` when compilation succeeds.

### Maven Project Identifiers

| Term | Example | Meaning |
|---|---|---|
| GroupId | `in.amazon` | Identifies the project group |
| ArtifactId | `cart` | Identifies the application or module |
| Version | `1.0` | Identifies the release version |

### Maven Commands

| Command | Purpose |
|---|---|
| `mvn validate` | Validates the project |
| `mvn compile` | Compiles Java source code |
| `mvn test` | Runs unit tests |
| `mvn package` | Builds the application package |
| `mvn clean` | Removes previous build output |
| `mvn clean package` | Cleans and builds the application |

Maven creates build output in the `target/` directory. A project's `pom.xml` determines its packaging type and build configuration.

## 5. Node.js and Python

### Node.js

Node.js executes JavaScript outside the browser.

```text
Source files     → .js
Dependency file  → package.json
```

```bash
npm install
```

Installs the dependencies defined by the Node.js project.

```bash
/bin/node index.js
```

Runs `index.js` using Node.js.

### Python

Python is used for applications such as the Payment service.

```text
Source files     → .py
Dependency file  → requirements.txt
Package manager  → pip
```

```bash
pip3 install -r requirements.txt
```

Installs the Python dependencies listed in `requirements.txt`.

## 6. RabbitMQ and Message Queues

**RabbitMQ** is a message broker that allows applications to communicate through messages instead of requiring every service to respond immediately.

### Synchronous vs Asynchronous

- **Synchronous:** The caller waits for the response.
- **Asynchronous:** The caller sends a message and continues its work while the receiver processes it later.

Example: An order service sends order details to a queue so another service can process them.

### Important Concepts

- **Producer:** Sends messages.
- **Queue:** Stores messages until consumers process them.
- **Consumer:** Receives and processes messages.
- **Point-to-point:** A message is processed by a consumer through a queue.
- **Publish/subscribe:** Messages are distributed to subscribers through an exchange and their associated queues.

### Why Use RabbitMQ?

- **Loose coupling:** Services do not need to depend on immediate responses from each other.
- **Reliability:** Messages can be retained for processing when consumers are temporarily unavailable, depending on queue and message configuration.
- **Scalability:** Multiple consumers can process queued work.

Other messaging technologies include ActiveMQ, IBM MQ, and Apache Kafka.

![Message Queue](/diagrams/mq.png)

## 7. APIs: Request and Response

An **API (Application Programming Interface)** allows one application to communicate with another application.

Example:

```text
Client sends a request
        ↓
API processes the request
        ↓
Server returns a response
```

Example: A government examination results website receives a hall-ticket number and returns the corresponding examination results through its API.

## 8. Manual Deployment Process

Manual deployment involves setting up a server and installing the application step by step. Repeating these steps for multiple services is time-consuming and increases the chance of errors.

### Application Setup

```text
1. Create the server
2. Install the required programming language
3. Create a system user
4. Create the application directory
5. Download and extract application code
6. Install dependencies
7. Create a systemd service
8. Reload systemd
9. Start or restart the application
```

### Create a System User

```bash
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
```

Creates a system account named `roboshop`, assigns `/app` as its home directory, and disables interactive login through `/sbin/nologin`.

### Common systemd Commands

```bash
systemctl daemon-reload
```

Reloads systemd service definitions after configuration changes.

```bash
systemctl start <service>
```

Starts the specified service.

```bash
systemctl enable <service>
```

Configures the service to start automatically at boot.

```bash
systemctl restart <service>
```

Restarts the service.

```bash
systemctl status <service>
```

Displays the current service status.

## 9. Application Deployment Updates

When deploying a new version of the application:

```text
Remove or replace old code
          ↓
Download the new code
          ↓
Install or update dependencies
          ↓
Restart the application service
          ↓
Verify application health
```

Always check the service status and application health after deployment.

## 10. Shell Scripting

A **shell script** is a file containing Linux commands that can be executed in sequence to automate repetitive tasks.

Instead of running every command manually, place the commands in a script and execute them together.

### Example

```bash
#!/bin/bash

dnf install nginx -y

if [ $? -eq 0 ]; then
    echo "Nginx installed successfully"
else
    echo "Nginx installation failed"
    exit 1
fi
```

This script installs Nginx and checks whether the installation command succeeded. It stops with an error if the installation fails.

### Important Shell Scripting Concepts

| Concept | Purpose |
|---|---|
| Variables | Store reusable values |
| Data types | Represent different kinds of data |
| Conditions | Make decisions based on results |
| Loops | Repeat commands |
| Functions | Reuse a group of commands |
| Error handling | Detect and handle failures |

**Goal:** Automate repetitive server setup and deployment tasks, reduce manual mistakes, and make troubleshooting easier.
