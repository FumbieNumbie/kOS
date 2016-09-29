set nd to nextnode.
list engines in engineList.
for eng in engineList
{
	set engISP to eng:isp.
}

set stageDV to 9.81 * engISP * ln(ship:mass / (ship:mass - (stage:LIQUIDFUEL+stage:oxidizer)*0.005)).
set usedF to 269.1/stageDV.
set m1 to ship:mass-(stage:liquidfuel+stage:oxidizer)*0.005*usedF*9.81.
set Mmean to ship:mass-m1.		//avarage mass of the ship.
set maxa to maxthrust/Mmean.
set dob to nd:deltav:mag/maxa. //duration of the burn.
print "T+" + round(missiontime) + " Max acc: " + round(maxa) + "m/s^2, Burn duration: " + round(dob) + "s".
