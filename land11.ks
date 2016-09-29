sas off.
rcs on.
gear on.
clearscreen.


set t0 to 0.
set th to 0.
set dth to 0.
set output to 0.
set throttle to th.
SET g TO 9.80665. //constant
set a to 0.
set steering_vector to -ship:velocity:surface.
set Ti to 0.
lock steering to -ship:velocity:surface.

lock Gr to ship:sensors:grav. // real gravity
lock v0 to abs(ship:verticalspeed).
lock maxa to maxthrust/mass.
lock shipLatLang to ship:geoposition.
lock surfElev to shipLatLang:terrainheight.
lock altRadar to altitude-surfElev.
lock v to ship:velocity:surface:mag.
// lock alpha to vang(ship:velocity,Gr).
lock alpha to ship:prograde.


lock guess_impact_time to  altRadar / (v0 +altRadar / min(sqrt(2*altRadar/(max(0.0001, Gr:mag-maxa*sin(alpha:pitch)))), 0.00001)). //Impact time
function imp_loc
{

	local vLat is 0.
	local vLng is 0.
	local distLat is 0.
	local distLng is 0.
	local here is ship:geoposition.
	local t is time:seconds.
	local dT is time:seconds - t.
	local dLat is here:lat - ship:geoposition:lat.
	local dLng is here:lng - ship:geoposition:lng.
	if dT > 0
	{

		set vLng to dLng / dT.
		set vLat to dLat / dT.
	}
  if Ti = 0
  {
    local distLng is here:lng + vLng * guess_impact_time.
    local distLat is here:lat + vLat * guess_impact_time.
  }

	set impact_loc to latlng(distLat, distLng).
	set t to time:seconds.
	set here to ship:geoposition.
	RETURN impact_loc:terrainheight.
}
set new_height to 0.

// Slope

function slope
{
	declare parameter impHeight.
	set dHeigt to 0.
	local t is time:seconds.
	wait 0.01.
	local dt is time:seconds - t.
	set prev_height to impHeight.
	if dt>0
	{
		set dHeigt to prev_height - new_height.
	}
	// return dt.
	set new_height to impHeight.
	set t to time:seconds.
  print new_height at (7,4).
	RETURN dHeigt.
}
set th1 to 0.
function BT2
{
  parameter Ti.
  set output to ((cos(alpha:pitch))*altRadar /Ti + v)/(maxa-Gr:mag).
  RETURN output.
}
set imp_height to 0.

until status = "landed"
{
  lock imp_height to imp_loc.
  set Ti to altRadar / (v0 +(altitude-imp_height) / sqrt(2*(altitude-imp_height)/(max(0.0001, Gr:mag-maxa*sin(alpha:pitch))))).
  if abs(slope(imp_loc)) > 3
  {
    print "Slope is too high." at (2,3).
  }
  else
  {
    print "                                   " at (2,3).
  }
  when BT2(Ti) > Ti then
  {
    lock th to max(0, min((BT2(Ti)/ Ti), 1)).
  }
  print "Burn time:               "+ round(output,2) + "              " at (5,7).
  print "                         " + imp_height at (5,9).
  print "Impact in:               "+ round(Ti,2) +     "              " at (5,8).

//  print "V:                       "+ round(v,2) + "         " at (5,11).
  // print "maxa:                    "+ round(maxa,2) + "        " at (5,12).
  // print "Thrust:                  "+ round(th,2) + "        " at (5,13).
  // print "Alpha   "+alpha at(5,9).
  lock throttle to th.
}
lock steering to up.
clearscreen.
print "Looks landed to me." at (3,2).
wait 5.
unlock steering.
sas on.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
