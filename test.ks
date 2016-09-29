wait 2.
clearscreen.
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
