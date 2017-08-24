clearscreen.

set flip to 0.
set dT to 50.
set Ti to 5.
set old_Ti to 5.
set old_dT to dT.
set delta_per to 0.
set old_per to 0.
set deltaV to 810.
set ddv to 10.
function nd{
  parameter t is 0.
  parameter dV is 0.
  add node(time:seconds+t, 0, 0, dV).
}
function iteration{
  wait 0.01.
  set delta_per to old_per-nextnode:orbit:nextpatch:periapsis.
  set old_per to nextnode:orbit:nextpatch:periapsis.
  remove nextnode.
  set dT to dT + Ti.
  print dT at (4,11).
  nd(dT, deltaV).
  wait 0.01.
}

set done to false.
nd(dT, 810).
until done{
  if nextnode:orbit:transition <> "encounter"{
    if dT < orbit:period{
      remove nextnode.
      nd(dT, deltaV).
      set dT to dT + 20.
      wait 0.01.
      print "Next trajectory state: " + nextnode:orbit:transition at (4,4).
    } else {
      set deltaV to deltaV + ddv.
      set dT to 50.
    }
  }
  else {
    if nextnode:orbit:nextpatch:periapsis>300000 or nextnode:orbit:nextpatch:periapsis<nextnode:orbit:nextpatch:body:radius+20000{
      set ddv to 5.
      set old_Ti to Ti.
      set Ti to 2.
      print "Periapsis after transfer:   " + nextnode:orbit:nextpatch:periapsis at (4,10).
      iteration().
    }
  else {
    set done to true.
    print "Periapsis after transfer:   " + nextnode:orbit:nextpatch:periapsis at (4,10).
  }
}
}
runpath("/exenode.ks").
lock throttle to 0.
runpath("1:/warpfor.ks",orbit:nextpatcheta).
wait 10.
lock steering to prograde+r(0,-90,0).
wait 10.
lock throttle to 0.1.
wait until periapsis < 14000.
unlock steering.
unlock throttle.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
// runpath("1:/circle.ks", 0).
