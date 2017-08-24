// For now it burns along the velocity vector. So with really shallow trajectories there is no time to kill the speed.
// Possible solution: in funtions account for AoA.



sas off.
rcs on.
gear on.
clearscreen.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
runpath("1:/library/functions.ks").

CLEARVECDRAWS().

// CONTROL VARIABLES BLOCK -----------------------------------------------------


set th to 0.

// NATURAL VARIABLES BLOCK -----------------------------------------------------


set a to 0.


lock centr_acc to abs(ship:groundspeed)/(body:RADIUS+altitude).
lock downwardAcceleration to g() - centr_acc.


// SHIP VARIABLES BLOCK --------------------------------------------------------
set th to 0.
set Vv to 0.
local enThrust is 0.
local engISP is 0.
lock Vv to ship:verticalspeed.
lock st to -ship:velocity:surface.
lock v1 to abs(ship:groundspeed).
lock maxa to maxthrust/mass.
lock maxtwr to maxa/g().
lock shipLatLang to ship:geoposition.
lock surfElev to shipLatLang:terrainheight.
lock altRadar to altitude-surfElev.
lock Vel to ship:velocity:surface.
lock Vh to ship:groundspeed.
lock adv_altRadar to altitude - max(body:geopositionof(imp_loc1()):terrainheight,0).
lock Vtan to -sqrt(Vv^2+Vh^2).

ship_stats().
set s_DV to stageDV.

set heights to lexicon("mun", 10000,
                      "minmus", 7000,
                      "Kerbin",2500).
set Lheights to lexicon(
                        "mun", 90,
                        "minmus", 70,
                        "Kerbin",50
                      ).
if body:name = "Mun"{
  set p to 2.7.
  set i to 4.4.
  set d to 0.12.
}
if body:name = "Minmus"{
  set p to 2.7.
  set i to 4.4.
  set d to 0.12.
}
if body:name = "Kerbin"{
  set p to 2.7.
  set i to 4.4.
  set d to 0.12.
}


core:part:getmodule("kosProcessor"):doevent("open terminal").

// function BLOCK ------------------------------------------------------------------
function unrotate {
  parameter vec. if vec:typename <> "Vector" set vec to vec:vector.
  return lookdirup(vec, ship:facing:topvector).
}

local hover_pid is pidloop(p, i, d, 0, 1).
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
// set doneTimeManipulations to false.
// set timeToImpact to 0.
function suicide_burn{
  local startBurn is 0.
  if Real_burn_time()>Real_impact_time()
  {set startBurn to 1.}
  if startBurn = 1
  {
    lock th to hover(-5, Vtan).
    if Vel:mag>40{
      lock st to -Vel.
      print "Locked to -Vel                   "+ Vel:mag at(5,18).
    } else{
      lock st to unrotate(up:vector-velocity:surface:normalized*0.15).
      print "Locked to -0.15*Vel                   " at(5,18).
    }
    print "Suicide burn.                   "+ Vel:mag at(5,19).
  }
  // else{lock th to 0.}


}
function landing_spot{
  local target_vector is unrotate(up).

  lock st to target_vector.
  print "Searching for a landing spot. " at (5,19).
  if slope > 7{
    lock th to hover(0, Vv).
    lock target_vector to unrotate(up:vector-velocity:surface:normalized). print "Slope is acceptable." at (5,20).
  }
}
function land{
  if Vh<1{
    lock th to hover(-4,Vv).
    lock st to unrotate(up:vector-velocity:surface:normalized*0.15).
    print "landing                   " at (5,19).
  }
    else{
      lock th to hover(0,Vv).
      lock st to unrotate(up:vector-velocity:surface:normalized*0.2).
    }
}
until status = "landed"{
  // if Vv < 0  {
  //   if doneTimeManipulations = false {
  //     set doneTimeManipulations to true.
  //     set timeToImpactPlus to missiontime+impact().
  //   }
  //   set timeToImpact to timeToImpactPlus-missiontime.
  // }
  ship_stats().
  Real_impact_time().
  Real_burn_time().
  // RealerBurnTime().
  impact().
  imp_loc1().
  set slope to vang(slope(),up:vector).
  availtwr().
  if altRadar < heights[body:name]{
    if adv_altRadar > Lheights[body:name]{
      suicide_burn().
    }
    if adv_altRadar < Lheights[body:name] and slope > 7{
      landing_spot().
    }
    if slope < 7 and adv_altRadar < Lheights[body:name]{
      land().
    }
  }
  lock steering to st.
  lock throttle to th.
  print "StageDV                  " + round(stageDV)+"                "at(2,6).
  print "Burn time/impact time:   "+ round(Real_burn_time(),2) at (2,7).
  print "/" at (31,7).
  print + round(Real_impact_time(),2) at (32,7).
  // print "Impact in:               "+ round(Real_impact_time(),2) +     "              " at (2,8).
  Print "Throttle:                " + round(avgMaxA, 2)+"                  " at (2,9).
  print "Impact slope:            " +  round(vang(slope(),up:vector),1) +"              "at (2,10).
  print "altitude                 " + round(adv_altRadar,1) + "        " at (2,11).
  print "availtwr                 "+ round(availtwr(),1) + "               " at (2,12).
  print "Impact speed:            " + round(impact_speed) + "                " at (2,21).
  print avgMaxA at (2,22).
}


  // Print "Burn at:                     "+  +"              " at (2,10).

// FINAL BLOCK -----------------------------------------------------------------
lock steering to up.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
ship_stats().
set stageDV_left to stageDV.
clearscreen.
print "Looks landed to me." at (3,2).
Print "Used deltaV: "+ round((s_DV - stageDV_left),1) at (3,3).

sas on.
unlock steering.
clearvecdraws().
