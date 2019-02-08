This is a fork of the DNSChef project v0.2.1 hosted at: http://thesprawl.org/projects/dnschef/

## Overview

DNSChef is a highly configurable DNS proxy for Penetration Testers and Malware Analysts. A DNS proxy (aka "Fake DNS") is a tool used for application network traffic analysis among other uses. For example, a DNS proxy can be used to fake requests for "badguy.com" to point to a local machine for termination or interception instead of a real host somewhere on the Internet.

There are several DNS Proxies out there. Most will simply point all DNS queries a single IP address or implement only rudimentary filtering. DNSChef was developed as part of a penetration test where there was a need for a more configurable system. As a result, DNSChef is cross-platform application capable of forging responses based on inclusive and exclusive domain lists, supporting multiple DNS record types, matching domains with wildcards, proxying true responses for nonmatching domains, defining external configuration files, IPv6 and many other features. You can find detailed explanation of each of the features and suggested uses below.

The use of DNS Proxy is recommended in situations where it is not possible to force an application to use some other proxy server directly. For example, some mobile applications completely ignore OS HTTP Proxy settings. In these cases, the use of a DNS proxy server such as DNSChef will allow you to trick that application into forwarding connections to the desired destination.

Version 0.3 introduces support for more DNS record types, DNSSEC, logging, more configurable remote nameservers, support for the updated dnslib library and several bug fixes.

Version 0.2 introduces IPv6 support, large number of new DNS record types, custom ports and other frequently requested features.

## Table of Contents

- Setting up a DNS Proxy
- Installing DNSChef
  - Docker
  - Service
- FAQ

## Setting up a DNS Proxy

Before you can start using DNSChef, you must configure your machine to use a DNS nameserver with the tool running on it. You have several options based on the operating system you are going to use:

- *Linux* - Edit /etc/resolv.conf to include a line on the very top with your traffic analysis host (e.g add "nameserver 127.0.0.1" if you are running locally). Alternatively, you can add a DNS server address using tools such as Network Manager. Inside the Network Manager open IPv4 Settings, select Automatic (DHCP) addresses only or Manual from the Method drop down box and edit DNS Servers text box to include an IP address with DNSChef running.
- *Windows* - Select Network Connections from the Control Panel. Next select one of the connections (e.g. "Local Area Connection"), right-click on it and select properties. From within a newly appearing dialog box, select Internet Protocol (TCP/IP) and click on properties. At last select Use the following DNS server addresses radio button and enter the IP address with DNSChef running. For example, if running locally enter 127.0.0.1.
- *OS X* - Open System Preferences and click on the Network icon. Select the active interface and fill in the DNS Server field. If you are using Airport then you will have to click on Advanced... button and edit DNS servers from there. Alternatively, you can edit /etc/resolv.conf and add a fake nameserver to the very top there (e.g "nameserver 127.0.0.1").
- *iOS* - Open Settings and select General. Next select on Wi-Fi and click on a blue arrow to the right of an active Access Point from the list. Edit DNS entry to point to the host with DNSChef running. Make sure you have disabled Cellular interface (if available).
- *Android* - Open Settings and select Wireless and network. Click on Wi-Fi settings and select Advanced after pressing the Options button on the phone. Enable Use static IP checkbox and configure a custom DNS server.

If you do not have the ability to modify device's DNS settings manually, then you still have several options involving techniques such as ARP Spoofing, Rogue DHCP and other creative methods.

At last you need to configure a fake service where DNSChef will point all of the requests. For example, if you are trying to intercept web traffic, you must bring up either a separate web server running on port 80 or set up a web proxy (e.g. Burp) to intercept traffic. DNSChef will point queries to your proxy/server host with properly configured services.

## Installing DNSChef

DNSChef can be installed in a few ways. Because we live in a modern age it's possible to install DNSChef as a Docker container.
It's also possible to install it as a service. This is handy for Linux systems.

### Docker

To install DNSChef with a docker container use the following command:

```bash
docker build -f docker/alpine.dnschef.Dockerfile --tag dnschef:latest .
docker run --detach --restart unless-stopped --name dnschef dnschef:latest <optional params>
```

It is recommended to give the docker container a static ip, as this will ensure you only need to configure your system once.

```bash
docker network create --subnet=172.10.0.0/24 dnschef
docker run --net dnschef --ip 172.10.0.10 --detach --restart unless-stopped --name dnschef dnschef:latest <optional params>
```

### Service

To install DNSChef as a service execute the install script as super user.

```bash
sudo ./install.sh
```

The script will install DNSChef in `/opt` and use the settings from `chef.ini`
You can change the `chef.ini` file at `/opt/dnschef/chef.ini`
After changing the file you should restart the DNSChef service

```bash
sudo systemctl restart dnschef.service
```

## FAQ

I cant use DNSChef on Linux, because port 53 is already used by systemd-resolved.
- You can disable the service by using:
    ```bash
    sudo systemctl disable systemd-resolved.service && sudo systemctl stop systemd-resolved.service
    ```
