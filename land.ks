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


set a to 0.


lock centr_acc to abs(ship:groundspeed)/(body:RADIUS+altitude).
lock downwardAcceleration to g() - centr_acc.


// SHIP VARIABLES BLOCK --------------------------------------------------------
set th to 0.
set Vv to 0.
local enThrust is 0.
local engISP is 0.
lock Vv to ship:verticalspeed.
lock steering to -ship:velocity:surface.
lock v1 to abs(ship:groundspeed).
lock maxa to maxthrust/mass.
lock maxtwr to maxa/g().
lock shipLatLang to ship:geoposition.
lock surfElev to shipLatLang:terrainheight.
lock altRadar to altitude-surfElev.
lock Vel to ship:velocity:surface.
lock Vh to ship:groundspeed.
lock adv_altRadar to altitude - body:geopositionof(imp_loc1()):terrainheight.

ship_stats().
set s_DV to stageDV.

set heights to lexicon("mun", 10000,
                      "minmus", 7000,
                      "Kerbin",2500).



core:part:getmodule("kosProcessor"):doevent("open terminal").

// function BLOCK ------------------------------------------------------------------
function unrotate {
  parameter vec. if vec:typename <> "Vector" set vec to vec:vector.
  return lookdirup(vec, ship:facing:topvector).
}

local hover_pid is pidloop(1.7, 4.4, 0.6, 0, 1).
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

function suicide_burn{
  if Real_burn_time()/Real_impact_time() > 1{
    lock th to hover(-15,Vv).
    lock steering to -Vel.
    print "suicide burn                  " at(5,19).
  }else{lock th to 0.}
}
function landing_spot{
  local target_vector is unrotate(up).

  lock steering to target_vector.
  print "Searching landing spot " at (5,19).
  if Vh > 2 or slope > 6{
    lock th to hover(0, Vv).
    if slope < 6{
      set target_vector to unrotate(up:vector-velocity:surface:normalized). print "Slope < 6°" at (5,20).
    }
    else{
      print "             " at (5,20).
      set target_vector to unrotate(up:vector * g() + slope()-velocity:surface:normalized).
    }
  }
}
function land{

  lock th to hover(-3,ship:verticalspeed).
  lock steering to unrotate(up:vector-velocity:surface:normalized*0.2).
  print "landing                   " at (5,19).
}
until status = "landed"{
  impact().
  imp_loc1().
  set slope to vang(slope(),up:vector).
  availtwr().
  if adv_altRadar > 70 and altRadar < heights[body:name]{
    suicide_burn().
  }
  if altRadar < 70{
    landing_spot().
  }
  if slope < 5 and altRadar < 70 and Vh< 1{
    land().
  }
  LOWHUD(round(Real_burn_time()),round(Real_impact_time())).
  ship_stats().
  lock throttle to th.
  print "StageDV                  " + round(stageDV)+"                "at(5,6).
  print "Burn time:               "+ round(Real_burn_time(),2) + "              " at (5,7).
  print "Impact in:               "+ round(Real_impact_time(),2) +     "              " at (5,8).
  Print "Throttle:                " + round(th, 2)+"                  " at (5,9).
  print "Impact slope:            " +  round(vang(slope(),up:vector),1) +"              "at (5,10).
  print "altitude                 " + round(adv_altRadar,1) + "        " at (5,11).
  print "availtwr                 "+ availtwr() + "               " at (5,12).
}


  // Print "Burn at:                     "+  +"              " at (5,10).

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
