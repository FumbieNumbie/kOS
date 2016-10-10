// NATURAL VARIABLES BLOCK -----------------------------------------------------

SET g TO body:MU / (ship:altitude+body:RADIUS)^2.
set a to 0.


lock centr_acc to abs(ship:groundspeed)/(body:RADIUS+altitude).
lock downwardAcceleration to g - centr_acc.


// SHIP VARIABLES BLOCK --------------------------------------------------------
set th to 0.
set v0 to 0.
lock v0 to ship:verticalspeed.
lock steering to -ship:velocity:surface.
lock v1 to abs(ship:groundspeed).
lock maxa to maxthrust/mass.
lock maxtwr to maxa/g.
lock shipLatLang to ship:geoposition.
lock surfElev to shipLatLang:terrainheight.
lock altRadar to altitude-surfElev.
lock v to ship:velocity:surface:mag.



// FUNCTION BLOCK --------------------------------------------------------------

//Ship's deltaV.
FUNCTION SHIP_DELTAV
{
  LIST ENGINES IN shipEngines.
  SET dryMass TO SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
  RETURN shipEngines[0]:ISP * 9.80665 * LN(SHIP:MASS / dryMass).
}
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
  set stageDV to g*engISP * ln(ship:mass / (ship:mass - fuelmass)).
  return acc.
  return enThrust.
  return engISP.
  return stageDV.
}

function HUD
{
  parameter text1.
  parameter text2.
  hudtext(text1+"|"+text2, 1, 2, 30, rgba(60,190,200,0.7),false).
}

function Impact
{
  set Ti to  (v0 + sqrt(v0*v0 + 2*altRadar*downwardAcceleration))/downwardAcceleration. //Impact time
  set impact_vert_speed to abs(v0) + Ti*downwardAcceleration.
  set impact_speed to Sqrt(impact_vert_speed * impact_vert_speed + V1 * V1).
  set BurnT to impact_speed/(maxa).
  RETURN BurnT.
  Return Ti.
}

function imp_loc1
{
  Impact().
  set impact_loc to ship:position + ship:velocity:surface*Ti.
  return impact_loc.
}

function LOWHUD
{
  parameter text1.
  parameter text2.
  hudtext(text1+"/"+text2, 1, 2, 30, rgba(60,190,200,0.7),false).
}

function hover_pid
{
  parameter setpoint.
  set pid to pidloop(2.7, 4.4, 0.12, 0, 1).
  set pid:setpoint to setpoint.
}

function pr_slope
{
  local east is vcrs(north:vector, up:vector).
  local a is body:geopositionof(impact_loc + 5 * north:vector).
  local b is body:geopositionof(impact_loc - 5 * north:vector + 5 * east).
  local c is body:geopositionof(impact_loc - 5 * north:vector - 5 * east).


  local a_vec is a:altitudeposition(a:terrainheight).
  local b_vec is b:altitudeposition(b:terrainheight).
  local c_vec is c:altitudeposition(c:terrainheight).

  return vcrs(c_vec - a_vec, b_vec - a_vec).

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
  set visual_normal to vecdraw(impact_loc:geoposition:ALTITUDEPOSITION(impact_loc:geoposition:TERRAINHEIGHT),
                              normal,
                              green,"",10,true).
  lock angle to vang(normal,up:vector).

  return angle.
}


function slope
{
  local east is vcrs(north:vector, up:vector).
  local a is body:geopositionof(ship:position + 5 * north:vector).
  local b is body:geopositionof(ship:position - 5 * north:vector + 5 * east).
  local c is body:geopositionof(ship:position - 5 * north:vector - 5 * east).


  local a_vec is a:altitudeposition(a:terrainheight).
  local b_vec is b:altitudeposition(b:terrainheight).
  local c_vec is c:altitudeposition(c:terrainheight).

  // return vcrs(c_vec - a_vec, b_vec - a_vec).

  // set a_draw to vecdraw(a_vec,
  //                 up:vector,
  //                 red,"",1,true).
  // set b_draw to vecdraw(b_vec,
  //                 up:vector,
  //                 red,"",1,true).
  // set c_draw to vecdraw(c_vec,
  //                 up:vector,
  //                 red,"",1,true).
  set normal to vcrs(c_vec - a_vec, b_vec - a_vec).
  // set visual_normal to vecdraw(ship:geoposition:ALTITUDEPOSITION(ship:geoposition:TERRAINHEIGHT),
  //                             normal,
  //                             green,"",10,true).
  lock angle to vang(normal,up:vector).

  return angle.
}
