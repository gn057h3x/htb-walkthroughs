---
title: Redeemer
platform: Hack The Box
category: Starting Point
difficulty: Very Easy
os: Linux
date_started: 2026-02-16
date_completed: 2026-02-16
tags: [htb, starting-point, linux, redis, no-auth]
---

> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Redeemer — HTB Starting Point

## Target Info

| Field | Value |
|-------|-------|
| Platform | HTB Starting Point |
| Target IP | <TARGET_IP> |
| Attack IP | <ATTACK_IP> |
| OS | Linux (5.4.0-77-generic) |
| Difficulty | Very Easy |

## Recon

### Nmap Scan
- **Port 6379/tcp** — Redis 5.0.7 (no authentication)
- No other ports open on default top 1000

## Enumeration

### Redis Info
- Version: 5.0.7
- Mode: standalone
- Config: `/etc/redis/redis.conf`
- No authentication required

### Keys (DB 0)
| Key | Value |
|-----|-------|
| flag | `<flag_redacted>` |
| numb | `bb2c8a7506ee45cc981eb88bb81dddab` |
| stor | `e80d635f95686148284526e1980740f8` |
| temp | `1c98492cd337252698d0c5f631dfb7ae` |

## Exploitation

- Connected with `redis-cli -h <TARGET_IP>`
- No auth needed — `INFO server` and `KEYS *` worked immediately
- `GET flag` returned the flag

## Flags

- [x] Root flag: `<flag_redacted>`

## Lessons Learned

- Redis without authentication exposes all data — always require `requirepass` in production
- Redis default port 6379 is outside nmap's top 1000 — use `-p 6379` or `-p-` to catch it
- `redis-cli` provides full interactive access: `INFO`, `KEYS *`, `GET`, `SELECT` for DB switching
- In-memory data stores are high-value targets — often contain session tokens, caches, or flags

## Timeline

| Time | Action |
|------|--------|
| 2026-02-16 | Started — target spawned |
| 2026-02-16 | Nmap targeted scan — Redis 5.0.7 on 6379 |
| 2026-02-16 | Redis no-auth access — enumerated 4 keys |
| 2026-02-16 | Flag retrieved — box complete |
