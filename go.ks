declare parameter angle.
declare parameter distance.
declare parameter speed.
CLEARVECDRAWS().
clearscreen.
set done to false.
local alpha is -angle+90.
local west is vcrs(north:vector, -up:vector).
local dir is cos(alpha)*north:vector+sin(alpha)*west.


vecdraw(v(0,0,0),
        dir,
        rgba(0,100,50,0.2),
        "",
        10,
        true,
        0.05).
lock vec_angle to vang(ship:facing:vector,dir).

set waypoint1 to body:geopositionof(ship:position+dir:normalized*distance).
print waypoint1 at(5,1).

until done
{
	if round(waypoint1:distance)>50
	{
		lock wheelsteering to alpha.
		if velocity:surface:mag<speed
		{
			if vec_angle >20 and ship:verticalspeed < -speed*sin(vec_angle)
			{
				lock wheelthrottle to 0.2.
				brakes off.
				set runmode to "Accelerating slowly".
			}
			else
			{
				set runmode to "Accelerating        ".
				lock wheelthrottle to 1.
				brakes off.
			// }
		}
		else
		{
			set runmode to "Too fast               ".
			brakes on.
			lock wheelthrottle to 0.
		}
	}
	else
	{
		set runmode to "Done                  ".
		unlock wheelsteering.
		brakes on.
		lock wheelthrottle to 0.
		wait 10.
		unlock wheelthrottle.
		print "Hmm. Should be somewhere here.".
		set done to true.

	}
	print "Going here:								" + waypoint1+ "         " at(5,1).
	print "We are here:               " + ship:geoposition + "      " at(5,2).
	print "Distance to the waypoint:  " + round(waypoint1:distance) + "      " at (5,3).
	print "Wheel throttle:            " + wheelthrottle + "      " at (5,4).
	print "Vectors angle:             " + vec_angle + "         " at (5,5).
	print "Runmode:                   " + runmode + "         " at (5,6).
}
CLEARVECDRAWS().
