---
layout: post
title:  "OpenHAB2 - solar low power BME280 wireless sensor with RFM69"
date:   2018-12-16 11:12:20
categories: openhab2
---

The idea was to create a low power wireless sensor for monitoring

 * temperature
 * humidity
 * air pressure

inside my flat without a power supply or a battery.

The last 90 days the sensor is pretty stable and uses two 3V solar panels mounted with the 3d printed case on my window (inside).

{% imagegallery images/solar-case %}

A small wire is connected to the pcb of the sensor. The wire from the solar panel is connected to a diode.
So the current can only flow from the solar panel into the super cap. After the diode there is a SuperCap (5.5V 1.5F).

{% imagegallery images/solar-bme-pcb-supercap %}

 * the blue wire is the antenna of the RFM69 chip.
 * the small second pcb is the breakout board of the BME280.
 * the supercap (buttom) is connected via the two wires to the pcb.
 * the white connector (top) is the connection to the solar panel on the window

No voltage regulator is used - the Amtel 328P-AU is running on 1MHZ and BOD is disabled.

{% imagegallery images/solar-bme-voltage-grafana %}

The sensor reads the BME280 every 30 minutes and sends the values via RFM96 to the gateway. The gateway sends it via serial console into OpenHAB2.

To monitor the voltage, the sensor reads every hour the voltage from the supercap and sends it to OpenHAB2. 

After sunset the power from the supercap is used. Also the device stays stable if there is no sunlight at all for three days.

Source code/pcb/stl is located at Github: [https://github.com/hggh/indoor-atmel-328-bme280]

A CR2032 battery can also be used. I used it to test the sensor before switching to solar panels. I have now two solar powered sensors.



[https://github.com/hggh/indoor-atmel-328-bme280]: https://github.com/hggh/indoor-atmel-328-bme280

