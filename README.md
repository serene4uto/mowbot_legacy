# `mowbot_legacy_setup`

This repository contains the setup instructions for the legacy version of **MowBot**.

## Setting up SSH Key

Follow the steps below to generate and add an SSH key for Git access:

### 1. Generate a new SSH key

```bash
ssh-keygen -t rsa -b 4096 -C "<your_email>"
```

### 2. Start the SSH agent in the background
```bash
eval "$(ssh-agent -s)"
```

### 3. Add your SSH private key to the agent
```bash
ssh-add ~/.ssh/id_rsa
```
