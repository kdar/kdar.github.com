---
tags:
- Arduino
- Electronics
- Microcontrollers
date: 2010-02-26T01:27:56Z
slug: speeding-up-the-sanguino-reset-time
status: publish
title: Speeding up the Sanguino reset time
url: /2010/02/26/speeding-up-the-sanguino-reset-time/
wordpress_id: "168"
postmedia: "posts/sanguinospeed/postmedia.jpg"
---

I decided to use a [Sanguino](http://sanguino.cc/) for my next project and I noticed that every time I reset it with the pushbutton, it would take around 10 seconds to start the program. I thought this was absurd since the regular Arduino doesn't take that long. I decided to dive into the bootloader firmware and find out the problem. The Sanguino version I'm dealing with is v1.4 r1.
<!--more-->

After looking at the code, I could see that it would wait for "MAX_TIME_COUNT" iterations for a response on UART. Looking at the Makefile, it was set to 8000000>>1 which is the equivalent of 4000000. So the getch() function would keep incrementing a counter and checking for a response on UART, and finally timeout when the count exceeded 4000000. Obviously, this was taking too long for my tastes.


#### Changes


In the Makefile contained in hardware/sanguino/bootloaders/atmega644p, make the following changes:


  1. Change line 21 to point to an avr-gcc that is of version 3.x.x (not needed for OSX)

  2. On line 33, change "8000000>>1" to "F_CPU>>4". Use "F_CPU>>5" if you want 0.5 seconds faster.

	3. On line 43, change "avr-gcc" to "$(CC)"


I have to explain the #1 part. The Sanguino bootloader was made to compile with the 3.x.x series of the gcc compiler. The newest versions of WinAVR and avr-gcc for osx/linux, use gcc 4.x.x. The bootloader will not compile correctly with this version. Here are some instructions on getting the 3.x.x version of avr-gcc:


  * Windows: Download [WinAVR-20060421](http://sourceforge.net/projects/winavr/files/WinAVR/20060421/). It contains avr-gcc 3.4.6

  * OSX: Type "avr-gcc-select 3" in a terminal. Be sure to change it back to "avr-gcc-select 4" when you're done compiling.

  * Linux: Download[ gcc-3.4.6](http://ftp.gnu.org/gnu/gcc/gcc-3.4.6/gcc-3.4.6.tar.gz) and apply this [patch](http://www.freebsd.org/cgi/cvsweb.cgi/~checkout~/ports/devel/avr-gcc/files/patch-  newdevices?rev=1.12;content-type=text/plain).


I only tested this on Windows, so I cannot say if the OSX and Linux solutions will work.

I also changed the ATmegaBOOT.c code to not blink the LED 3 times but to blink it once. I saved some precious milliseconds. You can do this be setting NUM_LED_FLASHES on line 77 to 1.


#### Compiling and uploading


Just run "make" in the atmega644p folder to build the hex file. If your hex file ends up being over 6KB, then you're still using gcc 4.x.x and not 3.x.x.

To upload the bootloader, I used the Arduino IDE and went to Tools > Burn Bootloader > USBtinyISP. Select whatever programmer you have. Make sure you have "Sanguino" as the selected board in Tools > Board.


#### Speed comparison


Before: ~10.5 seconds reset time

With F_CPU>>4: ~2.5 seconds reset time

With F_CPU>>5: ~2 seconds reset time


#### Conclusion


I'm unsure why the delay is so long in the Makefile. Currently, I see no ill effects from making this change. Be sure not to make the delay too low because then you won't be able to serially program the device.


#### Files


[Makefile](/downloads/wp-content/uploads/2010/02/Makefile)

[ATmegaBOOT.c](/downloads/wp-content/uploads/2010/02/ATmegaBOOT.c)
