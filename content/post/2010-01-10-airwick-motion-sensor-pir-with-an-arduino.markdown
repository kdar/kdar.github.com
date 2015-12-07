---
tags:
- Arduino
- Electronics
- Microcontrollers
date: 2010-01-10T20:15:59Z
slug: airwick-motion-sensor-pir-with-an-arduino
status: publish
title: Airwick motion sensor PIR with an arduino
url: /2010/01/10/airwick-motion-sensor-pir-with-an-arduino/
wordpress_id: "102"
postmedia: "posts/airwickpir/postmedia.jpg"
---

I've obtained two Airwick Freshmatics from a yard sale for $2. These were used in my house for a while, but it quickly became annoying to be sprayed in the face every time.  So I decided to hook it up to my arduino for no reason whatsoever.
<!--more-->

This model seems to be an older one as I cannot find it on the internet. I'm unsure what the newer models have, but I'm pretty certain they wouldn't need to change the design. This model actuates a motor which uses gears to press down on the nozzle of the aroma can.

{{<figure src="http://farm5.static.flickr.com/4049/4264353274_2012434a9c_b.jpg" title="Airwick Freshmatic" size="1024x768" link="http://farm5.static.flickr.com/4049/4264353274_2012434a9c_b.jpg">}}

It only takes 4 philips head screws to get the backplate of it off. You'll immediately see the motor there.

{{<figure src="http://farm5.static.flickr.com/4031/4264353390_0df46bcd9d_b.jpg" title="Inside the Airwick Freshmatic" size="1024x768" link="http://farm5.static.flickr.com/4031/4264353390_0df46bcd9d_b.jpg">}}

It takes just one more screw to pop the rest of it out.

{{<figure src="http://farm3.static.flickr.com/2517/4264353508_a39311ffc0_b.jpg" title="Inside Airwick Freshmatic" size="1024x768" link="http://farm3.static.flickr.com/2517/4264353508_a39311ffc0_b.jpg">}}

Determining the functionality of the different connector pins was easy by just using a volt meter and tracing the conductive lines by eye. Here is a table of what each pin does. If you look at the picture below, pin #1 is the pin to the far left.

  1. VCC (3.3V-4V)

  2. GND

  3. LED GND

  4. GND

  5. PIR out

  6. switch 9 minutes (connects it to GND)

  7. switch 18 minutes (connects it to GND)

  8. switch 36 minutes (connects it to GND)

  9. switch off (connects it to GND)


{{<figure src="http://farm3.static.flickr.com/2733/4264353114_1a1d5aa212_b.jpg" title="Airwick PIR sensor board" size="1024x768" link="http://farm3.static.flickr.com/2733/4264353114_1a1d5aa212_b.jpg">}}

In the above picture the sensor wire (green) became disconnected when I took the photo. It's suppose to be connected to pin 5.

The above board will not run on 5V that the arduinos usually provide. The freshmatic model I had ran on 3-4V (3 AA 1.5V batteries). I hooked up the VCC to the 3.3V terminal in my [seeeduino mega](http://www.seeedstudio.com/depot/seeeduino-mega-fully-assembled-p-438.html?cPath=27). Also, the LED is driven by attaching GND to pin 3, not VCC.


#### Code


I modified the code for [PIRsense](http://www.arduino.cc/playground/Code/PIRsense) in the arduino mega.

[Here](/downloads/wp-content/uploads/2010/01/sketch_airwick_pir.pde) it is.


#### Video


[embed]http://www.youtube.com/watch?v=oFv5nxFKczU[/embed]


#### Conclusion


It's not the best motion sensor in the world, but it could be used to do a lot of things. Next Halloween, I'll probably use it to shoot silly string at unsuspecting kids. It's about the same price to buy one of these motion aroma devices than it is to buy the PIR sensor itself. Plus, you get a nice case that you can stuff electronics into, a motor, and a gear system.
