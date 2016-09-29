declare parameter c.
declare parameter sign.
function sum
{
  set k to 0.
  set k to c+0.02*sign.
  return k.
}
print sign.
print k.
