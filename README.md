# Ansible-automation 

## Let's learn about some concepts: 

### The first concept and one of the most important ones is OPEN SSH:

OPEN SSH is the default and the standard when it comes to remote administration in linux.
we use this to connect to a linux server and run cmds and configuration. and this is what ansible uses for the remote server provisioning.
for this journy we need to know what ssh is? and we need to do some basic key management.

### SSH key management makes the connections much more secure!

```bash
$ ssh-keygen -t ed25519 -C "My first ssh key"

# the -t tells what type of ssh key we want to generate.
# -C is like a meta data about the key. 
# Usually it is recomended to use passphrase for more security.

# To see SSH directory:
$ ls -la -ssh

# to see the contents of the public/private key use CAT command.
```
## How to add ssh key to a server:

```bash
$ ssh-copy-id -i ~/.ssh/id.ed25519.pub [user]@[ip-address-of-the-server]

# after this cmd to check if it's added to the servers's ssh dir you can type:

$ ls -la .ssh

# -i basically means "input file"

# To connect to your server using the key you just created and put in the target server(s):

$ ssh ~/.ssh/ansible [ip-address-of-the-server]
```

## If you have added passphrase for the ssh-key yo have created:

If you don't want to type every time you are going to ssh the server you can use SSH-Agents. 
the ssh-agent is basically a process that runs in the background and can cache your passphrase.

```bash
$ eval $(ssh-agent)

# The response would be sth like this:

$ Agent pid 2342

# To ensure that the ssh-agent is running in the background you can use the following cmd:

$ ps aux | grep 2342

# Now the following instructions are going to set the passphrase in the agent and the agent insert the passphrase for you everytime you are going to ssh to the server.

$ ssh add

# resposne:

$ Enter passphrase or /home/user/.ssh/id_23432:

# after this ssh-agent config you ca ssh to the target server with ease:). but the downside is that when you close or kill that specific terminal the agent will be shutdown.
and you are going to do the steps again! but i think that's fine because we are going to do that only once each time.

```

## Note we can use the following trick to make our own custom cmd for making the agent:

```bash

$ alias [name-of-the-custom-command]='eval $(ssh-agent) && ssh-add'

# basically with the above cmd you have built a cmds named [name-of-the-custom-command]

```

Note: but this way after you kill or close the terminal you are going to lose the alias as well!!
but don't worry what you can do for this matter is that you can use a text editor like nano for example:

```bash

# open your .bashrc file and there you can add your alias.

$ nano .bashrc

# in there you can add the following:

$ alias ssh-agent='eval $(ssh agent) && ssh-add'

```

## Chapter 1: Creating a basic inventory file

Ansible uses an inventory file (basically, a list of servers) to communicate with your servers.

Note: Ansible default port is 22.

```bash
#Create a file named hosts.ini in a test project folder:

$ mkdir test-project
$ cd test-project
$ touch hosts.ini

```
in the hosts.ini:

[example]
www.example.com

Note: 

You can also place your inventory in Ansible’s global inventory file,
/etc/ansible/hosts, and any playbook will default to that if no other
inventory is specified. However, that file requires sudo permissions and
it is usually better to maintain inventory alongside your Ansible projects.

## Running your first Ad-Hoc Ansible command:

```bash

$ ansible -i hosts.ini example -m ping -u [username]

# if it requires a SSH key the fastest way is:

$ ansible -i hosts.ini example -m ping -u [username] -k

# this way ansible asks for a password when it reaches the server, or we can set up a ssh key for seamless connection:

$ ssh-keygen -t ed25519
$ ssh-copy-id root@ipaddr

# then:

$ ansible -i hosts.ini test -m ping -u root

```
I often use commands like free -h (to see memory statistics), df -h (to see disk usage statistics),
and the like to make sure none of my servers is behaving erratically. 

```bash

$ $ ansible -i hosts.ini example -a "free -h" -u [username]

```


## Headless Windows Vagrant Server Setup

Purpose: Convert a Windows 10 machine into a dedicated, headless virtualization host for local Ansible testing, managed entirely via SSH from a macOS client.

### Phase 1: Windows Host Preparation

1- Enable Hardware Virtualization: * Ensure VT-x/AMD-V is enabled in the Windows machine's BIOS.

2- Verify via Task Manager > Performance > CPU (Virtualization: Enabled).

3- Install OpenSSH Server:

Open PowerShell as Administrator.

Run: 

```bash
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

4- Generate Host Keys: In the Administrator PowerShell window, force the SSH server to generate its internal identity keys:

```bash
ssh-keygen.exe -A
```

5- Start and Persist the Service:

```bash
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
```

### Install Virtualization Tooling

Install VirtualBox and Vagrant:

```bash
winget install Oracle.VirtualBox
winget install Hashicorp.Vagrant
```
Note: 

Mandatory Reboot: Restart the Windows laptop entirely to sync Vagrant's environmental variables with VirtualBox.

### Client Connection & Security Lockdown

1- Generate Client Keys in the first machine(where the magic of ansible happens):

```bash
ssh-keygen -t ed25519
```

2- Transfer Public Key:

```bash
ssh-copy-id windows_user@windows_ip_addr
```

3- Disable Password Authentication (The Security Layer):

SSH into the Windows machine:

```bash
 ssh duden@192.168.43.96
```

4- Open the SSH configuration file as an Administrator. In the Windows terminal, run:

```bash
powershell -Command "Start-Process notepad 'C:\ProgramData\ssh\sshd_config' -Verb RunAs"
```

Find the line #PasswordAuthentication yes, change it to PasswordAuthentication no, and remove the #. Save and close Notepad. Restart the SSH service to lock the doors:

```bash
powershell -Command "Restart-Service sshd"
```

### Provisioning the Sandbox

1- Create the Workspace:

From your first machine, SSH into the now-secured Windows host:

```bash
ssh duden@192.168.43.96
mkdir ansible-chap2
cd ansible-chap2
```

2- Initialize and Boot:

```bash
vagrant init geerlingguy/rockylinux8
vagrant up
```

3- Retrieve SSH Config for Ansible:

```bash
vagrant ssh-config
```

## Your first Ansible playbook:

Let’s create the Ansible playbook.yml file:

```bash
$ touch playbook.yml
```

and paste this in the playbook.yml:

```bash
- hosts: all
  become: yes

- tasks:
  - name: Ensure chrony (for time synchronization) is installed.
    dnf: 
     name: chrony
     state: present

  - name: Ensure chrony is running.
    service:
      name: chronyd
      state: started
      enabled: yes
    
```
