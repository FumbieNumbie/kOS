clearscreen.

function iteration{
  wait 0.05.
  set delta_per to old_per-nextnode:orbit:nextpatch:periapsis.
  set old_per to nextnode:orbit:nextpatch:periapsis.
  print "Delta Periapsis:   " + delta_per at (4,10).
  remove nextnode.
  set dT to dT + Ti.
  print dT at (4,11).
  add node(time:seconds + dT, 0, 0, 810).
  wait 0.01.
}
set flip to 0.
set dT to 50.
set Ti to 5.
set old_Ti to 5.
set old_dT to dT.
set delta_per to 0.
set old_per to 0.


add node(time:seconds+dT,0,0,0).


function flipper{
  wait 0.01.
  if old_Ti < Ti{
    set flip to flip + 1.
    print "Flipper is:  " + flip at (4,9).
    return flip.
  }
}




until flipper() > 3{

  if nextnode:orbit:transition <> "encounter"{
    remove nextnode.
    set nd to node(time:seconds+dT, 0, 0, 810).
    add nd.
    set dT to dT + 20.
    wait 0.01.
    print nextnode:orbit:transition at (4,4).

  }else
  // {
  //   if delta_per >= 0 and Ti  = 5 { //periapsis lowered while adding time
  //     set old_Ti to Ti.
  //     set Ti to 5.
  //     iteration().
  //     flipper().
  //     print "Stage -4   " at (4,5).
  //   }
  //   else if delta_per < 0 and Ti  = 5 {
  //     set old_Ti to Ti.
  //     set Ti to -4.
  //     iteration().
  //     flipper().
  //   } else if delta_per >= 0 and Ti  = -4{
  //     set old_Ti to Ti.
  //     set Ti to 5.
  //     iteration().
  //     flipper().
  //   }
  //   else if delta_per < 0 and Ti  = -4{
  //     set old_Ti to Ti.
  //     set Ti to -4.
  //     iteration().
  //     flipper().
  //   }
  //   print "Old Ti:  " + old_Ti+" " at (4,7).
  //   print "Ti:      " + Ti+" " at (4,8).
  //   print "dT:      " + dT at (4,13).
  //   print "stage 0" at (4,16).
  //   print "delta periapsis" + delta_per at (4,17).
  //
  //
  // }


  if Ti > 0 {
    if delta_per>0{
      set old_Ti to Ti.
      set Ti to 5.

      print "Stage -4   " at (4,5).
    }
    else{
      set Ti to -4.

    }
  }
  else{
    if delta_per<0{
      set old_Ti to Ti.
      set Ti to -4.

      print "Stage -3   " at (4,5).
    }
    else{
      set Ti to 5.
    }
  }
  iteration().
  flipper().
}
