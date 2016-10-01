// testing boot script

print "Alternative Boot script for comsats".
local cpu is ship:partstagged("Secondary").
for mod in cpu
{
	mod:getmodule("kOSProcessor"):deactivate().
}


until false{
  if SAS{
    sas off.
    local cpu is ship:partstagged("Secondary").
    for mod in cpu
    {
    	mod:getmodule("kOSProcessor"):activate().
    }

  }
}
