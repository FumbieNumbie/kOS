runpath("0:/copy.ks").
if ship:status = "PRELAUNCH"{

runpath("1:/launch.ks", 74, 0, 0).
}
lock throttle to 0.
wait 10.
if body:name = "kerbin"{
runpath("1:/transfer.ks").
}
