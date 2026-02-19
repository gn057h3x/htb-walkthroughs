# HTB Walkthroughs

Writeups for retired [Hack The Box](https://www.hackthebox.com/) machines.

All walkthroughs are published **after** the machine has been retired, per [HTB guidelines](https://help.hackthebox.com/en/articles/5188925-streaming-writeups-walkthrough-guidelines).

## Machines

| Machine | Difficulty | OS | Key Techniques |
|---------|-----------|-----|----------------|
| *Coming soon* | | | |

## Structure

```
machines/          # Published walkthrough .md files
sanitize.sh        # Sanitize + publish wrapper script
```

## Publishing

Walkthroughs are sanitized before publishing to redact target IPs, VPN IPs, and credentials:

```bash
# Preview what would be redacted
python3 ../sanitize_walkthrough.py ../Obsidian/HTB/Labs/<Machine>/<Machine>.md --dry-run

# Sanitize and publish
./sanitize.sh <Machine>
```
