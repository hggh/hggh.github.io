---
layout: post
title:  "OpenHAB2 - temperature alarm via groups and a Telegram bot"
date:   2018-11-19 15:54:20
categories: openhab2
---

[OpenHAB2] is a great tool. I have a several BME280 inside my flat. They are monitoring my sleeping room, living room and my kitchen.


{% imagegallery images/openhab2-telegram %}

This is my ``items`` configuration:

{% highlight java %}
Group indoor_temperature
Number:Temperature BME280_52_Temperature "Temperatur Indoor [%.1f °C]" <temperature> (indoor_temperature) {expire="90m, 0"}
Number:Temperature BME280_54_Temperature "Temperatur Indoor [%.1f °C]" <temperature>  (indoor_temperature) {expire="90m, 0"}
{% endhighlight %}

The **idea** was to **send** me a Telegram message if the temperature is **blow** a certain **threshold**.

Since I'm a lazy guy, I do **not** like to configure a **new rule for every sensor**. That's why I build a alerting feature via groups.

The idea was that the threshold could be configured via the ``items`` file or with a input box on my sitemap.

To work with groups I had to create two new groups to group the ``Switch Item`` if the alarm is active and the threshold of every sensor:

{% highlight java %}
Group indoor_temperature_alarm
Group indoor_temperature_alarm_threshold
{% endhighlight %}

For every temperature sensor I need a Switch Item and a String Item that hold the information:
{% highlight java %}
Switch BME280_54_Temperature_Alarm "Küche Temperaturalarm" (indoor_temperature_alarm)
String BME280_54_Temperature_Alarm_Threshold "18" (indoor_temperature_alarm_threshold)
{% endhighlight %}

We have **set** the threshold for the **kitchen at 18°C**!

At first we need a rule to set the alarm switch on and off:
{% highlight java %}
rule "indoor_temperature below"
when
	Member of indoor_temperature received update
then
	var item_name_alarm = triggeringItem.name + '_Alarm'
	var item_name_alarm_threshold = item_name_alarm + '_Threshold'
	var threshold_item = indoor_temperature_alarm_threshold.members.findFirst[name.equals(item_name_alarm_threshold)]

	var QuantityType<Temperature> threshold_value = new QuantityType(threshold_item.label + "°C")

	if (triggeringItem.state < threshold_value ) {
		sendCommand(item_name_alarm, "ON")
	}
	else {
		sendCommand(item_name_alarm, "OFF")
	}
end
{% endhighlight %}

Now the state of the alarm is set to the Switch Item of every sensor. Let's now send a Telegram message:

{% highlight js %}
rule "indoor_temperature_alarm changed"
when
	Member of indoor_temperature_alarm changed
then
	var item_name = triggeringItem.name

	var item_name_of_value = item_name.substring(0, triggeringItem.name.lastIndexOf('_'))
	var temperature_Item = indoor_temperature.members.findFirst[name.equals(item_name_of_value)]

	logInfo("TemperatureAlarm", item_name)
	logInfo("TemperatureAlarm", "Item Name of the value " + item_name_of_value +  "Value:" + temperature_Item.state.toString)

	var message = ""

	if (triggeringItem.state == ON) {
		message = triggeringItem.label + ": Temperatur zu niedrig: " + temperature_Item.state.toString
	}
	else {
		message = triggeringItem.label + ": Temperatur wieder normal: " + temperature_Item.state.toString
	}

	sendTelegram("hggh", message)
end
{% endhighlight %}





[OpenHAB2]: https://openhab.org
