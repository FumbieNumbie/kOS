//bootloader
set m to core:part:getmodule("kosProcessor").
m:doevent("open terminal").
if body = Kerbin
{
  if alt:radar < 100
  {
    runpath("0:/copy.ks").
    runpath("1:/launch.ks",75).
  }
}
else{
  switch to 1.
}
