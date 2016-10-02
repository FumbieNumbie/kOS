//bootloader
set m to core:part:getmodule("kosProcessor").
m:doevent("open terminal").
if body = Kerbin
{
  if alt:radar < 100
  {
    set AP to 0.
    set NoKessler to 0.
    set connection to 0.
    runpath("0:/copy.ks").
    clearscreen.
    until sas
    {
      local x is 0.
      on ag1 {set x to 1. set AP to 10*AP + x.}
      on ag2 {set x to 2. set AP to 10*AP + x.}
      on ag3 {set x to 3. set AP to 10*AP + x.}
      on ag4 {set x to 4. set AP to 10*AP + x.}
      on ag5 {set x to 5. set AP to 10*AP + x.}
      on ag6 {set x to 6. set AP to 10*AP + x.}
      on ag7 {set x to 7. set AP to 10*AP + x.}
      on ag8 {set x to 8. set AP to 10*AP + x.}
      on ag9 {set x to 9. set AP to 10*AP + x.}
      on ag10 {set x to 0. set AP to 10*AP + x.}
      print "Enter altitude, km "+ AP at (1,5).
    }
    until rcs
    {
      local y is 0.
      on ag1 {set y to 1.}
      on ag10 {set y to 0.}
      print "To fight Kessler syndrom press 1. " at (1,5).
      set NoKessler to y.
    }
    until throttle > 0.9
    {
      local z is 0.
      on ag1 {set z to 1. }
      on ag10 {set z to 0. }
      print "To enable communications press 1.  "+ AP at (1,5).
      set connection to z.
    }
    if AP = 0 {set AP to 75.}
    runpath("1:/launch.ks",AP,NoKessler,connection).
  }
}
else{
  switch to 1.
}
