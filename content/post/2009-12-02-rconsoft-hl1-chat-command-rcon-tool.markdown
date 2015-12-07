---
tags:
- Programming
- Python
- counter-strike
- half-life
- rcon
date: 2009-12-02T20:31:25Z
slug: rconsoft-hl1-chat-command-rcon-tool
status: publish
title: Rconsoft - HL1 chat command rcon tool
url: /2009/12/02/rconsoft-hl1-chat-command-rcon-tool/
wordpress_id: "33"
postmedia: "posts/rconsoft/postmedia.png"
---

A long time ago (a few years), I used to play a lot of counter-strike with a few friends. We used to do a lot of scrimmages and matches (cal-m). One thing we were tired of was having to find a scrim via IRC. My brilliant friend, James, decided to make a tool that would automatically find scrims for us.
<!--more-->

He didn't just do that, but he made it so you could type commands inside the game chat and have the bot/program do what he wanted. It did other things as well, like getting the CAL info of the players, restarting the round, doing lo3, etc...

Around this time I started getting into python and decided to remake his rcon.pl (yes, it was perl). I turned it into what is now known as rconsoft, with a pluggable architecture and more features.


#### What it does


The program allows you to type commands in the half-life/counter-strike chat. You can do stuff like .lo3 and have the server do the live on three sequence, .k <player> and kick the player from the server, or .id <player> and get the player's league information.


#### How it works


In the HL rcon protocol there is something called logaddress. This allows you to add an ip/port to the log address list, and the real-time server log will be sent to this ip/port via UDP. Here are a few examples of what is sent:


  * Player chat. Both global and team.

  * Bomb drop/pickup.

  * Player damage.

  * Player kill and with what weapon.

  * Round over/win/restart.

  * etc...


So, what rconsoft does is log into the rcon of the server, set up the logaddress, and receive this log information. Since you can see chat text, it is trivial to have your program respond to commands in the chat. So you can type something like ".lo3", and rconsoft will do the live on three sequence. All without having to minimize your game!


#### Features


  * Rconsoft was built with plugins in mind. All the commands that rconsoft supports are implemented in these plugins. The plugins are also very simple.

  * There is a central configuration file where you can configure rconsoft.

  * A tiered user system. You can restrict access to rconsoft's different commands. If you're a higher level user, you can use the higher level functions. Users are identified by their steamid.

  * Contains an IRC bot to automatically find scrims for you. It will not only find scrims, but it will  generate a random password and send the server information to the challenger.

  * Can do steamid checking (such as what leagues they're in).

  * Can do location checking. Find out why the players have such high ping by finding where they live.

  * Find out the rates of the players. Such as cl_updaterate and rate. This way, you can kick them if they're trying to lag on purpose.

  * A good amount of commands built in. Check out the commands below.


There may be more features, but this list was compiled off the top of my head. The feature list was going to grow as James and I had a lot of ideas for it (like score tracking). However, I no longer play counter-strike anymore so I don't have an interest in expanding it.


#### Commands


You can look in the plugins directory and in the corresponding source files to find the commands rconsoft supports. I never got around to making a help system. All these commands are typed in the chat with the prefix ".".

Command                  | Function                                                                     |
-------------------------|------------------------------------------------------------------------------|
  r, rr                  | restart round
  map, changelevel       | change the map
  say, hsay              | make the server say something
  pass, password         | change the password of the server
  k, kick                | kick players based on a regexp
  rk, rkick              | reverse kick players based on a regexp
  b, ban, kb             | kick and ban players based on a regexp
  rb, rban, rkb          | reverse kick and ban players based on a regexp
  exec, execr            | execute a server side script/config
  lo3                    | do the live on three sequence
  id, idteam             | look up the id of a player or team based on a regexp
  ip2l                   | look up the location of  a player
  msg                    | message a person on IRC; this person must have messaged the bot previously
  privmsg, lmsg          | directly message a person on IRC
  find                   | start finding a scrim
  stopfind, findstop     | stop finding a scrim
  ad                     | view or modify your scrim IRC advertisement
  accept                 | accept a scrim from IRC
  rate, rateteam         | get the rate of a player or team based on a regexp



There could be more but this is what I saw from browsing the source code. I was also working on a plugin that would track the team scores and output them. I ran into some problems because of how the protocol does it.


#### Source


The source code is free for anyone to use and hack. If you decide to fork the repository and add stuff, let me know so I can marvel in your magnificence.

Get it here: [http://github.com/kdar/rconsoft](http://github.com/kdar/rconsoft).


#### Notes


I mainly ran this on ubuntu linux. It *should* work on windows but there is no guarantee.

I'm sorry if there are bugs in the program. I don't really have time to dedicate myself to fix it nor do I have a server to test it on. It worked perfectly the last time I was using it.

I'm happy to answer questions that people may have. I'll provide as much guidance as I can.
