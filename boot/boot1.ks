if ship:status = "PRELAUNCH"{
  set m to core:part:getmodule("kosProcessor").
  m:doevent("open terminal").
  set terminal:WIDTH to 35.
  set terminal:HEIGHT to 21.
  RUNONCEPATH("0:/copy.ks").
  RUNONCEPATH("0:/launch.ks",73, 0, 0).
}
//                           ^   ^  ^
//               altitude----|   |  |
//                       no Kessler |
//                              Antenna
