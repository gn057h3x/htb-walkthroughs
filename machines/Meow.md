> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Meow

**Hack The Box** · Very Easy · Linux

`Telnet` · `Default Credentials` · `Blank Password`

---

## Overview

Meow is the first Starting Point machine on Hack The Box. It introduces the basics — connecting to the VPN, scanning a target, and logging into an exposed service. The entire attack surface is a single Telnet port with no authentication on the root account.

---

## Reconnaissance

```bash
nmap -sC -sV <TARGET_IP>
```

```
PORT   STATE SERVICE REASON
23/tcp open  telnet  syn-ack
```

Only one port open — Telnet on 23. No SSH, no web server, nothing else. Nmap's service detection didn't grab a version banner, but the service itself is clear.

---

## Logging In with a Blank Password

With only Telnet available, the first thing to try is common default credentials. Telnet doesn't encrypt anything — credentials travel in plaintext, which is why it should never be exposed.

```bash
telnet <TARGET_IP>
```

```
Meow login: root
Password: [blank]

Welcome to Ubuntu 20.04.2 LTS
root@Meow:~#
```

The `root` account accepts a blank password. No brute-forcing, no credential hunting — just an empty password field and full system access.

---

## Takeaways

- Telnet transmits everything in cleartext — it should never be internet-facing. SSH exists for a reason.
- Default and blank credentials on privileged accounts are still one of the most common findings in real environments.
- Always test common usernames (`root`, `admin`, `administrator`) with empty passwords before moving to wordlists.
- The Telnet banner can be slow to appear on HTB — give it a few seconds before assuming the connection failed.
