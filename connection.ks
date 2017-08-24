// set pr2 to vessel("ComSat Probe 2").
set ant to ship:partstagged("2")[0].
set Module to ant:getmodulebyindex(0).
Module:doevent("extend antenna").
// Module:SETFIELD("target", pr2).
