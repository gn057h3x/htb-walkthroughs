---
title: Fawn
platform: Hack The Box
category: Starting Point
difficulty: Very Easy
os: Linux
date_started: 2026-02-16
date_completed: 2026-02-16
tags: [htb, starting-point, linux, ftp, anonymous-access]
---

> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Fawn — HTB Starting Point

## Target Info

| Field | Value |
|-------|-------|
| Platform | HTB Starting Point |
| Target IP | <TARGET_IP> |
| Attack IP | <ATTACK_IP> |
| OS | Linux |
| Difficulty | Very Easy |

## Recon

### Nmap Scan
- **Port 21/tcp** — FTP (vsftpd 3.0.3)
- Anonymous FTP login allowed
- `flag.txt` visible in FTP root
- 999 closed ports

## Enumeration

- vsftpd 3.0.3 on Unix
- Anonymous login enabled (FTP code 230)
- Single file in FTP root: `flag.txt` (32 bytes)

## Exploitation

- Anonymous FTP login — no credentials needed
- `curl ftp://anonymous:@<TARGET_IP>/flag.txt` to grab the flag directly

## Flags

- [x] Root flag: `<flag_redacted>`

## Lessons Learned

- Anonymous FTP access can expose sensitive files directly
- Nmap's `ftp-anon` script automatically detects anonymous login and lists visible files
- vsftpd is a common Linux FTP server — always check for anonymous access

## Timeline

| Time | Action |
|------|--------|
| 2026-02-16 | Started — target spawned |
| 2026-02-16 | Nmap scan — port 21/tcp FTP with anonymous access |
| 2026-02-16 | Anonymous FTP login — flag grabbed |
| 2026-02-16 | Root flag captured — box complete |
