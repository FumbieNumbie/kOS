declare parameter angle.
declare parameter distance.
declare parameter speed.
CLEARVECDRAWS().
clearscreen.
<<<<<<< HEAD
rcs on.
print "Deorbiting" at (5,3).
stage.
print "Staged    " at (5,3).
local ves is vessel("Minmus Explorer probe").
until false
{
  lock steering to facing+r(180,0,180).
  print "Looking back    " at (5,3).
  wait 15.
  SET ves:CONTROL:NEUTRALIZE to True.
  lock throttle to 1.
  print "Going back     " at (5,3).
}
 
=======
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
>>>>>>> edits
