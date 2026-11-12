# Shell Scripting

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
