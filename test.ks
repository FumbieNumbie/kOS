declare parameter angle.
declare parameter distance.
declare parameter speed.
CLEARVECDRAWS().
clearscreen.
set done to false.
local west is vcrs(north:vector, -up:vector).
// local dir is (cos(angle*constant:pi/180)*north:vector+sin(angle*constant:pi/180)*west).
local dir is (ship:facing:vector).
// sin(angle)*north:vector+cos(angle)*west.

print dir.
vecdraw(v(0,0,0),
        dir,
        rgb(0,100,50),
        "",
        10,
        true,
        0.2).

 
