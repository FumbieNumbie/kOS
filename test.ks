clearscreen.
set nd to nextnode.
lock dt to nd:eta.
set deg to orbit:period/360.
set nd_pos_lng to ship:geoposition:lng+deg*dt.
set nd_pos to 0.
set nd_pos to latlng(0,nd_pos_lng).
print ship:geoposition at (1,1).
print nd_pos+"---" at (2,2).
