---
layout: post
title:  "Telekom Glasfaser with Linux with dual stack and IPv6 prefix delegation"
date:   2018-12-16 11:12:20
categories: telekom pppoe
---

Telekom Glasfaser Internet access works very well with Linux. You have to use ppp with pppoe.

First make sure you have enabled static IPs in the [Telekom Kundencenter].

The Telekom technician will install the "Glasfaser Modem". It has a external power supply and a RJ45 connector.

Connect that RJ45 to your Linux box with an ethernet cable. My interface is enp1s0f3.

The modem provides the internet access on Vlan 7, I using systemd-networkd:

{% highlight bash %}
# /etc/systemd/network/enp1s0f3.network
[Match]
Name=enp1s0f3

[Network]
VLAN=telekom
{% endhighlight %}

{% highlight bash %}
# /etc/systemd/network/telekom.netdev
[NetDev]
Name=telekom
Kind=vlan

[VLAN]
Id=7
{% endhighlight %}

install on Debian/Ubuntu the required packages:

{% highlight bash %}
apt-get install -y wide-dhcpv6-client ppp pppoe
{% endhighlight %}

to receive a IPv6 address on ppp0, you have to enable accept_ra with a ip-up.d script:
{% highlight bash %}
#!/bin/sh -e
# /etc/ppp/ip-up.d/ipv6 
PPP_IFACE="$1"
PPP_TTY="$2"
PPP_SPEED="$3"
PPP_LOCAL="$4"
PPP_REMOTE="$5"
PPP_IPPARAM="$6"

echo 2 > /proc/sys/net/ipv6/conf/$PPP_IFACE/accept_ra
{% endhighlight %}

make sure it is executable:
{% highlight bash %}
chmod +x /etc/ppp/ip-up.d/ipv6
{% endhighlight %}


The pppoe username combined: Anschlusskennung + Zugangsnummer + 0001@t-online.de

Add the combined username and the password to /etc/ppp/pap-secrects:
{% highlight bash %}
"AAAAAAAAAAAAAZZZZZZZZZZ001@t-online.de"	*	""
{% endhighlight %}

setup a new ppp peer: /etc/ppp/peers/telekom
{% highlight bash %}
user AAAAAAAAAAAAAZZZZZZZZZZ001@t-online.de

pty "/usr/sbin/pppoe -I telekom -T 80 -m 1452"

# enable Ipv6, add a static prefix for fe80:: address to ensure always get the same global v6 address
+ipv6 
ipv6 ::EE:6c:aabd,

noipdefault
defaultroute

hide-password
lcp-echo-interval 20
lcp-echo-failure 3
# Override any connect script that may have been set in /etc/ppp/options.
connect /bin/true
noauth
persist
mtu 1492

noaccomp
default-asyncmap
maxfail 30
holdoff 0
{% endhighlight %}

perhaps you want a unit file to start the internet:
{% highlight bash %}
#/etc/systemd/system/ppp@.service 
[Unit]
Description=PPP link to %I
Before=network.target

[Service]
ExecStart=/usr/sbin/pppd call %I nodetach nolog

[Install]
WantedBy=multi-user.target
{% endhighlight %}

{% highlight bash %}
systemctl enable --now ppp@telekom.service
{% endhighlight %}

make sure your IPv6 firewall works and you allow dhcpv6 requests for IPv6 PD:
{% highlight bash %}
ip6tables -A INPUT -s fe80::/10 -i ppp0 -p udp -m udp --dport 546 -m comment --comment "Allow DHCPv6" -j ACCEPT
{% endhighlight %}

use wide-dhcpv6-client to receive a IPv6 prefix for your lan via IPv6 PD:
{% highlight bash %}
# /etc/default/wide-dhcpv6-client 
INTERFACES="ppp0"
{% endhighlight %}

{% highlight bash %}
# /etc/wide-dhcpv6/dhcp6c.conf 
interface ppp0 {
	send ia-pd 8;
	
};

id-assoc pd 8 {
    prefix-interface eno1 {
        sla-len 8;
        sla-id 0;
    };
    prefix-interface eno2 {
        sla-len 8;
        sla-id 1;
    };
};

profile default
{
  information-only;
};
{% endhighlight %}

Telekom will give you a /56 network. This wide-dhcpv6-client will add a new /64 network on your eno1 and eno2 interface.
Because Telekom has a /56 network you have to add 8 bits to get a /64 for your eno1 network. (sla-len parameter).

After starting wide-dhcpv6-client the new IPv6 address will be added to your interfaces. Use radvd or dhcpd on your eno1 interface to distribute your IPv6 address to your clients. 

[Telekom Kundencenter]: https://www.telekom.de/kundencenter/startseite
