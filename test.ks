wait 2.
clearscreen.
rcs on.
print "Deorbiting" at (5,3).
stage.
print "Staged    " at (5,3).
local ves is ship.
SET ves:CONTROL:yaw TO 1.
print "Looking back    " at (5,3).
wait 15.
SET ves:CONTROL:NEUTRALIZE to True.
lock steering to facing.
until false
{
  lock throttle to 1.
  print "Going back     " at (5,3).
}
