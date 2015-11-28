---
tags:
- Programming
date: 2009-12-19T18:41:33Z
slug: open-sourcing-some-of-my-projects
status: publish
title: Open sourcing some of my projects
url: /2009/12/19/open-sourcing-some-of-my-projects/
wordpress_id: "80"
postmedia: "opensourcing.jpg"
---

There are a few projects that I worked on that I haven't yet made open source. Most of them I don't actively develop anymore. Below is a list of these projects and what they are. You can find all of my source code at [http://github.com/kdar/](http://github.com/kdar/).

#### VIOverlay


This is a C++ library that will allow you to overlay text (and possibly geometric shapes) over a video game. Right now it only supports Directx9. I have stopped development on this but in its current state it is able to overlay text. My example program that is included can overlay on World of Warcraft. It's a good learning resource to see how to do DLL injection and API overwriting using Microsoft's [detours](http://research.microsoft.com/en-us/projects/detours/) library.

[http://github.com/kdar/vioverlay](http://github.com/kdar/vioverlay)


#### PinballCheat


A program that allows you to adjust the scores in Microsoft's Space Cadet Pinball. Made in python using wxPython.

[http://github.com/kdar/pinballcheat](http://github.com/kdar/pinballcheat)


#### Quist


A program that hooks into the [Ventrilo](http://www.ventrilo.com/) VOIP client program  and adds functionality to it. Developed in C++, C#, and C++/CLI. This is a great example of a practical application of reverse engineering and DLL injection. The code isn't all that pretty. You can find more information about it here: [http://www.outroot.com/quist](http://www.outroot.com/quist).

[http://github.com/kdar/quist](http://github.com/kdar/quist)


#### CCrack


This program was designed to crack other programs. It contains some code to make it easily to find and patch areas of the target software. An example is included where it cracks the program [DialogBlocks](http://www.dialogblocks.com/). However, it targets an old version of DialogBlocks and most likely won't work anymore. This is for educational purposes only. I whole-heartily believe in purchasing software that people put a lot of work into. Programmed in C++ using wxWidgets.

[http://github.com/kdar/ccrack](http://github.com/kdar/ccrack)


#### DServ


A remote administration tool programmed in x86 intel assembly. This was mainly an exercise of learning x86 intel assembly.

[http://github.com/kdar/dserv](http://github.com/kdar/dserv)


#### Orbmon


An ncurses program to display your network bandwidth. Made in python.

[http://github.com/kdar/orbmon](http://github.com/kdar/orbmon)


#### Cwc3


This is a program which passively watches network traffic in your Warcraft3 games. It is able to ban, kick, location resolve, autorefresh, and other things. It was the first of its kind when I made it a long time ago, now there are much better programs out there (like Ghostplusplus). However, it is a great learning tool. I documented a lot of the Warcraft3 protocol.

[http://github.com/kdar/cwc3](http://github.com/kdar/cwc3)
