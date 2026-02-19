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

# Cap — HTB Machine

## Target Info

| Field | Value |
|-------|-------|
| Platform | HTB Machines |
| Target IP | <TARGET_IP> |
| Attack IP | <ATTACK_IP> |
| OS | Linux (Ubuntu 20.04.2 LTS) |
| Difficulty | Easy |

## Recon

### Nmap Scan
- **Port 21/tcp** — FTP (vsftpd 3.0.3)
- **Port 22/tcp** — SSH (OpenSSH 8.2p1 Ubuntu)
- **Port 80/tcp** — HTTP (Gunicorn — "Security Dashboard")

## Enumeration

- Web app: Python/Gunicorn "Security Dashboard" with routes:
  - `/` — Dashboard
  - `/capture` — 5-second PCAP capture, redirects to `/data/<id>`
  - `/ip` — IP config
  - `/netstat` — Network status
- `/capture` redirects to `/data/<N>` with incrementing IDs, download at `/download/<N>`
- FTP anonymous login denied
- FTP is chrooted to user home directory — no path traversal

## Exploitation

### IDOR → Credential Disclosure
- `/data/0` accessible without authorization (IDOR on sequential IDs)
- Downloaded PCAP via `/download/0`
- PCAP contains plaintext FTP session: `nathan:<redacted>`
- Password reuse — creds work on SSH and FTP

### Privilege Escalation
- `getcap -r /` reveals `cap_setuid` on `/usr/bin/python3.8`
- `python3.8 -c "import os; os.setuid(0); os.system('/bin/bash')"` → root shell

## Flags

- [x] User flag: `<flag_redacted>`
- [x] Root flag: `<flag_redacted>`

## Credentials

| User | Password | Source |
|------|----------|--------|
| nathan | <redacted> | FTP login in PCAP `/download/0` |

## Lessons Learned

- IDOR on sequential IDs — always test `/data/0`, `/data/1`, etc. when app uses numbered resources
- PCAP captures on a server may contain other users' plaintext credentials (FTP, Telnet, HTTP Basic)
- Linux capabilities (`cap_setuid`) are an often-overlooked privesc vector — always run `getcap -r /`
- Python with `cap_setuid` = instant root via `os.setuid(0)`

## Timeline

| Time | Action |
|------|--------|
| 2026-02-16 | Started — VPN connected, machine spawned |
| 2026-02-16 | Nmap scan — FTP, SSH, HTTP open |
| 2026-02-16 | Web enumeration — found IDOR on /data/ endpoint |
| 2026-02-16 | Downloaded PCAP 0 — extracted FTP creds for nathan |
| 2026-02-16 | SSH/FTP access as nathan — user flag captured |
| 2026-02-16 | cap_setuid on python3.8 — root flag captured |
