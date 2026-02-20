# Ansible-automation 

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
