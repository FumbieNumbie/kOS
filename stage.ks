switch to 0.
rcs on.
breaks on.
set st to prograde.
lock steering to st.
set th to 0.
lock throttle to th.
set runmode to 0.
set ksc to latlng(-0.0972092543643722, -74.557706433623).
function fuelfunction{
	local Fmass is 0.
	for res in stage:resources{
		if res:amount>0 and res:name <> "ElectricCharge" and res:name <> "Monopropellant" {
			set Fmass to Fmass + res:amount*res:density.
		}
	}
	return Fmass.
}
set engISP to 0.
list engines in engineList.
for eng in engineList
{
  set eng:thrustlimit to 100.
  set engISP to engISP + eng:maxthrust / maxthrust * eng:isp. //average ISP For all active engines
}

// function DeorbitTime
// {
//   set myPos to ship:geoposition:lng.
//   parameter tgtPos is ksc:lng.
//   local newPos is tgtPos.
//   if  tgtPos < 0
//   {
//     set newPos to tgtPos.
//   }
//   else
//   {
//     set newPos to tgtPos.
//   }
//   if newPos > myPos
//   {
//     return newPos - myPos + 360 + 200.
//   }
//   else{
//     return newPos - myPos + 360 + 200. // plus 360 for a full circle and minus 180 for deorbiting at the right moment
//   }
// }
until runmode = 1{

	set fuelmass to fuelfunction().
	set stageDV to 9.80665*engISP * ln(ship:mass / (ship:mass - fuelmass)).
	if apoapsis > 70500{
		runpath(aponode).
		if nextnode:deltav < stageDV - 500
		{
			runpath(exenode).
		}
		else{
			delete nextnode.
		}
	}
	if ship:status = "ORBITING"
	{
		if ship:geoposition:lng <-160 and addons:tj:hasimpact = false{
			set st to retrograde.
			if vang(heading(270,0):vector,ship:facing:vector)< 20{
				set th to 1.
			}
		}
		if addons:tj:hasimpact = true{
			if addons:tj:impactpos:lng > -73{
				set th to 0.2.
			}
		}
		else{
			set th to 0.
			set st to retrograde.
			set runmode to 1.
		}
	}
	else
	{
		set st to heading(270,0).
		if vang(heading(270,0):vector,ship:facing:vector)< 20{
			if stageDV>500{
				set th to 1.
			}
			else{
				set th to 0.
				set runmode to 1.
			}
		}
	}
}
runpath("0:/land.ks").
