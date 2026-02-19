---
title: Meow
platform: Hack The Box
category: Starting Point
difficulty: Very Easy
os: Linux
date_started: 2026-02-16
date_completed: 2026-02-16
tags: [htb, starting-point, linux, telnet, default-creds]
---

> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Meow — HTB Starting Point

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
- **Port 23/tcp** — Telnet (open)
- 999 closed ports
- No version banner grabbed (service detection inconclusive)

## Enumeration

- Only service exposed: Telnet on port 23
- No web, SSH, or other services running

## Exploitation

- Connected via `telnet <TARGET_IP>`
- Login: `root` with blank password (no authentication)
- Dropped straight into root shell

## Flags

- [x] Root flag: `<flag_redacted>`

## Lessons Learned

- Telnet exposes credentials in plaintext — should never be internet-facing
- Default/blank credentials on root account = immediate full compromise
- Always check for telnet and other legacy protocols during recon
- HTB telnet service is slow to present the login banner — patience needed

## Timeline

| Time | Action |
|------|--------|
| 2026-02-16 | Started — VPN connected |
| 2026-02-16 | Nmap scan — port 23/tcp telnet open |
| 2026-02-16 | Telnet root login with blank password — pwned |
| 2026-02-16 | Root flag captured — box complete |
