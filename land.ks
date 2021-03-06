



sas off.
rcs on.
gear on.
if addons:tr:available() = false {
  print "Trajectories mod is broken." at(0,8).
  wait until 1=2.
}
clearscreen.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
runpath("0:/library/functions.ks").

CLEARVECDRAWS().

// CONTROL VARIABLES BLOCK -----------------------------------------------------


set th to 0.
lock st to -velocity:surface.

// NATURAL VARIABLES BLOCK -----------------------------------------------------

lock centr_acc to abs(ship:groundspeed)/(body:RADIUS+altitude).
lock downwardAcceleration to g() - centr_acc.

// SHIP VARIABLES BLOCK --------------------------------------------------------
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

lock steering to st.
lock throttle to th.


set s_DV to stageDV. // For calculating spent dV


set Lheights to lexicon(                              //heights at wich slope search is activated
                        "mun", 90,
                        "minmus", 70,
                        "Kerbin",50
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

lock Real_impact_time to (Vv + sqrt(Vv*Vv + 2*adv_altRadar*downwardAcceleration))/max(downwardAcceleration,0.001).
lock Real_burn_time to Vel:mag/(maxa).
lock burnDist to Vel:mag ^2 / maxa / 2 + 28.
set distance to 0.
lock distance to sqrt(adv_altRadar^2 + (Vh*Real_impact_time)^2).


set startBurn to 0.
function suicide_burn{
  if burnDist>distance
  {
    // RUNONCEPATH("0:/startingLog.ks").

      lock th to hover(-5,Vv).
      if Vh>4
      {
        lock st to -Vel.
        print "Locked to -Vel                   "+ Vel:mag at(5,18).
      }
      else
      {
        // set st to unrotate(up:vector-velocity:surface:normalized*0.15).
        lock st to up:vector.
        print "Locked to up                     " at(5,18).
        RUNONCEPATH("0:/finalLog.ks").
      }
      print "Suicide burn.                   " at(5,19).
      print "vertical speed:                 "+ abs(Vv) at(5,17).


  }
  else{set th to 0.}
}
function landing_spot{
  local target_vector is unrotate(up).

  lock st to target_vector.
  print "Searching for a landing spot. " at (5,19).
  if slope > 7{
    lock th to hover(0, Vv).
    lock target_vector to unrotate(up:vector-velocity:surface:normalized).
  }
  else
  {
    print "Slope is acceptable." at (5,20).
  }
}
function land{
  if Vh<2{
    lock th to hover(-4,Vv).
    lock st to unrotate(up:vector-velocity:surface:normalized*0.15).
    print "Landing                   " at (5,19).
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



  // RealerBurnTime().
  impact().

  set slope to vang(slope(),up:vector).
  availtwr().
  if adv_altRadar > Lheights[body:name]{
    suicide_burn().
  }
  if adv_altRadar < Lheights[body:name]
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
  print "Distance to burn/altitude:   "+ round(burnDist,2)+"/" + round(distance,2) at (2,7).

  // print "Impact in:               "+ round(Real_impact_time,2) +     "              " at (2,8).
  Print "Throttle:                " + round(th, 2)+"                  " at (2,9).
  print "Impact slope:            " +  round(vang(slope(),up:vector),1) +"              "at (2,10).
  print "altitude                 " + round(adv_altRadar,1) + "        " at (2,11).
  // print "availtwr                 "+ round(availtwr(),1) + "               " at (2,12).
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

sas on.
unset steering.
clearvecdraws().
