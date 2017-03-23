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

//Ship's deltaV.

function ship_stats
{
  local enThrust is 0.
  local engISP is 0.
  list engines in engineList.
  for eng in engineList
  {
    set enThrust to enThrust + eng:maxthrust / max(1,maxthrust) * eng:thrust.
    lock acc to eng:thrust/mass.
    set engISP to engISP + eng:maxthrust / maxthrust * eng:isp. //avarage ISP For all engines
  }
  set fuelmass to (stage:LIQUIDFUEL+stage:oxidizer)*0.005.
  set stageDV to 9.80665*engISP * ln(ship:mass / (ship:mass - fuelmass)).
  return acc.
  return enThrust.
  return engISP.
  return stageDV.
}
function availtwr {
  return ship:availablethrust / (ship:mass * g()).
}


function HUD
{
  parameter text1.
  parameter text2.
  hudtext(text1+"|"+text2, 1, 2, 30, rgba(60,190,200,0.7),false).
}

function LOWHUD
{
  parameter text1.
  parameter text2.
  hudtext(text1+"|"+text2, 1, 2, 30, rgba(60,190,200,0.7),false).
}




function Impact
{
  set Ti to  (v0 + sqrt(v0*v0 + 2*altRadar*downwardAcceleration))/downwardAcceleration. //Impact time
  Return Ti.
}

function Real_impact_time{
  local Tir to (v0 + sqrt(v0*v0 + 2*adv_altRadar*downwardAcceleration))/downwardAcceleration.
  return Tir.
}
function Real_burn_time{
  set impact_vert_speed to abs(v0) + Ti*downwardAcceleration.
  set impact_speed to abs(ship:verticalspeed)+Sqrt(impact_vert_speed^2 + V1^2).
  set BurnT to impact_speed/(maxa).
  RETURN BurnT.
}

//Impact location prediction----------------------------------------------------
function imp_loc1
{
  Impact().
  set impact_loc to ship:position + ship:velocity:surface*Ti.
  return impact_loc.
}
//Slope in the predicted position-----------------------------------------------
function slope
{
  local east is vcrs(north:vector, up:vector).
  local a is body:geopositionof(impact_loc + 5 * north:vector).
  local b is body:geopositionof(impact_loc - 5 * north:vector + 5 * east).
  local c is body:geopositionof(impact_loc - 5 * north:vector - 5 * east).
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
  set impact_geoposition to body:geopositionof(impact_loc).
  set visual_normal to vecdraw(impact_geoposition:ALTITUDEPOSITION(impact_geoposition:TERRAINHEIGHT),
                              normal,
                              RGBA(0,150,80,0.7),"",10,true).

  return normal.
}
