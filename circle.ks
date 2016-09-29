declare parameter node.
// present orbit properties
set ra to body:radius + apoapsis.         // Ap radius
set rp to body:radius + periapsis.      // Pe radius
set a to (ra+rp)/2. 			//semimajor axis
set e to 1-2/(ra/rp +1).				//eccentricity, равно также (ra-rp)/(ra+rp)

if node = 1
{
  run aponode(ra,rp,a,e).
}
else if node = 0
{
  run perinode(ra,rp,a,e).
}
run exenode.
