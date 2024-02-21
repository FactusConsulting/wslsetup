# Introduction
Script to setup what is needed in wsl2

# Getting Started
First copy the ssh key from windows and set rights

```bash
mkdir .ssh
cp -r /mnt/c/Users/lars/.ssh ~/.
chmod 600 ~/.ssh/*
```

Then clone this repository using git+ssh and run the setup script.

TODO: move this to an ansible script instead, except that we need to install ansible first. Not sure this is worth the trouble.



he .ssh directory permissions should be 700 (drwx------).  The public key (.pub file) should be 644 (-rw-r--r--). The private key (id_rsa) on the client host, and the authorized_keys file on the server, should be 600 (-rw-------).


