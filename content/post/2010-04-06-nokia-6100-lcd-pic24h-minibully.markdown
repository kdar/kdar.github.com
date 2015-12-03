---
tags:
- Electronics
- Microcontrollers
- PIC
- PIC24H
date: 2010-04-06T13:44:46Z
description: I recently bought a Nokia 6100 LCD from Ebay because I am in an LCD craze
  phase. Since I have no need for this LCD right now, I decided to port some code
  over to the [PIC24H minibully](http://www.sparkfun.com/commerce/product_info.php?products_id=9148)
  from Sparkfun.
slug: nokia-6100-lcd-pic24h-minibully
status: publish
title: Nokia 6100/6610 LCD PIC24H minibully
url: /2010/04/06/nokia-6100-lcd-pic24h-minibully/
wordpress_id: "213"
postmedia: "posts/nokia6100/postmedia.jpg"
---

I recently bought a Nokia 6100 LCD from Ebay because I am in an LCD craze phase. Since I have no need for this LCD right now, I decided to port some code over to the [PIC24H minibully](http://www.sparkfun.com/commerce/product_info.php?products_id=9148) from Sparkfun.

#### Parts

  * Nokia 6100/6610 LCD from [Ebay](http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=160369984263&ssPageName=STRK:MEWNX:IT#ht_2092wt_922) or [Sparkfun](http://www.sparkfun.com/commerce/product_info.php?products_id=8600). If the Ebay link ends up dead, use [this search link](http://shop.ebay.com/i.html?_nkw=nokia+6100+color+lcd).


  * A [minibully](http://www.sparkfun.com/commerce/product_info.php?products_id=9148) from Sparkfun. But any PIC24F/PIC24H board should do.


  * A 5V power source. The LCD requires 5V to operate properly. The minibully can only supply 3.3V. I used the [Adjustable breadboard power supply](http://www.seeedstudio.com/depot/adjustable-breadboard-power-supply-p-566.html?cPath=11) from Seeedstudio.


  * A way to program the minibully serially. I used the [USB BUB Board](http://www.moderndevice.com/products/usb-bub) from Moderndevice.


#### Pins


Here is the pin mapping I used to connect the LCD. You can change what pins the LCD uses by changing the defines (LCD_RES, LCD_DIO, LCD_SCK, LCD_CS) inside lcd.h.


Minibully  | PIC      | Function   |
:----------|:---------|:-----------|
8          | B8       | RES
9          | B9       | SDA/DIO
A2         | B0       | SCLK
A3         | B1       | CS


#### Source


The code is based on the work done by [AtomSoftTech](http://atomsoft.wordpress.com/2010/02/26/nokia-6100-lcd-code/). The person there made it for the PIC18F and I ported it to the minibully.

[nokia 6610 minibully.zip](/downloads/wp-content/uploads/2010/04/nokia-6610-minibully.zip)
