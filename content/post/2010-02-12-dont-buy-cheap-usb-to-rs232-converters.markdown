---
tags:
- Electronics
- Tools
date: 2010-02-12T03:07:27Z
slug: dont-buy-cheap-usb-to-rs232-converters
status: publish
title: Don't buy cheap USB to RS232 converters
url: /2010/02/12/dont-buy-cheap-usb-to-rs232-converters/
wordpress_id: "115"
postmedia: "posts/cheapusbrs232/postmedia.jpg"
---

So, my girlfriend bought me a STM32F103 board to play around with that has a RS-232 serial port on it to program it. Since I haven't owned any computer in the last few years that has a serial port, I needed to get a converter.
<!--more-->

I decided to go the cheap route and grab one from [dealextreme.com](http://www.dealextreme.com/). I figured that since most of these converters contains the[ PL-2303](http://www.prolific.com.tw/eng/Products.asp?ID=59) chip that it wouldn't really matter what I got. So I decided to buy [this](http://www.dealextreme.com/details.dx/sku.24512) converter for $2.99:

{{<figure src="http://farm3.static.flickr.com/2711/4350174817_d0137a5572_o.jpg" title="Bad converter">}}

I actually bought two of them since I needed one for another development board that I had. So I hooked everything up, ran [Flash Loader Demonstrator](http://www.st.com/mcu/familiesdocs-110.html), and sure enough it didn't work. I tried all sorts of settings and speeds. At the lowest speed, I got the thing to upload once out of 20 times.

I took the adapter apart and I can  see in there some missing components. Now, this happens all the time in manufacturing and it's usually not a mistake. So it doesn't really raise a red flag as to that being the problem. I didn't really test anything with a volt meter or an oscilloscope, but my guess would be that it doesn't do the RS232 voltages properly.

Those converters ended up being a waste of money for me (luckily, not that big of a deal since they were cheap). The problem was that I still needed a converter, and what device was I going to trust?

Well, [Sparkfun](http://www.sparkfun.com/) has a good reputation so I decided to look at their [USB to RS232 converter](http://www.sparkfun.com/commerce/product_info.php?products_id=8580). It's a little more costly at $13, and it contains the same PL-2303 chip. If this converter didn't work, it would be a bigger hit since I had to pay to ship this thing. The product description mentioned it was a high quality converter. I decided to take their word for it.

{{<figure src="http://farm3.static.flickr.com/2718/4350921018_8b1b8aed24_o.jpg" title="Good converter">}}

...it worked perfectly! I could crank it up all the way to 256000 bps and it programmed the STM32 without a hitch.


#### Conclusion


So the moral of the story is don't go cheap on a USB to RS232 converter if you're going to be programming microcontrollers with it. The cheap converters may still work with other things, though. But I think the particular STM32 board that I have is pretty strict on the voltage levels that it receives.

I don't have any recommendations on other converters to use. All I can say is the one provided by Sparkfun definitely works and is worth the money.

{{<figure src="http://farm5.static.flickr.com/4040/4350236425_fd92055425_o.jpg" title="STM32F103">}}
