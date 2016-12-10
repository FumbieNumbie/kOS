switch to 1.
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
  deletepath("1:/"+f+"").
}
list files.
switch to 0.
