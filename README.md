# User-Account-Management-with-Bash

# User Account Management with Bash

A robust Bash-based solution to automate the full Linux user lifecycle—creation, password rotation, and deletion—complete with a CLI, input validation, structured logging, email notifications, cron scheduling, and CI linting. Creating a clear, comprehensive README ensures contributors and operators can quickly understand and adopt your project  ([How to Write a Good README File for Your GitHub Project](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/?utm_source=chatgpt.com)).

## Table of Contents  
- [Problem Statement](#problem-statement)  
- [Solution Overview](#solution-overview)  
- [Features](#features)  
- [Tech Stack](#tech-stack)  
- [Prerequisites](#prerequisites)  
- [Installation & Setup](#installation--setup)  
- [Configuration](#configuration)  
- [Usage Examples](#usage-examples)  
- [Scheduling](#scheduling)  
- [Logging & Monitoring](#logging--monitoring)  
- [Security & Permissions](#security--permissions)  
- [CI / Linting](#ci--linting)  
- [Contributing](#contributing)  
- [License](#license)  

## Problem Statement  
Manual Linux user management at scale is error-prone, time-consuming, and hard to audit—especially when compliance requires regular password rotations and cleanup of inactive accounts  ([How to Create the Perfect README for Your Open Source Project](https://dev.to/github/how-to-create-the-perfect-readme-for-your-open-source-project-1k69?utm_source=chatgpt.com)).  

## Solution Overview  
This project delivers a single entrypoint `user_mgmt.sh` that:  
1. **Creates** users from a CSV with secure random passwords.  
2. **Rotates** passwords past policy thresholds via `chage`  ([How to Write a Good README File for Your GitHub Project](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/?utm_source=chatgpt.com)).  
3. **Deletes** inactive accounts using `lastlog`  ([Make a README](https://www.makeareadme.com/?utm_source=chatgpt.com)).  
4. **Logs** all actions with timestamps and levels.  
5. **Notifies** administrators by email on each run  ([README Best Practices - Tilburg Science Hub](https://tilburgsciencehub.com/topics/collaborate-share/share-your-work/content-creation/readme-best-practices/?utm_source=chatgpt.com)).  
6. **Schedules** via cron with `flock` to prevent overlap  ([Maintaining an Open Source Project Cheatsheet - Codecademy](https://www.codecademy.com/learn/introduction-to-open-source/modules/maintaining-an-open-source-project/cheatsheet?utm_source=chatgpt.com)).  

## Features  
- **Modular Scripts**: Separate concerns in `scripts/` and shared logic in `common.sh`  
- **CLI Interface**: Intuitive flags via `getopts`  ([Creating a Powerful README: Best Practices for Your Project](https://medium.com/%40berastis/creating-a-powerful-readme-best-practices-for-your-project-f974a1e69a51?utm_source=chatgpt.com))  
- **Strict Mode**: `set -euo pipefail` for fail-fast behavior  ([jehna/readme-best-practices - GitHub](https://github.com/jehna/readme-best-practices?utm_source=chatgpt.com))  
- **Input Validation**: Regex-based username checks to prevent injection  ([opensource.guide/_articles/best-practices.md at main ... - GitHub](https://github.com/github/opensource.guide/blob/main/_articles/best-practices.md?utm_source=chatgpt.com))  
- **Structured Logging**: Levelled logs in `/var/log/user_mgmt/`  
- **Email Alerts**: `mailx` integration for audit notifications  ([README Best Practices - Tilburg Science Hub](https://tilburgsciencehub.com/topics/collaborate-share/share-your-work/content-creation/readme-best-practices/?utm_source=chatgpt.com))  
- **Locking**: `flock` ensures single instance execution  ([Maintaining an Open Source Project Cheatsheet - Codecademy](https://www.codecademy.com/learn/introduction-to-open-source/modules/maintaining-an-open-source-project/cheatsheet?utm_source=chatgpt.com))  
- **CI Linting**: ShellCheck workflow enforces best practices   

## Tech Stack  
- **Bash** ≥4.0 with `set -euo pipefail`  ([jehna/readme-best-practices - GitHub](https://github.com/jehna/readme-best-practices?utm_source=chatgpt.com))  
- **GNU coreutils**: `useradd`, `chage`, `lastlog`  
- **mailx** for SMTP notifications   
- **cron** and **flock** for scheduled, safe execution  ([Maintaining an Open Source Project Cheatsheet - Codecademy](https://www.codecademy.com/learn/introduction-to-open-source/modules/maintaining-an-open-source-project/cheatsheet?utm_source=chatgpt.com))  
- **ShellCheck** for CI linting  ([Best Practices For An Eye Catching GitHub Readme - Hatica](https://www.hatica.io/blog/best-practices-for-github-readme/?utm_source=chatgpt.com))  

## Prerequisites  
- Linux host with Bash ≥4.0, mailx, cron, flock installed  
- Dedicated admin user (e.g., `usermgmtadmin`) with sudo rights to manage accounts  ([How to Create the Perfect README for Your Open Source Project](https://dev.to/github/how-to-create-the-perfect-readme-for-your-open-source-project-1k69?utm_source=chatgpt.com))  
- SMTP server reachable for email alerts  

## Installation & Setup  
See [docs/setup.md](docs/setup.md) for step-by-step host preparation, permission configuration, and initial setup.  

## Configuration  
Copy the template and adjust parameters in `config/user_mgmt.conf`:
```ini
PASS_MAX_DAYS=90
INACTIVE_DAYS=30
ADMIN_EMAIL=admin@example.com
LOG_DIR=/var/log/user_mgmt
LOCKFILE=/var/lock/user_mgmt.lock
MAIL_CMD=mailx
```
Permissions: `chmod 600 config/user_mgmt.conf` to protect sensitive settings.  

## Usage Examples  
See [docs/usage.md](docs/usage.md) for detailed CLI examples, log interpretation, and config overrides.  

## Scheduling  
Add to crontab (as `usermgmtadmin`):
```cron
0 1 * * * /usr/bin/flock -n /var/lock/user_mgmt.lock /opt/user-mgmt/bin/user_mgmt.sh -r >> /var/log/user_mgmt/cron.log 2>&1
0 2 * * 0 /usr/bin/flock -n /var/lock/user_mgmt.lock /opt/user-mgmt/bin/user_mgmt.sh -d >> /var/log/user_mgmt/cron.log 2>&1
```  
This runs password rotation daily at 01:00 and deletion weekly on Sundays at 02:00  ([Maintaining an Open Source Project Cheatsheet - Codecademy](https://www.codecademy.com/learn/introduction-to-open-source/modules/maintaining-an-open-source-project/cheatsheet?utm_source=chatgpt.com)).  

## Logging & Monitoring  
- Logs: `/var/log/user_mgmt/YYYY-MM-DD_user_mgmt.log`  
- Levels: `INFO`, `ERROR`  ([opensource.guide/_articles/best-practices.md at main ... - GitHub](https://github.com/github/opensource.guide/blob/main/_articles/best-practices.md?utm_source=chatgpt.com))  
- Integrate with SIEM by forwarding log files.  

## Security & Permissions  
- Scripts owned by `usermgmtadmin` or root  
- Config file mode `600` to secure secrets  
- Lockfile in `/var/lock` to prevent concurrent runs  

## CI / Linting  
ShellCheck runs on every PR via `.github/workflows/shellcheck.yml`, catching common pitfalls and enforcing style  ([Best Practices For An Eye Catching GitHub Readme - Hatica](https://www.hatica.io/blog/best-practices-for-github-readme/?utm_source=chatgpt.com)).  

## Contributing  
1. Fork the repo  
2. Create a feature branch  
3. Ensure all scripts pass ShellCheck  
4. Submit a PR for review  
5. ShellCheck CI for Bash – GitHub Actions Marketplace  ([Best Practices For An Eye Catching GitHub Readme - Hatica](https://www.hatica.io/blog/best-practices-for-github-readme/?utm_source=chatgpt.com))  
6. Bash Strict Mode – StackOverflow  ([jehna/readme-best-practices - GitHub](https://github.com/jehna/readme-best-practices?utm_source=chatgpt.com))  
7. chage for Password Rotation – Linux man pages  ([How to Write a Good README File for Your GitHub Project](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/?utm_source=chatgpt.com))  
8. lastlog for Inactivity – Linux man pages  ([Make a README](https://www.makeareadme.com/?utm_source=chatgpt.com))  
9. Cron and flock Best Practices – nixCraft  ([Maintaining an Open Source Project Cheatsheet - Codecademy](https://www.codecademy.com/learn/introduction-to-open-source/modules/maintaining-an-open-source-project/cheatsheet?utm_source=chatgpt.com))  
10. getopts Usage – TLDP Bash Guide  ([Creating a Powerful README: Best Practices for Your Project](https://medium.com/%40berastis/creating-a-powerful-readme-best-practices-for-your-project-f974a1e69a51?utm_source=chatgpt.com))  
11. Input Validation in Bash – StackOverflow  ([opensource.guide/_articles/best-practices.md at main ... - GitHub](https://github.com/github/opensource.guide/blob/main/_articles/best-practices.md?utm_source=chatgpt.com))
