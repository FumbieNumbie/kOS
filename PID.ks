function pid{
parameter setpoint
set pid to pidloop(2.7, 4.4, 0.12, 0, 1).
set pid:setpoint to setpoint.
}
