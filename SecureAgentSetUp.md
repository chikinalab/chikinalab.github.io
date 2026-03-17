# Secure Agent User Setup on Linux

A guide to creating an isolated Linux user for running AI agents, with scoped access to a specific Dropbox folder, shared conda environments, and a clean terminal experience.

------

## Overview

The goal is to create a user called `agent` that:

- Has no password (only accessible via sudo from your main user)
- Has full read/write access to `~/Dropbox/Agents/` only
- Cannot list or read any other part of your home directory or Dropbox
- Can use your existing mambaforge conda environments without copying them
- Has a bright color-coded terminal so that you don't get confused what user you are

------

## 1. Create the Agent User

Create the user with a bash shell but no password, then lock the account so it can only be accessed via sudo.

```bash
    sudo useradd -m -s /bin/bash agent
    sudo usermod -L agent
```

- `-m` creates a home directory at `/home/agent`
- `-s /bin/bash` gives a real shell (required for interactive use)
- `-L` locks the password, preventing direct login

------

## 2. Allow Passwordless sudo Switch

Configure sudo so you can switch to `agent` without being prompted for a password.

```bash
sudo visudo
```

Add this line at the bottom:

```
mchikina ALL=(agent) NOPASSWD: ALL
```

Save and exit. Now you can switch to the agent user without any password prompt.

------

## 3. Add a Convenient Alias

Add an alias to your own `.bashrc` so switching to the agent is a single word:

```bash
echo "alias agent='sudo -u agent bash --login'" >> /home/mchikina/.bashrc
source /home/mchikina/.bashrc
```

Now just type `agent` to open an interactive session as the agent user.

------

## 4. Create a Shared Group for Dropbox/Agents Access

Use a dedicated group shared between both users.

```bash
sudo groupadd agents-group
sudo usermod -aG agents-group mchikina
sudo usermod -aG agents-group agent
```

------

## 5. Set Filesystem Permissions

My agent directory lives in a `Dropbox` subfolder but this can be any other folder.

This is the core of the isolation. The agent can traverse the path to `Dropbox/Agents/` but cannot list or read anything else along the way.

```bash
# Your home dir: group can traverse only, no world access
chmod o= /home/mchikina
chmod o+x /home/mchikina

# Dropbox root: group can traverse only, no listing
chmod o= /home/mchikina/Dropbox
chmod o+x /home/mchikina/Dropbox
sudo chgrp agents-group /home/mchikina
sudo chgrp agents-group /home/mchikina/Dropbox
chmod g+x /home/mchikina
chmod g+x /home/mchikina/Dropbox

# Agents folder: full group read/write/execute, no world permissions
sudo chgrp -R agents-group /home/mchikina/Dropbox/Agents
sudo chmod -R g+rwx,o-rwx /home/mchikina/Dropbox/Agents
```



### Lock Down All Other Home Directories

Ensure nothing else in your home is world-readable. Run this once as a sweep:
```bash
find /home/mchikina -maxdepth 1 -type d ! -name 'mchikina' -exec chmod o-rwx {} +
```

This strips world permissions from every folder directly under your home in one command. Re-run it if you create new folders in the future.





**What this means in practice:**

| Path                                  | agent access                         |
| ------------------------------------- | ------------------------------------ |
| `/home/mchikina/`                     | Traverse only — cannot list contents |
| `/home/mchikina/Documents`, etc.      | ❌ No access                          |
| `/home/mchikina/Dropbox/`             | Traverse only — cannot list contents |
| `/home/mchikina/Dropbox/OtherFolder/` | ❌ No access                          |
| `/home/mchikina/Dropbox/Agents/`      | ✅ Full read/write                    |

------

## 6. Symlink Agents Folder into Agent's Home

Rather than having the agent navigate a long path, create a symlink in the agent's home directory:

```bash
sudo ln -s /home/mchikina/Dropbox/Agents /home/agent/workspace
```

The agent user now sees `~/agents-workspace` as a clean entry point.

------

## 7. Give Agent Access to Mambaforge Environments

Grant read and execute access to your conda  envs (no write, so the agent cannot modify them). In this case the live in `mambaforge` directory. Check your setup. 

```bash
chmod o+x /home/mchikina/mambaforge
chmod o+x /home/mchikina/mambaforge/envs
chmod -R o+rx /home/mchikina/mambaforge/envs
```

------

## 8. Configure the Agent's .bashrc

Set up conda initialisation, a custom prompt, and file coloring by editing the agent's `.bashrc` as root:

```bash
sudo nano /home/agent/.bashrc
```

Add the following:

```bash
# Initialize conda
source /home/mchikina/mambaforge/etc/profile.d/conda.sh

# Colored prompt: bright pink username, bright yellow host and path
PS1='\[\e[1;95m\]agent\[\e[0m\]@\[\e[1;93m\]\h\[\e[0m\]:\[\e[1;93m\]\w\[\e[0m\]\$ '

# Enable file/directory color highlighting
alias ls='ls --color=auto'
# go the the right directory on login
cd ~/workspace
```

------

## 9. Ensure Bash Profile Sources .bashrc

So that `--login` sessions pick up everything in `.bashrc`:

```bash
sudo bash -c 'echo "source ~/.bashrc" >> /home/agent/.bash_profile'
```

------

## 10. Verify Everything Works

Switch to the agent and run these checks:

```bash
agent

# Confirm correct user
whoami                        # should print: agent

# Confirm conda works
conda info

# Confirm workspace is accessible
ls ~/agents-workspace

# Confirm you cannot escape into personal files
ls /home/mchikina/Dropbox     # should be: Permission denied

# Confirm no ugly green background on directories
ls ~/agents-workspace
```

------

## Day-to-Day Usage

```bash
# Switch to agent (from your main user)
agent

# New project folders under Agents/ automatically inherit group permissions
# If you ever need to reset permissions on the whole folder:
sudo chmod -R g+rwx,o-rwx /home/mchikina/Dropbox/Agents
```