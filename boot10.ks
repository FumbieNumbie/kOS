set m to core:part:getmodule("kosProcessor").
m:doevent("open terminal").

set terminal:WIDTH to 35.
set terminal:HEIGHT to 21.
if ship:status = "PRELAUNCH"{
  RUNONCEPATH("0:/copy.ks").
  RUNONCEPATH("0:/launch.ks",80,0,0).
}
