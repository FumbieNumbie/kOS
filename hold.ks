declare parameter vs.
clearscreen.
set done to 0.
set alpha to 0.
until done = 1
 {
   if ship:verticalspeed < vs
   {
     lock steering to heading(0,90) + r(0,alpha,0).
     set alpha to alpha+2.
   }
   else if ship:verticalspeed > vs
   {
     lock steering to heading(0,90) + r(0,alpha,0).
     set alpha to alpha-2.
   }
 }
