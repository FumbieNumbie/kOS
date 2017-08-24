set m to core:part:getmodule("kosProcessor").
m:doevent("open terminal").

set terminal:WIDTH to 35.
set terminal:HEIGHT to 21.
if ship:status = "PRELAUNCH"{
  runpath("0:/copy.ks").
  runpath("0:/launch.ks",72,0,0).
}
wait 3.
if body:name = "kerbin"{
runpath("1:/transfer.ks").
}
