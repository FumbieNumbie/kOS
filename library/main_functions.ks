function download
{
  parameter name.
  switch to 1.


  if exists("0:/"+name+"")
  {
    if exists("1:/"+name+"")
    {
      deletepath("1:/"+name+"").
    }
    copypath("0:/"+name,+"1:/").
    print "File "+ name+ " was copied to 1".
  }
  else
  {
    print "File doesn't exist on archive".
  }
}
function delay
{
  set dtime to addons:rt:delay(ship)*3.
  set acctime to 0.                     //accumulated time

  until acctime >= dtime
  {
    set start to time:seconds.
    wait until (time:seconds-start) > (dtime-acctime) or not addons:rt:hasconnection(ship).
    set acctime to acctime + time:seconds - start.
  }
}
Print "done".
