---
layout: post
title:  "Command line tools, DFHack, late git branching"
date:   2014-09-10 16:48:17
categories: September Update
---
The latest:

Simple Command line tools are the future. A great one I just discovered
is ruby-podcast. Just a simple tool to generate a podcast url from a directory of mp3s. Am using it to 
generate my podcast rss feed. Also, I have finally given up on manually updating my blog, in favor of jekyll,
another great simple command line tool to manually generate my site. At a certain point you graduate 
from the manual html + shell scripts, obviously, but I feel like writing your own blog engine is a 
disaster. Just use nginx and static content! I'm working on converting my old posts to Jekyll.

Also, lately I've been hacking on [dfhack][dfhack], a wonderful add-on tool for Dwarf Fortress. Turns out there
are lots of amazing open source plugins for it, and I'll write some posts about those. You can
write plugins in C++, Ruby and Lua, and I've written a few in each, to enhance Dwarf Fortress
gameplay. I am working on getting those changes upstream.

I've also started using a process for git branching that works for me.
Creating topic branches before I've done any work doesn't work for me. Or at least, immediately
creating a branch for each new feature doesn't work with my brain. Lately I've opted for
having a local branch for all my changes, and only creating branches when I'm ready for
those changes to be turned into pull requests. Having a personal branch for this is 
amazing, because it allows you to make commits, revert, mess around and do whatever
you want. Only once you're ready to make a pull request do you pull your changes into a 
clean branch. That way you are only managing one personal branch, and just creating
throwaway branches when you are ready to submit a pull request. So far it's worked wonders.


[dfhack]:      https://github.com/dfhack/dfhack
