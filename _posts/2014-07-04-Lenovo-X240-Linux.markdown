---
layout: post
title: "Lenovo X240 with Linux"
date: 2014-07-04 08:13:39
categories: debian lenovo x240
---

The new Lenovo X240 notebook/ultrabook works great with Linux. I have installed Debian Wheezy 64bit.

After installation you should upgrade:

 * Linux kernel to 3.15 or newer
 * backport xserver-xorg-video-intel from unstable to Wheezy

You need a new kernel and a new version of the xorg Intel driver for the graphics card (HD4400).

With the new kernel and the new video driver you can use two 24" external screens:

 * connect one 24" screen to the Docking Station (DVI/DP) (Lenovo ThinkPad Pro Dock - 65W EU)
 * connect one 24" screen to the Display Port on the left side of the notebook
 * disable the internal laptop screen

The LTE/UTMS modem (Sierra Gobi5000) works with kernel 3.15 out of the box. I using Network Manager in XFCE to establish a network connection.

