Game of Life
============

This effort was the final pairing we did for the Cleveland CodeRetreat on the @Leandog boat o 16 January, 2011.

I wanted to work with @chadfowler -- to absorb rubyisms.

I also was hell-bent on getting the stupid simulation working. Tired of getting close on different exploratory fronts earlier in the day. Wanted to *brute force* a solution :-)

We succeeded!

I made a minor tweak to increase the board size and make the printing "fancier" when running from the terminal.

*SHIP IT!*

VIDEOS
======
You'll want to check out the videos, or simply run gol.rb yourself. 

[Sample Simulation](http://www.youtube.com/watch?v=vmnaOYcpPKc)

It's kinda cool to watch it in action.

* You can see clumps of 4 cells static for a while. 
* You can see blinker patterns. 
* You can see parts of the world die off.

It is quite a bit of fun to watch a board of size 50 or more in action.

FURTHER EXERCISES
=================

It would be cool to see the effect of allowing the cell "neighbors" to wrap to the other side of the board (like the old Asteroids(tm) game did). Sometimes you can watch a clump of cells move to the edge, only to perish. What if they could move past the edge, and over to the other side of the world?

What if we made a "Mercator" style projection map, or even a visual "globe," and treated the number of cells like 360 degrees of  latitude and longitude?
