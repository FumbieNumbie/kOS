declare parameter angle.
declare parameter distance.

clearscreen.
set done to false.
local dir is north:vector*sin(angle*constant:pi).
set waypoint1 to body:geopositionof(ship:position+dir:normalized*distance).
print waypoint1 at(5,1).

until done
{

	if round(waypoint1:distance)>500
	{
		lock wheelsteering to waypoint1.
		if velocity:surface:mag<30
		{
			set runmode to "Accelerating".
			lock wheelthrottle to 1.
			brakes off.
		}
		else
		{
			set runmode to "Too fast".
			brakes on.
			lock wheelthrottle to -1.
		}
	}
	else
	{
		set runmode to "done".
		unlock wheelsteering.
		brakes on.
		lock wheelthrottle to -1.
		wait 10.
		unlock wheelthrottle.
		print "Hmm. Should be somewhere here.".
		set done to true.

	}
	print "Going here:								" + waypoint1+ "         " at(5,1).
	print "We are here:               " + ship:geoposition + "      " at(5,2).
	print "Distance to the waypoint:  " + round(waypoint1:distance) + "      " at (5,3).
	print "Wheel throttle:            " + wheelthrottle + "      " at (5,4).
	print "Runmode:                   " + runmode + "         " at (5,5).
}
