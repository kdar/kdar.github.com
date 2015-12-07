---
tags:
- AVR
- Electronics
- Microcontrollers
date: 2010-02-23T01:21:35Z
slug: repurposed-tv-b-gone-to-turn-off-benq-projector
status: publish
title: Repurposed tv-b-gone to turn off benq projector
url: /2010/02/23/repurposed-tv-b-gone-to-turn-off-benq-projector/
wordpress_id: "157"
postmedia: "posts/tvbgonebenq/postmedia.jpg"
---

At church, we have a projector that is close to the ceiling and far away from the audio/video booth. The remote control that came with the projector does not have a very far range. I have to get out of the booth and walk close to the back row and keep moving the remote until I get the projector to turn off or on. It wasn't only annoying for me, but I'm sure it was distracting for the church members.
<!--more-->

The solution to this problem is an easy one: build a more powerful remote. The first order of business was whether I would build one from scratch or if I was going to modify something else on the market. Since the IR LEDs that I wanted were out of stock at mouser (and I dislike digikey's shipping price), I decided to just buy a [tv-b-gone kit](http://www.adafruit.com/index.php?main_page=product_info&cPath=20&products_id=73&zenid=bac5d01d94a94bb0fa1075e8e3f6bdbc) from [adafruit](http://www.adafruit.com/).

This kit was simple to put together and I was able to turn off all of my TVs in no time. I took the device to church in hopes that the IR code for the projector was already programmed in, but no such luck. In order to get the code for the benq projector, I put together an arduino with an IR receiver and used the [IRremote](http://www.arcfn.com/2009/08/multi-protocol-infrared-remote-library.html) library by[ Ken Shirriff](http://www.arcfn.com/). I love the library that he created. It not only gets you the raw data for the protocol, but it also tries to determine what protocol it is. The IRremote library told me that the benq projector that I had used the NEC protocol, code B14E00FF.

Now I needed to get this code onto the tv-b-gone. I read through the [design](http://www.ladyada.net/make/tvbgone/design.html) document for the tv-b-gone, and was easily able to translate the raw IR code into the compressed tv-b-gone format.

{{<figure src="/downloads/wp-content/uploads/2010/02/IMG_0067.jpg" title="Tv-b-gone at church" size="1024x768" link="/downloads/wp-content/uploads/2010/02/IMG_0067.jpg">}}

Verdict? It worked perfectly. I didn't have to move from my seat to turn off/on the projector (in the picture, I'm hanging over the booth to get a good picture).

You may have noticed but I put the tv-b-gone inside a [Maxim](http://www.maxim-ic.com/) case I got when I ordered some samples.

{{<figure src="/downloads/wp-content/uploads/2010/02/IMG_0080.jpg" title="Maxim case" size="1024x768" link="/downloads/wp-content/uploads/2010/02/IMG_0080.jpg">}}

All I did extra was drill 4 holes and put a small pushbutton in the front of it, then solder wires to it and the button on the PCB. The battery case is stuck on the bottom with double sided sticky tape.

{{<figure src="/downloads/wp-content/uploads/2010/02/IMG_0078.jpg" title="Pushbutton on case" size="1024x768" link="/downloads/wp-content/uploads/2010/02/IMG_0078.jpg">}}

{{<figure src="/downloads/wp-content/uploads/2010/02/IMG_0079.jpg" title="Soldered to pushbutton on PCB" size="1024x768" link="/downloads/wp-content/uploads/2010/02/IMG_0079.jpg">}}


#### Code


I changed the code up a bit from the original firmware. I removed some unnecessary delays and LED blinks, and I obviously removed the rest of the TV codes. I used [AVRStudio](http://www.atmel.com/dyn/products/tools_card.asp?tool_id=2725) to write the firmware and [USBtinyISP](http://www.ladyada.net/make/usbtinyisp/index.html) to program it.

Inside the zip, I include an analysis folder which contains the IR code for my projector. "analysis/ir.txt" is the more interesting file.

[church_benq.zip](/downloads/wp-content/uploads/2010/02/church_benq.zip)
