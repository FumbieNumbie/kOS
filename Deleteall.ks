switch to 1.
set ScriptList to list(
  "test",
  "land",
  "launch",
  "aponode",
  "perinode",
  "exenode",
  "circle",
  "warpfor",
  "transfer",
  "deleteall").
for f in ScriptList
{
  deletepath("1:/"+f+"").
}
list files.
switch to 0.
