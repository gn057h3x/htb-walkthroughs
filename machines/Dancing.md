> **Disclaimer:** This writeup is published after the machine was retired from Hack The Box. All flags are unique per user.

# Dancing

**Hack The Box** · Very Easy · Windows

`SMB` · `Null Session` · `Share Enumeration`

---

## Overview

Dancing introduces SMB enumeration on a Windows target. A null session (no credentials) grants access to a non-default file share containing user data. The machine also exposes WinRM, hinting at post-exploitation possibilities if credentials were found.

---

## Reconnaissance

```bash
nmap -sC -sV <TARGET_IP>
```

```
PORT     STATE SERVICE       VERSION
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
```

Four ports open. The interesting ones: SMB on 445 (primary target) and WinRM on 5985 (useful if we find credentials later). Nmap also reports SMB signing is enabled but not required — that's a relay attack opportunity in a real engagement.

---

## Enumerating SMB Shares

```bash
smbclient -N -L //<TARGET_IP>
```

```
	Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	WorkShares      Disk
```

Four shares. `ADMIN$` and `C$` are default administrative shares (access denied without admin creds). `WorkShares` is a non-default share — those are always worth investigating because admins created them for a reason.

---

## Accessing WorkShares

```bash
smbclient -N //<TARGET_IP>/WorkShares
```

```
smb: \> ls
  .                                   D        0
  ..                                  D        0
  Amy.J                               D        0
  James.P                             D        0

smb: \James.P\> get flag.txt
```

The null session gives read access to `WorkShares`. Inside are two user directories — `Amy.J` with work notes and `James.P` with the flag. No authentication required.

---

## Takeaways

- SMB null sessions can expose file shares without any credentials. Always enumerate shares with `-N` (null auth) as a first step on Windows targets.
- Non-default shares (`WorkShares`, `Public`, `Data`, etc.) are prime targets — they were created intentionally and often contain sensitive data.
- SMB signing "enabled but not required" means NTLM relay attacks are possible in a real environment.
- WinRM on 5985 is worth noting for later — if credentials are found, it's a direct shell via `evil-winrm`.

---

*Walkthrough by Jack — 2026-02-16*
