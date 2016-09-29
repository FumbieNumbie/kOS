set done to false.
clearscreen.
until done
{
  set engISP to 0.
  list engines in engineList.
  for eng in engineList
  {
  	set engISP to engISP + eng:maxthrust / maxthrust * eng:isp. //avarage ISP For all engines
  }
  log "engISP: " + engISP to log.txt.
  set g to 9.80665.
  set fuelmass to (stage:LIQUIDFUEL+stage:oxidizer)*0.005.
  set stageDV to g*engISP * ln(ship:mass / (ship:mass - fuelmass)). //calculating stage delta V.
  print stageDV at (4,4).
}
