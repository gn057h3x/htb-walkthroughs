---
title: Dancing
platform: Hack The Box
category: Starting Point
difficulty: Very Easy
os: Windows
date_started: 2026-02-16
date_completed: 2026-02-16
tags: [htb, starting-point, windows, smb, null-session]
---

> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Dancing — HTB Starting Point

## Target Info

| Field | Value |
|-------|-------|
| Platform | HTB Starting Point |
| Target IP | <TARGET_IP> |
| Attack IP | <ATTACK_IP> |
| OS | Windows |
| Difficulty | Very Easy |

## Recon

### Nmap Scan
- **Port 135/tcp** — MSRPC
- **Port 139/tcp** — NetBIOS
- **Port 445/tcp** — SMB (SMB2/3.1.1, signing enabled but not required)
- **Port 5985/tcp** — WinRM (Microsoft HTTPAPI)
- 996 closed ports

## Enumeration

### SMB Shares (null session)
| Share | Type | Comment | Accessible |
|-------|------|---------|------------|
| ADMIN$ | Disk | Remote Admin | No |
| C$ | Disk | Default share | No |
| IPC$ | IPC | Remote IPC | — |
| WorkShares | Disk | | Yes |

### WorkShares Contents
- `Amy.J/worknotes.txt` (94 bytes)
- `James.P/flag.txt` (32 bytes)

## Exploitation

- Null session SMB access to `WorkShares` share
- `smbclient -N //<TARGET_IP>/WorkShares`
- Navigated to `James.P/` and downloaded `flag.txt`

## Flags

- [x] Root flag: `<flag_redacted>`

## Lessons Learned

- SMB null sessions can expose file shares without authentication
- Always enumerate SMB shares on Windows targets — non-default shares often contain sensitive data
- SMB signing "enabled but not required" means relay attacks are possible
- WinRM on 5985 is worth noting for potential authenticated access later
- `smbclient -N -L` for share listing, `-N` for null (no password) authentication

## Timeline

| Time | Action |
|------|--------|
| 2026-02-16 | Started — target spawned |
| 2026-02-16 | Nmap scan — SMB/RPC/WinRM open |
| 2026-02-16 | SMB null session — enumerated shares, found WorkShares |
| 2026-02-16 | Downloaded flag from James.P/flag.txt — box complete |
