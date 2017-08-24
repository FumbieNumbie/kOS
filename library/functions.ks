// NATURAL VARIABLES BLOCK -----------------------------------------------------

function g{
  return body:MU / (ship:altitude+body:RADIUS)^2.
}

set a to 0.


lock centr_acc to abs(ship:groundspeed)/(body:RADIUS+altitude).
lock downwardAcceleration to g() - centr_acc.


// SHIP VARIABLES BLOCK --------------------------------------------------------
set th to 0.
set v0 to 0.
lock v0 to ship:verticalspeed.
lock v1 to abs(ship:groundspeed).
lock maxa to ship:availablethrust/mass.
lock maxtwr to maxa/g().
lock shipLatLang to ship:geoposition.
lock surfElev to shipLatLang:terrainheight.
lock altRadar to altitude-surfElev.
lock v to ship:velocity:surface:mag.



// FUNCTION BLOCK --------------------------------------------------------------

function unrotate {
  parameter vec. if vec:typename <> "Vector" set vec to vec:vector.
  return lookdirup(vec, ship:facing:topvector).
}

function fuelfunction{
	local Fmass is 0.
	for res in stage:resources{
		if res:amount>0 and res:name <> "ElectricCharge" and res:name <> "Monopropellant" {
			set Fmass to Fmass + res:amount*res:density.
		}
	}
	return Fmass.
}

function shipISP
{
  local enThrust is 0.
  local engISP is 0.
  list engines in engineList.
  for eng in engineList
  {
    set engISP to engISP + eng:maxthrust / maxthrust * eng:isp. //avarage ISP For all engines
  }
  return engISP.
}

function availtwr {
  return ship:availablethrust / ship:mass / g().
}


function Impact
{
  Return  (v0 + sqrt(v0*v0 + 2*altRadar*downwardAcceleration))/downwardAcceleration. //Impact time
}


lock Real_impact_time to (v0 + sqrt(v0*v0 + 2*adv_altRadar*downwardAcceleration))/downwardAcceleration.

lock Real_burn_time to v/(maxa).

lock burnDist to Real_burn_time*maxa. // Maximum distance that will be covered while burning.


//Impact location prediction----------------------------------------------------
// set impact_loc to ship:position.
// set impact_geoposition to body:geopositionof(impact_loc).
// if altRadar>20
// {
//
//   if ADDONS:TR:AVAILABLE
//   {
//     lock impact_loc to addons:tr:impactpos:position.
//     lock impact_geoposition to addons:tr:impactpos.
//   }
// }
// else{

// }


//Slope in the predicted position-----------------------------------------------
function slope
{
  local east is vcrs(north:vector, up:vector).
  local a is body:geopositionof(impact_loc + 7 * north:vector).
  local b is body:geopositionof(impact_loc - 7 * north:vector + 7 * east).
  local c is body:geopositionof(impact_loc - 7 * north:vector - 7 * east).
  local a_vec is a:altitudeposition(a:terrainheight).
  local b_vec is b:altitudeposition(b:terrainheight).
  local c_vec is c:altitudeposition(c:terrainheight).


  set a_draw to vecdraw(a_vec,
                        up:vector,
                        red,"",1,true).
  set b_draw to vecdraw(b_vec,
                        up:vector,
                        red,"",1,true).
  set c_draw to vecdraw(c_vec,
                        up:vector,
                        red,"",1,true).
  set normal to vcrs(c_vec - a_vec, b_vec - a_vec).

  set visual_normal to vecdraw(impact_geoposition:ALTITUDEPOSITION(impact_geoposition:TERRAINHEIGHT),
                              normal,
                              RGBA(0,150,80,0.7),"",10,true).

  return normal.
}
