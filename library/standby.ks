local done is false.
until done
{
  if exists("0:/new_instructions.ks")
  {
    runpath("0:/new_instructions.ks").
    movepath("0:/new_instructions.ks", "0:/new_instructions_bak.ks").
  }
  on ag9 {set done to true.}
  wait 10.
}
