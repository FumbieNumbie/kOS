if ship:status = "PRELAUNCH"{
  set m to core:part:getmodule("kosProcessor").
  m:doevent("open terminal").
  set terminal:WIDTH to 35.
  set terminal:HEIGHT to 21.
  runpath("0:/copy.ks").
  runpath("0:/sas.ks").
}
