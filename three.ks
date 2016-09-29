SAS on.
RCS on.
lights on.
lock throttle to 0. //Throttle is a decimal from 0.0 to 1.0
gear off.
 
clearscreen.

set tarAP to 70200.
set tarPE to 70200.
set runmode to 2. //Safety in case we start mid-flight
if ALT:RADAR < 50 { //Guess if we are waiting for take off
    set runmode to 1.
    }
 
until runmode = 0 
{
	if runmode = 1 //starting sequence
	{
		lock steering to heading(90, 90).
		SET countdown TO 3.
		PRINT "Counting down:".
		UNTIL countdown = 0 {
		PRINT "..." + countdown.
		SET countdown TO countdown - 1.
		WAIT 1. // pauses the script here for 1 second.
			}
		PRINT "Main TVAL up.  2 seconds to stabalize it.".
		LOCK TVAL TO 1.0.   // 1.0 is the max, 0.0 is idle.
		WAIT 2. // give TVAL time to adjust.
		stage.
		set runmode to 2.
		clearscreen.
	}
	
	//heading upwards
	else if runmode = 2 
	{
		LOCK STEERING TO heading(90, 90).
		if verticalspeed > 50
		{
			set runmode to 3.
			lock TVAL to 1.
		}
	}
	
	//starting gravityturn
	else if runmode = 3 
	{
		lock steering to heading(90, 80).
		wait 5.
		set runmode to 4.
	}
	else if runmode = 4
	{
		set steering to  + heading(90, 0).
		lock steering to velocity:surface.
		set runmode to 5.
	}
	
	//continuing gravityturn in orbit mode
	else if runmode = 5
	{
		if ship:altitude > 25000
		{
			lock steering to prograde.
			set runmode to 6.
		}
	}
	
	//preserving apoapsis hight at 70200
	else if runmode = 6
	{
		if ship:altitude < 65000
		{
			if (ETA:apoapsis < 45) or (ship:apoapsis < tarAP)
			{
				lock TVAL to 1.
			}
			else 
			{
				lock TVAL to 0.
			}
		}
		else
		{
			set runmode to 7.
		}
	}
	
	//circularising
	else if runmode = 7
		{
			if ship:periapsis < tarPE
			{
				if ETA:apoapsis < 20 or verticalspeed < 0
				{
					lock steering to heading(90, 5).
					lock TVAL to 1.
				}
				else
				{
					lock steering to heading(90, -10).
				}
			}
			else
			{	
				lock TVAL to 0.
				set runmode to 10.
			}
		}
	 else if runmode = 10
	{
		lock TVAL to 0.
		sas on.
		set runmode to 0.
	}
	
	//staging
	 if stage:Liquidfuel < 1 
	{ 
		lock TVAL to 0.
		wait 1.
		stage.
		wait 1.
		lock TVAL to 1.
	}
	

	set finalTVAL to TVAL.
    lock throttle to finalTVAL.
	
	print "RUNMODE:    " + runmode + "      " at (5,4).
    print "ALTITUDE:   " + round(SHIP:ALTITUDE) + "      " at (5,5).
    print "APOAPSIS:   " + round(SHIP:APOAPSIS) + "      " at (5,6).
    print "PERIAPSIS:  " + round(SHIP:PERIAPSIS) + "      " at (5,7).
    print "ETA to AP:  " + round(ETA:APOAPSIS) + "      " at (5,8).
}