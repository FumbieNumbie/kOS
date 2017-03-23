// execute maneuver node
set node1 to nextnode.
clearscreen.
print "T+" + round(missiontime) + " Node in: " + round(node1:eta) + ", DeltaV: " + round(node1:deltav:mag) at (5,5).
set engISP to 0.
function calculations{
	list engines in engineList.
	for eng in engineList
	{
		set eng:thrustlimit to 100.
		set engISP to engISP + eng:maxthrust / maxthrust * eng:isp. //average ISP For all active engines
	}
	// log "engISP: " + engISP to log.txt.
	set g to 9.80665.
	set fuelmass to (stage:LIQUIDFUEL+stage:oxidizer)*0.005.
	set stageDV to g*engISP * ln(ship:mass / (ship:mass - fuelmass)). //calculating stage delta V.
	set dm to ship:mass-ship:mass/constant:e^(node1:deltav:mag/(g*engISP)).//this is derived from the formula above,
	// but in this case for deltaV of the node, not the whole stage.
	set massFlowRate to maxthrust / (g*engISP).     // how fast I'm loosing mass via throwing fuel away.
	set dob to dm/massFlowRate.		//duration of the burn, fuel flow rate method.
}
calculations().
if stageDV/node1:deltaV:mag <0.5{
		stage.
		calculations().
}
sas off.

set tset to 0.
lock throttle to tset.

lock steering to node1.
set done to False.

set dv0 to node1:deltav.
set runmode to 0.


print "stageDV, m/s 			 " + round(stageDV).
print "Ship mass    			 " + round(ship:mass,2).


print "T+" + round(missiontime) +"s". //+ " Max acc: " + round(maxa)
print "Burn duration: " + round(dob,2) + "s".



if nextnode:eta-dob/2 > 15
{
	run warpfor(nextnode:eta-dob/2-11).
}

wait until node1:eta <= dob/2+1.
until done
{
	lock steering to node1.
	set maxa to maxthrust/mass+0.001.
	set VecAngle to vang(ship:facing:forevector,nextnode:deltav).
	for eng in engineList{
	if eng:flameout = true
	{
		stage.
		break.
	}
	}
	if VecAngle > 10 and node1:deltav:mag < 20{
		set tset to 0.
	}else{
		set tset to min(node1:deltav:mag/maxa, 1).
	}
	if node1:deltav:mag < 0.0005*dv0:mag
	{
		print "T+" + round(missiontime) + " Finalizing, remain dv " + round(node1:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, node1:deltav),1).
		wait until vdot(dv0, node1:deltav) < 0.5.
		lock throttle to 0.
		print "T+" + round(missiontime) + " End burn, remain dv " + round(node1:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, node1:deltav),1).
		set done to True.
		//vdot is a product of two vectors	returning a scalar number.
	}
	list engines in engineList.
	for eng in engineList
	if eng:flameout
	{
		stage.
		break.
	}
	lock throttle to tset.
}
unlock steering.
clearscreen.
set fuelmass to (stage:LIQUIDFUEL+stage:oxidizer)*0.005.
set stageDV to g*engISP * ln(ship:mass / (ship:mass - fuelmass)).
print "Remaining dV: " + round(stageDV,2) at (5,30).
print "T+" + round(missiontime) + " Apoapsis: " + round(apoapsis/1000,2) + "km, periapsis: " + round(periapsis/1000,2) + "km".
print "T+" + round(missiontime) + " Fuel after burn: " + round(stage:liquidfuel).
wait 1.
remove node1.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
