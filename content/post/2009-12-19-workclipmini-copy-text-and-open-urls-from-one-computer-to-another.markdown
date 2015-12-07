---
tags:
- Programming
- Python
date: 2009-12-19T16:37:27Z
slug: workclipmini-copy-text-and-open-urls-from-one-computer-to-another
status: publish
title: Workclipmini - Copy text and open URLs from one computer to another
url: /2009/12/19/workclipmini-copy-text-and-open-urls-from-one-computer-to-another/
wordpress_id: "82"
postmedia: "posts/workclipmini/postmedia.jpg"
---

My computer setup at home involves two computers. The first computer is my quad core workhorse. I do all my programming and gaming on this machine. My second computer is my chat/fileserver machine. I use this primiarly as a backup computer and so I can talk to people while gaming or programming.
<!--more-->

The thing that annoyed me is that this machine ran linux, and flash runs horribly on that platform. So, when I was chatting with a friend and they sent me a link to a youtube video, I wouldn't want to watch it on the linux machine. Also, if I was on my main workhorse, I would sometimes want to copy text to and from my other computer. Therefore, Workclipmini was born.

Workclipmini is a pretty simple python program. When you run it, it broadcasts to the network to find other computers running Workclipmini. Then, on one machine, you highlight text and hit the global copy hotkey (ctrl+alt+c for windows/linux, ctrl+shift+c for OSX) and your text will be copied to the other computer's clipboard.

If you want to open a URL on the other computer, just select text that contains any number of URLS and hit the global URL hotkey (ctrl+alt+b for windows/linux, ctrl+shift+b for OSX). Workclipmini will use a regular expression to extract out the URLs so you do not need to worry about selecting it perfectly.

It should be noted that Workclipmini does not work well with more than two computers. I did not design it this way because my situation did not call for it. So, if you have more than two computers using Workclipmini, then the URLs will be opened on all of the computers and the text will be copied to all of the computers. I was planning on making this support multiple computers and being able to tell it where to send the URL or text, but I never got around to it.

Above all else, if you don't find this program useful, it is a fantastic example of how to do global hotkeys in python for windows, linux, and OSX.

Another thing to note is that I had to program this in python2.5 in order to get it to work with OSX. For some reason, python2.6 on OSX did not allow me to use the Carbon libraries that I needed in order to do a hotkey.


#### Source


Grab it here: [http://github.com/kdar/workclipmini](http://github.com/kdar/workclipmini)


#### Conclusion


I hope this is useful to someone. I spent a large amount of time just figuring out how to do the global hotkeys on all the systems. So, if you know someone that is struggling with that aspect, just refer them to this program.
