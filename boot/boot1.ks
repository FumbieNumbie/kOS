wait 3.
set m to core:part:getmodule("kosProcessor").
m:doevent("open terminal").
print "Secondary core".

runpath("0:/test.ks").
