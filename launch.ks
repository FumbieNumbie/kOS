declare parameter AP.
parameter Deorbit_1st is 0.
set tarAP to AP*1000.
SAS off.
RCS off.

set throttle to 0. //Throttle is a decimal from 0.0 to 1.0
gear off.
function fairing_deploy
{
	local f is ship:partstagged("fairing").
	for mod in f
	{
	  local events is mod:getmodule("ModuleProceduralFairing"):allevents.
	  // print events.
	  for e in events
	  {
	    set event to e.

	  }
	  if event ="(callable) deploy, is KSPEvent"
	  {
	    mod:getmodule("ModuleProceduralFairing"):doevent("deploy").
	  }
	}
}

if Deorbit_1st = 1
{
	local cpu is ship:partstagged("Secondary").
	for mod in cpu
	{
		mod:getmodule("kOSProcessor"):deactivate().
	}
}

clearscreen.
set cAP to ship:apoapsis.
set dAP to 0.
set dETA to 0.
set cETA to ETA:apoapsis.
set TVAL to 0.
set dTVAL to 0.05.
set alpha to 0.
set st to 0.
set delta to 0.
set mode to 0.
until 1=0
{
	if st = 0
	{
		lock TVAL to 1.
		Print "Launch!".
		wait 1.
		list engines in engineList.
		for eng in engineList
		if eng:ignition = false
		{
			stage.
			break.
		}
		clearscreen.

		lock steering to up + R(0,0,90).
		set st to 1.
	}

	else if st = 1
	{
		if ship:apoapsis < tarAP
		{
			lock TVAL to 1.
			if altitude < 65000
			{

				lock steering to heading(90,alpha).
				if altitude < 11000
				{
					lock alpha to 45+45*(1-(ship:altitude/(11000))).

					set mode to 1.
					{
						list engines in engineList.										//this segment sets thrust limit
						set engTH to 0.																//close to optimal fot air efficiency
						for eng in engineList
						{
							if maxthrust > 1.35
							{
								set eng:thrustlimit to (1.4*9.81*ship:mass/maxthrust)*100.
								set engTH to eng:thrustlimit.
							}
						}
						print "Engine thrust is at " + round(engTH) + "%" at (5,2).
					}

				}
				else if altitude > 11000
				{
					list engines in engineList.										//turning thrust back to max
					set engTH to 0.
					for eng in engineList
					{
						set eng:thrustlimit to (2.4*9.81*ship:mass/maxthrust)*100.
					}
					lock alpha to max(5,45*(1-((ship:altitude-11000)/(70000)))).
					set mode to 2.
				}
			}
			else
			{
				set mode to 3.
			}
			if altitude < 8000
			{
				if verticalspeed > 102.9 * (1.0005^altitude)
				{
					set TVAL to TVAL - 0.05.
				}
				if verticalspeed < 102.9 * (1.0005^altitude)
				{
					set TVAL to TVAL + 0.05.
				}
			}
		}
		else
		{
			lock TVAL to 0.
		}
	}
	else if mode = 3
	{
	lock TVAL to 0.
	}

// Staging

	list engines in engineList.

	for eng in engineList

	if eng:flameout
	{
		lock TVAL to 0.
		stage.
		wait 2.
		break.
	}

	set finalTVAL to TVAL.
	lock throttle to finalTVAL.



	if ship:altitude > 65000
	{
		set mode to 4.
		for eng in engineList
		{
			set eng:thrustlimit to 100.
		}
		fairing_deploy().
		rcs on.
		break.
	}
	//print "engISP      "  + engISP +"      " at (5,3).
	print "MODE:       " + mode + "      " at (5,4).
	print "ALTITUDE:   " + round(SHIP:ALTITUDE) + "      " at (5,5).
	print "APOAPSIS:   " + round(SHIP:APOAPSIS) + "      " at (5,6).
	print "PERIAPSIS:  " + round(SHIP:PERIAPSIS) + "      " at (5,7).
	print "ETA to AP:  " + round(ETA:APOAPSIS) + "      " at (5,8).
	set finalTVAL to TVAL.
	lock throttle to finalTVAL.

}
runpath("1:/connection.ks").
if ship:periapsis < ship:apoapsis-300
{
	run circle(1).

}
if Deorbit_1st = 1
{
	local cpu is ship:partstagged("Secondary").
	for mod in cpu
	{
		mod:getmodule("kOSProcessor"):activate().
	}
}
panels on.
set ship:control:pilotmainthrottle to 0.
// runpath("0:/library/standby.ks").
