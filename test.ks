clearscreen.
// switch to 0.

set st to ship:facing:vector.
lock steering to st.
// print vAngle.
// print newVec1 at (4,2).
// print "-------" at(4,3).
set staticDir to ship:facing.
set p to 0.
set y to 0.
set r to 0.

// set dir to ship:facing.
until false{
  // local vAngle is vang(up:vector,ship:facing:vector).
  // print vAngle at (4,5).
  // set newVec1 to v(ship:facing:vector:x * 1, ship:facing:vector:y +0.1, ship:facing:vector:z * 0.5).

  // print dir  at (4,7).
  // set st to prograde.
  print p at (4,8).
  print y at (4,9).
  print r at (4,10).
  print (-velocity:surface):direction at (4,11).
  on AG7 set p to p+5.
  on AG8 set y to y+5.
  on AG9 set r to r+5.
  // print st at (4,9).
  set st to   (-velocity:surface):direction+r(p, y, r).
  // print vang(north:vector,newVec1) at(4,9).
  // set st to dir + R(a,b,c).
}
