


brakes on.
sas off.
rcs on.

// if addons:tr:available() = false {
//   print "Trajectories mod is broken." at(0,8).
//   wait until 1=2.
// }
clearscreen.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
runpath("0:/library/functions.ks").

CLEARVECDRAWS().
set ksc to latlng(-0.0972092543643722, -74.557706433623).

// CONTROL VARIABLES BLOCK -----------------------------------------------------


set th to 0.
set st to ship:facing.
// lock st to -velocity:surface.

// NATURAL VARIABLES BLOCK -----------------------------------------------------
set gGround to abs(ship:groundspeed)/(body:RADIUS).
set maxaGround to ship:availablethrust/ship:mass.
set maxV to sqrt(2 * 30 * maxaGround).

lock centr_acc to abs(ship:groundspeed)/(body:RADIUS+altitude).
lock downwardAcceleration to g() - centr_acc.

// SHIP VARIABLES BLOCK --------------------------------------------------------
set distance to 0.
set fuelmass to fuelfunction().
set engISP to shipISP().
set stageDV to 9.80665*engISP * ln(ship:mass / (ship:mass - fuelmass)).
set enThrust to ship:availablethrust.
lock Vv to ship:verticalspeed.
lock maxa to ship:availablethrust/ship:mass-g().
lock maxtwr to maxa/g().
lock shipLatLang to ship:geoposition.
lock surfElev to shipLatLang:terrainheight.
lock altRadar to altitude-surfElev.
lock Vel to ship:velocity:surface.
lock Vh to ship:groundspeed.
lock adv_altRadar to altitude - max(impact_geoposition:terrainheight,0.01).
lock Vtan to -sqrt(Vv^2+Vh^2).
lock impact_loc to ship:position + ship:velocity:surface * impact().
lock impact_geoposition to body:geopositionof(impact_loc).

lock impactMargin to (impact_loc-ship:position):mag.

lock steering to st.
lock throttle to th.


set s_DV to stageDV. // For calculating spent dV


set lHeights to lexicon(                              //heights at wich slope search is activated
                        "mun", 40,
                        "minmus", 30,
                        "Kerbin",60,
                        "Gilly", 20
                        ).


core:part:getmodule("kosProcessor"):doevent("open terminal").

// function BLOCK ------------------------------------------------------------------


local hover_pid is pidloop(2.7, 4.4, 0.12, 0, 1).
function hover {
  local twr is availtwr().
  parameter setpoint.
  parameter input.
  set hover_pid:setpoint to setpoint.
  set hover_pid:maxoutput to twr.
  set hover_pid:minoutput to 0.
  return min(
    hover_pid:update(time:seconds, input) /
    max(cos(vang(up:vector, ship:facing:vector)), 0.0001) /
    max(twr, 0.0001),
    1
  ).
}

// Add steering PID or other way to control steering.
set y to 0.
set p to 0.
set r to 0.
function aerocorrection
{
  if impact_geoposition:lng-ksc:lng > 0.005{
    set p to 20.
  }
  else if impact_geoposition:lng-ksc:lng < -0.005{
    set p to -20.
  }
  else{
    set p to 0.
  }
  if impact_geoposition:lat - ksc:lat > 0.005{
    set y to 20.
  }
  else if impact_geoposition:lat - ksc:lat  < -0.005{
    set y to -20.
  }
  else {
    set y to 0.
  }
  set st to (-velocity:surface):direction+r(p, y, r).

}


set startBurn to 0.
function suicide_burn{
  if altRadar>400 and Vel:mag <30
  {
    set startBurn to 0.
  }
  if 1.3 * burnDist > distance
  {
    set warp to 0.
  }
  if 1.0 * burnDist > distance
  {
    set startBurn to 1.
  }
  if startBurn = 1
  {
    print "Suicide burn.                   " at(0,19).
    print "vertical speed:                 "+ abs(Vv) at(0,17).

    set th to hover(-15,Vv).

  }
  else
  {
    set th to 0.
    print "Overburned.                   " at(0,19).
  }

}
function landing_spot{
  local target_vector is unrotate(up).

  lock st to target_vector.
  print "Searching for a landing spot. " at (0,19).
  if slope > 7{
    lock th to hover(0, Vv).
    if Vh < 10
    {
      lock target_vector to unrotate(up:vector+normal:normalized*0.5).
    }
    else
    {
      lock target_vector to up:vector.
    }
  }
  else
  {
    lock target_vector to unrotate(up:vector-velocity:surface:normalized*0.4).
    print "Slope is acceptable.             " at (0,19).
  }
}
function land{
  if Vh<2{
    lock th to hover(-3,Vv).
    set st to unrotate(up:vector-velocity:surface:normalized*0.15).
    print "Landing                      " at (0,19).
  }
    else{
      set th to hover(0,Vv).
      set st to unrotate(up:vector-velocity:surface:normalized*0.3).
      print "Killing speed               " at (0,19).
    }
    gear on.
}
until status = "landed"{



  impact().
  set slope to vang(slope(),up:vector).
  availtwr().
  if adv_altRadar > lHeights[body:name]{
    set Real_impact_time to (Vv + sqrt(Vv*Vv + 2*adv_altRadar*downwardAcceleration))/max(downwardAcceleration,0.001).
    set Real_burn_time to Vel:mag/(maxa).
    set burnDist to Vel:mag ^2 / maxa / 2 + 20.
    set distance to sqrt(adv_altRadar^2 + (Vh*Real_impact_time)^2).
    suicide_burn().
  }
  else
  {
    if slope > 7
    {
      landing_spot().
    }
    else
    {
      land().
    }
  }



  // print "StageDV                  " + round(stageDV)+"                "at(2,6).
  print "Distance to burn/altitude:   "+ round(1.0*burnDist)+" / " + round(distance)+ "  " at (2,7).
  print "Burn:                    "+ startBurn at(0,18).

  // print "Impact in:               "+ round(Real_impact_time,2) +     "              " at (2,8).
  Print "Throttle:                " + round(th, 2)+"                  " at (2,9).
  print "Impact slope:            " +  round(vang(slope(),up:vector),1) +"              "at (2,10).
  print "altitude                 " + round(adv_altRadar,1) + "        " at (2,11).
  print "Initial deltaV           "+ fuelmass + "               " at (2,12).
  // print "Impact speed:            " + round(impact_speed) + "                " at (2,21).

}


  // Print "Burn at:                     "+  +"              " at (2,10).

// FINAL BLOCK -----------------------------------------------------------------
lock steering to up.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
set fuelmass to fuelfunction().
set stageDV to 9.80665*engISP * ln(ship:mass / (ship:mass - fuelmass)).
set stageDV_left to stageDV.
clearscreen.
print "Looks landed to me." at (3,2).
Print "Used deltaV: "+ round((s_DV - stageDV_left),1) at (3,3).
wait 1.5.
sas on.
unlock steering.
clearvecdraws().
