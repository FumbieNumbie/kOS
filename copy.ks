// copypath("0:/library/main_functions.ks", "1:/main_functions").
//
// copypath("test.ks", "1:/test").
// copypath("launch.ks", "1:/launch").
//
// copypath("aponode.ks", "1:/aponode").
// copypath("perinode.ks", "1:/perinode").
// copypath("exenode.ks", "1:/exenode").
// copypath("land.ks", "1:/land").
//
// copypath("circle.ks", "1:/circle").
//
// copypath("warpfor.ks", "1:/warpfor").
//
// copypath("RCSexenode.ks", "1:/RCSexenode").
//
// copypath("PID.ks", "1:/PID").
// copypath("connection.ks", "1:/connection").
switch to 1.
runpath("0:/library/main_functions.ks").



set ScriptList to list(
  "test.ks",
  "launch.ks",
  "aponode.ks",
  "perinode.ks",
  "exenode.ks",
  "land.ks",
  "circle.ks",
  "warpfor.ks",
  "go.ks",
  "connection.ks").
for f in ScriptList
{
  download(f).
}
