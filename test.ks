clearscreen.
rcs on.
print "Deorbiting" at (5,3).
stage.
print "Staged    " at (5,3).


print "Looking back    " at (5,3).

wait 2.
set ship:CONTROL:yaw to 1.
wait 5.
set ship:CONTROL:yaw to 0.
set ship:control:pilotmainthrottle to 1.
