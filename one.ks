SAS off.
RCS on.
lights on.
set throttle to 0. //Throttle is a decimal from 0.0 to 1.0
gear off.
run circ_lib.



clearscreen.
set cAP to ship:apoapsis.
set dAP to 0.
set dETA to 0.
set cETA to ETA:apoapsis.
set TVAL to 0.
set dTVAL to 0.05.
set tarAP to 71000.
set tarPE to 70200.
set st to 0.
set delta to 0.
set mode to 0.
until ship:periapsis>tarPE
{
	if st = 0
	{
		lock steering to up + R(0,0,180).
		lock TVAL to 1.
		Print "Launch!".
		wait 1.
		Stage.
		clearscreen.
		set st to 1.
	}

	else if st = 1
	{
		if ship:apoapsis<tarAP
		{	
			lock TVAL to 1.
			if altitude<65000
			{
				
				lock steering to heading(90,alpha).
				if altitude <10000
				{
					lock alpha to 45+45*(1-(ship:altitude/(10000))).

					set mode to 1.
				}
				else if altitude >10000
				{
					lock alpha to max(5,45*(1-((ship:altitude-10000)/(70000)))).
					set mode to 2.
				}
			}
			else
			{
				set mode to 3.
			}
			if altitude<8000
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
	list engines in engineList.
	for eng in engineList
	if eng:flameout
	{
		stage.
		break.
	}


	set finalTVAL to TVAL.
	lock throttle to finalTVAL.
	

	
	if ship:altitude>65000
	{
		set mode to 4.
		run aponode.
		run exenode.
		set finalTVAL to TVAL.
		lock throttle to finalTVAL.
		
	}
	print "STATE:      " + st + "      " at (5,3).
	print "MODE:       " + mode + "      " at (5,4).
	print "ALTITUDE:   " + round(SHIP:ALTITUDE) + "      " at (5,5).
	print "APOAPSIS:   " + round(SHIP:APOAPSIS) + "      " at (5,6).
	print "PERIAPSIS:  " + round(SHIP:PERIAPSIS) + "      " at (5,7).
	print "ETA to AP:  " + round(ETA:APOAPSIS) + "      " at (5,8).
	set finalTVAL to TVAL.
	lock throttle to finalTVAL.
}
set ship:control:pilotmainthrottle to 0.