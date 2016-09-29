// execute maneuver node
set nd to nextnode.
clearscreen.
print "T+" + round(missiontime) + " Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag) at (5,5).
set engISP to 270.
set engthrust to 4.

set stageDV to 9.81*engISP * ln(ship:mass / (ship:mass - (stage:monopropellant)*0.005)). //finding stage delta V. (mistake)
set massFlowRate to engthrust / (9.81*engISP).     // how fast I'm spending the fuel mass
set usedF to nd:deltav:mag/stageDV.		//what portion of the fuel will be used.
set dm to (stage:monopropellant)*0.005*usedF.
set m1 to ship:mass-dm. //mass after the burn.
set dob to dm/massFlowRate.		//duration of the burn, fuel flow rate method.
//set maxa to (maxthrust/(ship:mass*9.81)+maxthrust/(m1*9.81))/2.		//avarage magnitude of maximum acceleration during the burn.
//set dob to nd:deltav:mag/maxa. //duration of the burn.
//print "ship mass " + round(ship:mass,2) at (35,6).
//print "delta mass " + round(dm,2) at(5,6).
print "T+" + round(missiontime)  + "m/s^2, Burn duration: " + round(dob) + "s" at (5,7). //+ " Max acc: " + round(maxa)
//print "avarage mass " + Mmean at (5,8).


sas off.
rcs on.
//sas off.

set tset to 0.
lock throttle to tset.

lock steering to nd.
set done to False.

set dv0 to nd:deltav.

if exists("1:/io/doneWarp") = false
{
	run warpfor(nextnode:eta-dob/2-11).
	create("1:/io/doneWarp").
	print "Initiating burn in 11 seconds!" at(5,9).
//	run RCSexenode.
}

wait until nd:eta <= dob/2.
until done
{
	set maxa to engthrust/mass.
	set tset to min(nd:deltav:mag/maxa, 1).
	lock steering to nd.
	if nd:deltav:mag < 0.1
	{
		print "T+" + round(missiontime) + " Finalizing, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
		wait until vdot(dv0, nd:deltav) < 0.5.
		lock throttle to 0.
		print "T+" + round(missiontime) + " End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
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
print "T+" + round(missiontime) + " Apoapsis: " + round(apoapsis/1000,2) + "km, periapsis: " + round(periapsis/1000,2) + "km".
print "T+" + round(missiontime) + " Fuel after burn: " + round(stage:monopropellant).
wait 1.
remove nd.
deletepath("0:/io/done.txt").

//set throttle to 0 just in case.
SET SHIP:CONTROL:NEUTRALIZE to True.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
