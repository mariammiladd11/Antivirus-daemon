# Lab 2 - Simple Antivirus Daemon

## Description

This project implements a simple antivirus daemon using bash shell scripting.

The antivirus monitors a directory at regular intervals and detects malicious files. When a change in the directory is detected, it scans the files, prints the malicious ones, copies them into a quarantine directory and deletes them from the monitored directory. A separate restore tool lets the user review quarantined files and restore or delete them.

A file is considered malicious if it matches at least one rule:
- Flagged extension (only the final extension counts): `.exe`, `.bat`, `.vbs`, `.scr`, `.ps1`
- Flagged content (case-insensitive, matches anywhere in the file, even inside a longer word): `virus`, `trojan`, `malware`, `worm`, `ransomware`

## Folder hierarchy

```
Antivirus-daemon/
├── antivirusd.sh    # the antivirus daemon (Part 1)
├── restore.sh       # interactive restore tool (Part 2)
├── Makefile         # run, restore and pre-build targets (Part 3)
├── README.md        # this file (Part 4)
├── test_dir/        # monitored directory (files only, no subdirectories)
└── malicious_dir/   # quarantine directory (created by the Makefile)
```

Files generated while the daemon runs: `directory-info.last` and `directory-info.new` (snapshots of the monitored directory).

## How it works

1. `antivirusd.sh dir malicious_dir interval-secs` first checks its arguments and creates `malicious_dir` if needed.
2. If `directory-info.last` does not exist (first run), it scans immediately, then creates `directory-info.last` with `ls -l dir`.
3. Every `interval-secs` seconds it saves a new snapshot (`ls -l dir > directory-info.new`) and compares it with `directory-info.last`.
4. If they are identical, nothing happens. If they differ, it scans `dir`.
5. For every malicious file the daemon prints `<file> is malicious and it is DELETED`, copies the file into `malicious_dir`, and deletes the original.
6. After a scan, `directory-info.last` is regenerated from the current contents of `dir`.

## Prerequisites

The scripts need `bash`, `make` and the standard tools `ls`, `cmp`, `grep`, `cp`, `rm` and `mkdir`. Most of these are already installed on Ubuntu. To install what is missing:

```bash
sudo apt update
sudo apt install -y make git
```

Make the scripts executable (once):

```bash
chmod +x antivirusd.sh restore.sh
```

## Running the antivirus and the restore tool

1. Create the monitored directory and some test files:
```bash
   mkdir -p test_dir
   echo x > test_dir/a.exe
   echo "this is a virus" > test_dir/b.txt
   echo hello > test_dir/ok.txt
```
2. Start the antivirus. The Makefile first creates `malicious_dir` if it does not exist:
```bash
   make run
```
   Flagged files are reported, quarantined and removed from `test_dir`. While it runs you can add new files from a second terminal to see them detected. Press `Ctrl+C` to stop it.
3. Stop the antivirus before using the restore tool. The two scripts must not run at the same time.
4. Start the restore tool:
```bash
   make restore
```
   It shows the quarantined files as a numbered list (`1: name`). Type a number to pick a file, then choose:
   - `1` to restore the file into the monitored directory (it was a false positive)
   - `2` to permanently delete the file from `malicious_dir` (it was genuinely malicious)
   - `3` to go back to the list

   If `malicious_dir` is empty, it prints `No malicious files to review.`
5. The Makefile values can be changed, for example:
```bash
   make run DIR=my_dir MAL_DIR=my_quarantine INTERVAL=2
```

You can also run the scripts directly:

```bash
./antivirusd.sh test_dir malicious_dir 5
./restore.sh test_dir malicious_dir
```

## Where the required lists are defined

Both lists are defined at the top of `antivirusd.sh`:

- `FLAGGED_EXTENSIONS`: `.exe .bat .vbs .scr .ps1`
- `FLAGGED_KEYWORDS`: `virus trojan malware worm ransomware`

The function `is_malicious` in the same file uses them: the extension check looks only at the end of the file name (the final extension), and the keyword check uses `grep -i` on the file's contents.
