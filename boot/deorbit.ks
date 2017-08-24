
switch to 1.
set done to false.

until done{


  local k is 0.
  list parts in Partlist.
  for i in Partlist{
    for n in i:modules{
      if n  = "kOSProcessor"{
      set k to k+1.
    }
  }
}
  if k = 1{
    set done to true.
  }
}

lock steering to retrograde.
wait 9.
until ship:status = "SUB_ORBITAL"{
  lock throttle to 1.
}
