# Lab 2 – Simple Antivirus Daemon

## Description

This project implements a simple antivirus daemon using Bash shell scripting.

The antivirus monitors a directory at regular intervals and detects malicious files based on:
- Suspicious file extensions: `.exe`, `.bat`, `.vbs`, `.scr`, `.ps1`
- Malicious keywords: `virus`, `trojan`, `malware`, `worm`, `ransomware`

Detected files are copied to a quarantine directory and removed from the monitored directory.

## Files

- `antivirusd.sh` – Monitors the directory and detects malicious files.
- `restore.sh` – Reviews quarantined files and allows the user to restore, delete, or leave them.
- `Makefile` – Provides commands to run the antivirus and restore utility.
- `test_dir/` – Directory being monitored.
- `malicious_dir/` – Quarantine directory.

## Usage

Run the antivirus:

```bash
make run
