declare parameter ra.
declare parameter rp.
declare parameter a.
declare parameter e.
clearscreen.
set V to sqrt(body:mu/ra).					//orbital velocity
set va to sqrt(((1-e)*body:mu)/((1+e)*a)). // velocity at apoapsis
set deltav to V - va.
set x to node(time:seconds + eta:apoapsis, 0, 0, deltav).
add x.

print "Circular velocity = " + V.
