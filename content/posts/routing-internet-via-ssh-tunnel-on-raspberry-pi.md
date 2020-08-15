---
title: Routing internet via SSH tunnel on Raspberry Pi
date: 2015-07-25 01:38:00
tags:
- linux
---

Problem overview
----------------

Recently I had the following problem. I wanted to connect to my Raspberry Pi from my laptop. For some reason WiFi dongle on the Raspberry Pi was not working properly. Moreover, I had only one slot available for the LAN connection via cable to the router, so I could connect only one device this way. I wanted to have reliable and fast internet connection on my laptop, but via WiFi it's quite slow. To sum the things up two goals were clear:

1.  to have fast and reliable internet connection on the laptop
2.  to be able to connect to Raspberry Pi via SSH in order to control it from the laptop

Enabling SSH server on Raspberry Pi
-----------------------------------

Before we proceed to the next steps, we need to enable SSH server on Raspberry Pi if we haven't done it in the past. In order to do that, we need to go through the following steps:

1.  login with the following information when prompted: username: `pi` password: `raspberry`
2.  type the following command in the terminal: `sudo raspi-config`
3.  then navigate to `ssh`
4.  hit Enter
5.  select `enable ssh server`
6.  reboot device
7.  we are done!

Sshuttle to the rescue
----------------------

I tried a few different approaches to solve described problem, but up to now the only one solution satisfies me well. I've found discussion starting with the question [How do I route my internet through a SSH tunnel?](http://askubuntu.com/questions/45075/how-do-i-route-my-internet-through-a-ssh-tunnel) In this discussion, I've read about great tool called [sshuttle](https://github.com/apenwarr/sshuttle/), which works as a poor man's VPN.

> **sshuttle** is a transparent proxy server that forwards over a SSH connection and sets up a proxy by running Python scripts on the remote server. sshuttle can be run under the following conditions:
>
> *   client machine or router is Linux-based, FreeBSD or Mac OS
> *   administrative privileges on client
> *   access to remote network via SSH
> *   no administrator privileges on remote network
> *   availability of Python on remote server

sshutle can be installed with the following command:

```
sudo apt-get install sshuttle
```

The basic command for running sshuttle with routing all traffic is:

```
sshuttle -r username@sshserver:port 0/0
```

> Upon the execution of the command, a sudo password prompt will appear and subsequently the password to SSH account. No other details will appear except for a short message and return to shell upon failure. For more status messages, run sshuttle in verbose mode with the -v flag. In this example all internet traffic except DNS is routed through the VPN. -r flag denotes the remote hostname and optional username and port that follows in the above example. 0/0 is short for 0.0.0.0/0 that represents the subnets to route over the VPN. The usage of 0/0 routes all the traffic except DNS requests to the remote server. DNS tunelling is possible with the usage of -H flag. Please read the man page (man sshuttle) for the details of options and modes under which sshuttle can run. For information about the concept and more examples, refer to the project page.

\- André Paramés on askubuntu.com

Connecting to Raspberry Pi and tunneling internet connection
------------------------------------------------------------

Luckily, all requirements were satisfied by Raspberry Pi and I could use it with sshuttle, so I've installed this software on my laptop. I've connected to my local network through WiFi. Then, I've scanned network with `nmap` to find IP of Raspberry Pi.

```
nmap -sP 192.168.1.0/24
```

My local network consists of only few devices and each of them has a description, so I could easily identify IP of the Raspberry Pi. Output looked like this:

```
Nmap scan report for livebox.home (192.168.1.1)
Host is up (0.0070s latency).
Nmap scan report for laptop-piotra-\*samsung-ultrabook\*.home (192.168.1.14)
Host is up (0.00011s latency).
Nmap scan report for pc36.home (192.168.1.17)
Host is up (0.018s latency).
Nmap done: 256 IP addresses (3 hosts up) scanned in 2.64 seconds
```

Right now, active devices in my network are: router, my laptop and Raspberry Pi, with IP: 192.168.1.17. After that, I connected to Raspberry Pi with the following command:

```
sshuttle -r pi@192.168.1.17 0/0
```

It asked me about the local password and then about the password of remote host, which is `raspberry` by default and I saw the following message:

```
Connected.
```

Everything was fine. I was connected to Raspberry Pi and I was able to access internet through it. Next, I opened another terminal window and tried to connect to Raspberry Pi via SSH. Please note, that you have to enable remote access via SSH on Raspberry Pi before you try to establish connection. When SSH is enabled, you can type the following command:

```
ssh pi@192.168.1.17
```

Then I typed correct password and I was connected!

```
Linux raspberrypi 3.18.7+ #755 PREEMPT Thu Feb 12 17:14:31 GMT 2015 armv6l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Jul 25 01:49:00 2015 from pc36.home
```

Short summary
-------------

What is surprising tunneled internet connection was fast and stable when I was accessing it through Raspberry Pi. When I was accessing internet directly through WiFi on the router it was really slow for some unknown reason. Luckily, I've achieved my goals: I've fast internet connection on the laptop and I could establish SSH connection with Raspberry Pi over local network.
