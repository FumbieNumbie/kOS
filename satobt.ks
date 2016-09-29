if ship:apoapsis>ship:periapsis+1000
{
  run aponode.
  run RCSexenode.
  rcs on.
  toggle panels.
  set done to 0.
  clearscreen.
  until done
}
{
  set PEt to eta:apoapsis.
  set APt to eta:apoapsis.
  if ship:obt:period < 21600-1
  {

    if APt > 30
    {
    //Until kos is updated for 1.1.3 ksp//  run warpto(apt).
    print "0" at (4,4).
    }
    else
    {
      lock steering to prograde.
      wait 5.
      set ship:control:fore to 1.
      print "1" at(4,4).
    }
  }
  else if ship:obt:period > 21600+1
  {

    if PEt > 30
    {
  //    run warpto(pet).
      print "0" at (4,4).
    }
    else
    {
        lock steering to retrograde.
        wait 5.
        set ship:control:fore to 1.
        print "2" at(4,4).
    }
  }
  else
  {

    set done to 1.
    print "Done.".
  }

}
SET SHIP:CONTROL:NEUTRALIZE to True.
unlock steering.

rcs off.
sas off.
