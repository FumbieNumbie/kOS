sas off.
rcs on.
gear on.
clearscreen.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
runpath("0:/library/functions.ks").

CLEARVECDRAWS().

// CONTROL VARIABLES BLOCK -----------------------------------------------------


set th to 0.

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

ship_stats().
set s_DV to stageDV.

// FUNCTION BLOCK --------------------------------------------------------------
// function ship_stats
// {
//   local enThrust is 0.
//   local engISP is 0.
//   list engines in engineList.
//   for eng in engineList
//   {
//     set enThrust to enThrust + eng:maxthrust / max(1,maxthrust) * eng:thrust.
//     lock acc to eng:thrust/mass.
//     set engISP to engISP + eng:maxthrust / maxthrust * eng:isp. //avarage ISP For all engines
//   }
//   set fuelmass to (stage:LIQUIDFUEL+stage:oxidizer)*0.005.
//   set stageDV to g*engISP * ln(ship:mass / (ship:mass - fuelmass)).
//   return acc.
//   return enThrust.
//   return engISP.
//   return stageDV.
// }
// function unrotate {
//   parameter v. if v:typename <> "Vector" set v to v:vector.
//   return lookdirup(v, ship:facing:topvector).
// }
// function Impact
// {
//   set Ti to  (v0 + sqrt(v0*v0 + 2*altRadar*downwardAcceleration))/downwardAcceleration. //Impact time
//   set impact_vert_speed to abs(v0) + Ti*downwardAcceleration.
//   set impact_speed to Sqrt(impact_vert_speed * impact_vert_speed + V1 * V1).
//   set BurnT to impact_speed/(maxa).
//   RETURN BurnT.
//   Return Ti.
// }
// function imp_loc1
// {
//   Impact().
//
//   set impact_loc to body:geopositionof(positionat(ship,time:seconds+Ti)).
//
//   return impact_loc.
// }
//
//
// function slope
// {
//   local east is vcrs(north:vector, up:vector).
//   local a is body:geopositionof(impact_loc:position + 5 * north:vector).
//   local b is body:geopositionof(impact_loc:position - 5 * north:vector + 5 * east).
//   local c is body:geopositionof(impact_loc:position - 5 * north:vector - 5 * east).
//
//
//   local a_vec is a:altitudeposition(a:terrainheight).
//   local b_vec is b:altitudeposition(b:terrainheight).
//   local c_vec is c:altitudeposition(c:terrainheight).
//
//   // return vcrs(c_vec - a_vec, b_vec - a_vec).
//
//   set a_draw to vecdraw(a_vec,
//                   up:vector,
//                   red,"",1,true).
//   set b_draw to vecdraw(b_vec,
//                   up:vector,
//                   red,"",1,true).
//   set c_draw to vecdraw(c_vec,
//                   up:vector,
//                   red,"",1,true).
//   set normal to vcrs(c_vec - a_vec, b_vec - a_vec).
//   set visual_normal to vecdraw(impact_loc:ALTITUDEPOSITION(impact_loc:TERRAINHEIGHT),
//                               normal,
//                               green,"",10,true).
//   lock angle to vang(normal,up:vector).
//
//   return angle.
// }


core:part:getmodule("kosProcessor"):doevent("open terminal").

// lOOP BLOCK ------------------------------------------------------------------



until status = "landed"
{
  impact().
  imp_loc1().
  slope().
  // Print "Now I'm here              " at (5,15).
  set adv_altRadar to altitude - body:geopositionof(imp_loc1()):terrainheight.
  on ag5 {lock steering to up.}
  on ag4 {lock steering to -ship:velocity:surface.}
  if V0<0
  {
    if adv_altRadar > 500
    {

      if BurnT/Ti > 1
      {

        lock th to max(0, min((BurnT/ Ti), 1)).

      }
      else
      {
        lock th to 0.
      }

    }
    if adv_altRadar < 500
    {
      if ship:groundspeed > 5
      {
        lock th to max(0, min((BurnT/ Ti), 1)).
      }
      else
      {
        hover_pid(-15).
        lock th to min(pid:update(time:seconds, ship:verticalspeed) / cos(vang(up:vector, ship:facing:forevector)),1).
      }
      wait 0.1.
      print "<500                        " at (5,15).
    }
    if adv_altRadar < 40
    {
      if slope() > 5
      {
        hover_pid(0).
        lock th to min(pid:update(time:seconds, ship:verticalspeed) / cos(vang(up:vector, ship:facing:forevector)),1).
        lock steering to lookdirup(up:vector * g + normal-velocity:surface:normalized, ship:facing:topvector).
        wait 0.1.
        print cos(vang(up:vector, ship:facing:forevector)) at (5,16).
        print pid:output at (5,17).
        print th at (5,18).
      }
      else
      {
        if ship:groundspeed > 5
        {
          hover_pid(0).
          lock steering to up:vector-ship:velocity:surface:normalized.
        }
        else
        {
          hover_pid(-1).
          lock steering to up:vector-ship:velocity:surface:normalized/4.
        }
        lock th to min(pid:update(time:seconds, ship:verticalspeed) / cos(vang(up:vector, ship:facing:forevector)),1).
        print "<40 - 2                              " at (5,15).
      }
    }
  }



  print "Burn time:               "+ round(BurnT,2) + "              " at (5,7).
  print "Impact in:               "+ round(Ti,2) +     "              " at (5,8).
  Print "Throttle:                " + round(th, 2)+"                  " at (5,9).
  print "Impact slope:            " +  round(slope(),1) +"              "at (5,10).
  // Print "Burn at:                     "+  +"              " at (5,10).
  LOWHUD(round(BurnT),round(Ti)).


  // print "Proportional:            "+ round(P,4) + "         " at (5,11).
  // print "Derivative:              "+ round(D,4) + "         " at (5,12).
  // print "Integral:                "+ round(I,4) + "         " at (5,13).
  // print "PID:                     "+ round(k,4) + "        " at (5,14).
  // print maxa at(5,15).
  // print "Thrust:                  "+ round(th,2) + "        " at (5,13).

  lock throttle to th.
}
// FINAL BLOCK -----------------------------------------------------------------
lock steering to up.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
ship_stats().
set fuelmass to (stage:LIQUIDFUEL+stage:oxidizer)*0.005.
set stageDV_left to stageDV.
clearscreen.
print "Looks landed to me." at (3,2).
Print "Used deltaV: "+ round((s_DV - stageDV_left),1) at (3,3).

sas on.
unlock steering.
clearvecdraws().
