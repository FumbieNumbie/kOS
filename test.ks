// runpath("0:/library/functions.ks").
// lock shipLatLang to ship:geoposition.
// lock surfElev to shipLatLang:terrainheight.
// lock altRadar to altitude-surfElev.
// stage.
// lock steering to up+r(0,-10, -90).
// lock throttle to 1.5/availtwr().
// wait 10.
// unlock steering.
// lock throttle to 0.
runpath("0:/land-1.ks").

// local hover_pid is pidloop(2.7, 4.4, 2.12, 0, 1).
// function hover {
//   parameter setpoint.
//   set hover_pid:setpoint to setpoint.
//   print setpoint.
//   set hover_pid:maxoutput to 5.
//   return hover_pid:output.
// }
// // function landing_spot{
// //   print "Searching landing spot " + altRadar at (5,19).
// //   if altRadar < 150{
// //
// //
// //
// //       lock th to hover(100, altRadar).
// //       lock steering to up.
// //
// //   }
// // }
// until 1=0{
//   hover(1000).
//
//   lock throttle to min(
//     hover_pid:update(time:seconds, altRadar) /
//     max(cos(vang(up:vector, ship:facing:vector)), 0.0001) /
//     max(availtwr(), 0.0001),
//     1
//   ).
// print hover(1000) at (4,4).
// }
