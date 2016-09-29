declare parameter ra.
declare parameter rp.
declare parameter a.
declare parameter e.
clearscreen.

set V to sqrt(body:mu/rp). // orbital velocity.
set vp to sqrt( (1+e)*body:mu / ((1-e)*a)). //velocity at periapsis.
set deltav to V-vp.
set x to node(time:seconds + eta:periapsis, 0, 0, deltav).
add x.
